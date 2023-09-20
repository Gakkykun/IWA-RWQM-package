Program main
  use,intrinsic :: iso_fortran_env
  use sim_calibration_flow
  implicit none

  integer :: npar = 3, max_iter=10, min_iter = 3
  integer i, j, low, hi, nhi, icalc, icount, dataset_number
  real(real64) :: beta = 0.5d0, gamma = 2.0d0, alpha = 1.0d0, &
                  factbound = 0.001d0, factini = 0.1d0, ftol = 0.005d0, factinsens = 0.01d0
  real(real64) ypr, yprr, fval, diff, diff_ns, diff2, threshold, threshold_ns, threshold2
  real(real64), allocatable :: par(:), minpar(:), maxpar(:), w_y(:), &
                                w_p(:,:), w_pbar(:), w_pr(:), w_prr(:)

  allocate(par(npar), minpar(npar), maxpar(npar), w_y(npar+1), w_p(npar+1, npar),  &
          w_pbar(npar), w_pr(npar), w_prr(npar))

  print*, 'Type data set number: 1, 2, or 3'
  read*, dataset_number

  if (dataset_number /= 1 .and. dataset_number /= 2 .and. dataset_number /= 3) then
    print*, 'Invalid input'
    stop
  end if


  ALLRiver_n=0.03d0; ALLRiver_I=0.0012d0; ALLRiver_B=6.8d0

  par(:) = [ALLRiver_n, ALLRiver_I, ALLRiver_B] 
  minpar(:) = [0.025d0, 0.001d0, 3.0d0]
  maxpar(:) = [0.055d0, 0.002d0, 12.0d0]

  ! The following code is transcribed from the C++ code of AQUASIM (Reichert, 1994)  

  ! Construction of initial simplex
  do j = 1, npar+1
    do i = 1, npar
      w_p(j,i) = par(i)
    end do
  end do

  do i = 1, npar
    w_p(i+1, i) = par(i) + factini * (maxpar(i) - minpar(i))
    if (w_p(i+1, i) >= maxpar(i)) then
      w_p(i+1, i) = par(i) - factini * (maxpar(i) - minpar(i))
    end if 
  end do

  print*, 'Base output calculation starting...'
  w_y(1) = output(npar, w_p(1, :), dataset_number)
  write ( *, '(a,g14.6)' ) 'Base chi2', w_y(1)                             
  print*, 'Base output calculation ended'

  do j = 2, npar+1     
    print*, w_p(j,:)
    w_y(j) = output(npar, w_p(j,:), dataset_number) 
    print*, 'j = ', j, 'output: ', w_y(j)
    
    ! w_p(j, j-1) = par(j-1) + 0.1d0 * (w_p(j, j-1) - par(j-1)) 
    ! w_y(j) = output(w_p(j,:)) 
    ! print*, 'decrease step size', 'j = ', j, 'output: ', w_y(j)
    print*, 'w_y(1): ', w_y(1)
    print*, 'w_y(j): ', w_y(j)

    diff = 2.0d0*abs(w_y(j)-w_y(1))
    threshold = factinsens/npar*ftol*(abs(w_y(j)+abs(w_y(1))))
    print*, 'diff: ', diff, 'threshold: ', threshold

    if (diff < threshold) then
      print*, 'not sensitive, try with minimum'
      w_p(j, j-1) = minpar(j-1) + factbound * (maxpar(j-1) - minpar(j-1))
      
      w_y(j) = output(npar, w_p(j,:), dataset_number) 
      print*, 'j = ', j, 'output: ', w_y(j)
      
      diff_ns = 2.0d0*abs(w_y(j)-w_y(1))
      threshold_ns = factinsens/npar*ftol*(abs(w_y(j)+abs(w_y(1))))
      print*, 'diff_ns: ', diff_ns, 'threshold_ns: ', threshold_ns


      if(diff_ns < threshold_ns) then
        print*, 'not sensitive, try with maximum'
        w_p(j, j-1) = maxpar(j-1) - factbound * (maxpar(j-1) - minpar(j-1))

        w_y(j) = output(npar, w_p(j,:), dataset_number) 
        print*, 'j = ', j, 'output: ', w_y(j)
      end if
    end if 
  end do

  icalc = npar
  icount = 0

  ! do j = 1, npar+1
  !   call trans_forw(w_p(j, :), minpar(:), maxpar(:), npar)
  ! end do 

  mainloop:do
    print*, 'Enter the main loop'

    ! Find highest and lowest Y values.
    low = 1

    if (w_y(1) > w_y(2)) then
      hi = 1; nhi = 2
    else
      hi = 2; nhi = 1
    end if 

    do j = 1, npar+1
      if (w_y(j) < w_y(low)) then
        low = j
      end if

      if (w_y(j) > w_y(hi)) then
        nhi = hi; hi = j
      else
        if(w_y(j) > w_y(nhi)) then
          if(j /= hi) then
            nhi = j
          end if
        end if
      end if
    end do

    do i = 1, npar
      par(i) = w_p(low, i)
    end do

    ! call trans_back(par(:), minpar(:), maxpar(:), npar) 
    fval = w_y(low) 
    print*, 'lowest chi2 ', fval, 'low: ', low, 'hi: ', hi

    diff2 = 2.0d0*abs(w_y(hi)-w_y(low))
    threshold2 = ftol * (abs(w_y(hi) + abs(w_y(low))))
    print*, 'diff2: ', diff2, 'loop exit threshold2: ', threshold2

    if (diff2 < threshold2 .and. icount > min_iter) then
      if (icalc /= low) then
        fval = output(npar, par(:), dataset_number)
      end if
      print*, 'icalc: ', icalc, ', low: ', low, 'icount: ', icount 
      print*, 'Exit the main loop'
      exit mainloop
    end if  

    if ( max_iter < icount ) then
      if (icalc /= low) then
        fval = output(npar, par(:), dataset_number)
      end if
      print*, 'icalc: ', icalc, ', low: ', low, 'icount: ', icount 

      print*, 'Exit the main loop, as the couter exceeds the max_iter'

      exit mainloop
    end if   
  
