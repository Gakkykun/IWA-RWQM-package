Program main
    use,intrinsic :: iso_fortran_env
    use :: River_WQ
    implicit none

    integer dataset_number, month_counter,  i
    logical ex
    real(real64) conc_data(1:num_variables)


    ! The following two commands works only for gfortran compiler
    inquire(file='./output-csv/.', exist=ex)


    if (ex) then
      print*, 'Necessary directory already there'
      print*, 'Delete csv files inside the directory...'
      print*, ''
      call system ('cd output-csv/ && rm -f *.csv')
      ! Use the followings in the Windows system instead
      ! call system ('cd output-csv && del *.csv')

    else       
        print*, 'Creating a necessary directory'
        call system('mkdir output-csv' ) 

    end if

    print*, 'Simulation starting...'

    print*, 'Type data set number: 1, 2, or 3'
    read*, dataset_number

    if (dataset_number /= 1 .and. dataset_number /= 2 .and. dataset_number /= 3) then
        print*, 'Invalid input'
        stop
    end if

    ! print*, 'Using dataset_number 1...'    
    ! dataset_number = 1

    do i = 1, month_run
        month_counter = i
        call river(dataset_number, conc_data, month_counter, &
            overwrite_params = [0.0d0], &
            is_print_results = .true., &
            is_output = .true., is_kinetic = .false.)  
    end do 

    ! print*, 'Using dataset_number 2...'    
    ! dataset_number = 2
    
    ! do i = 1, month_run
    !     month_counter = i
    !     call river(dataset_number, conc_data, month_counter, &
    !         overwrite_params = [0.0d0], &
    !         is_print_results = .true., &
    !         is_output = .true., is_kinetic = .false.)    
    ! end do
    
    ! print*, 'Using dataset_number 3...'    
    ! dataset_number = 3
    
    ! do i = 1, month_run
    !     month_counter = i
    !     call river(dataset_number, conc_data, month_counter, &
    !         overwrite_params = [0.0d0], &
    !         is_print_results = .true., &
    !         is_output = .true., is_kinetic = .false.)    
    ! end do

    print*, 'Simulation completed...'



end program main