! Calculate PBAR, the centroid of the simplex vertices 

    w_pbar = 0.0d0

    do j = 1, npar+1
      if (j /= hi) then
        do i = 1, npar
          w_pbar(i) = w_pbar(i) + w_p(j, i)
        end do
      end if
    end do

    do i = 1, npar
      w_pbar(i) = w_pbar(i)/npar
      w_pr(i) = (1.0d0+alpha)*w_pbar(i) - alpha*w_p(hi, i)
    end do

    print*, 'Calling a subroutine...'
    call fun(w_pr(:), minpar(:), maxpar(:), npar, ypr, w_y(hi))

    print*, 'Reflection calculation starting...'
    ! print'(*(g0:,","))', 'parameter set',w_pr(:)
    ! ypr = output (w_pr(:))
    write ( *, '(a,g14.6)' ) 'Reflection chi2', ypr 


    icalc = npar + 1

    ! Condition #1
    if ( ypr < w_y(low)) then    
      ! Successful reflection, so extension.
      do i = 1, npar
        w_prr(i) = gamma * w_pr(i) + (1.0d0 - gamma) * w_pbar(i)
      end do

      call fun(w_prr(:), minpar(:), maxpar(:), npar, yprr, w_y(hi))

      print*, 'Extension calculation starting...'
      ! print*, 'Parameter set', w_prr(:)
      ! yprr = output( w_prr(:) )
      write ( *, '(a,g14.6)' ) 'Extension chi2', yprr

      ! Condition #2
      if ( yprr < w_y(low)) then
        do i = 1, npar
          w_p(hi,i) = w_prr(i)
        end do

        w_y(hi) = yprr
        icalc = hi

      ! Retain extension or contraction.
      else 
        do i = 1, npar
          w_p(hi,i) = w_pr(i)
        end do

        w_y(hi) = ypr
      end if ! # Condition #2

    ! No extension
    else  ! Condition #1

      ! Condition #3
      if (ypr >= w_y(nhi)) then
        
        ! Condition #4
        if (ypr < w_y(hi)) then
          do i = 1, npar
            w_p(hi, i) = w_pr(i)
            w_y(hi) = ypr
            icalc = hi
          end do

          do i = 1, npar
             w_prr(i) = beta * w_p(hi, i) + (1.0d0 - beta) * w_pbar(i)
          end do

          call fun(w_prr(:), minpar(:), maxpar(:), npar, yprr, w_y(hi))

          print*, 'Contraction calculation starting...'
          ! print*, 'Parameter set', w_prr(:)
          ! yprr = output ( w_prr(:) )
          write ( *, '(a,g14.6)' ) 'Contraction chi2', yprr

          ! Condition #5
          if ( yprr < w_y(hi)) then

            do i = 1, npar
              w_p(hi, i) = w_prr(i)
              w_y(hi) = yprr
              icalc = hi
            end do

          else 
            do j = 1, npar+1
              if (j /= low) then
                do i = 1, npar
                  w_p(j,i) = 0.5d0 * ( w_p(j,i) + w_p(low,i) )
                end do

                call fun(w_p(j, :), minpar(:), maxpar(:), npar, w_y(j), w_y(hi))

                print*, 'Whole contraction calculation starting...'
                ! print*, 'Parameter', w_p(j, :)
                write ( *, '(a,g14.6)' ) 'Whole contraction chi2', w_y(j)

                icalc = j
              end if
            end do
          end if  ! # Condition #5
        end if ! # Condition #4

      else ! # Condition #3
        do i = 1, npar
          w_p(hi, i) = w_pr(i)
        end do

        w_y(hi) = ypr
        icalc = hi
      end if ! # Condition #3

      icount = icount + 1
      print*, 'icount: ', icount
    end if ! # Condition #1

  end do mainloop


write ( *, '(a)' ) '  Parameter estimated:'
write ( *, '(a)' ) ' '
do i = 1, npar
  write ( *, '(2x,g14.6)' ) w_p(low, i)
end do

write ( *, '(a)' ) ' '
write ( *, '(a,g14.6)' ) '  Chi2 = ', fval

write ( *, '(a)' ) ' '
write ( *, '(a,i8)' ) '  Number of iterations = ', icount


contains
subroutine fun(par, min, max, npar, fval, fref)
  integer, intent(in) :: npar
  real(real64), intent(in) :: min(:), max(:), fref
  real(real64), intent(inout) :: par(:)
  real(real64), intent(out) :: fval
  
  ! real(real64) ptrans(npar)
  integer i

  print*, 'In a subroutine'

  do i=1, npar
    if ( par(i) < min(i)) then
      fval = 2.0*abs(fref)
      par(i) = min(i)
    end if 
    
    if (par(i) > max(i)) then
      fval = 2.0*abs(fref)
      par(i) = max(i)
    end if
  end do

  fval = output(npar, par(:), dataset_number)

  ! do i=1, npar 
  !   ptrans(i) = par(i)
  ! end do 
   
  ! call trans_back(ptrans,min,max,npar);      
   
end subroutine

! subroutine trans_forw(par, min, max, npar)
!   integer, intent(in) :: npar
!   real(real64), intent(in) :: min(:), max(:) 
!   real(real64), intent(inout) :: par(:)
!   real(real64) pi

!   pi=4.0*atan(1.0)

!   do i = 1, npar
!      par(i) = tan(pi*0.5*(2.0*par(i)-min(i)-max(i))/(max(i)-min(i)))
!   end do

! end subroutine

! subroutine trans_back(par, min, max, npar)
!   integer, intent(in) :: npar
!   real(real64), intent(in) :: min(:), max(:)
!   real(real64), intent(inout) :: par(:)
!   real(real64) pi

!   pi=4.0*atan(1.0)

!   do i=1, npar
!       par(i) = 0.5*(min(i)+max(i)) +(max(i)-min(i))/pi*atan(par(i))
!   end do

! end subroutine

end program main