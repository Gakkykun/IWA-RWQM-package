Program main
    use,intrinsic :: iso_fortran_env
    use :: param_pool
    use :: sim_sensitivity_kinetic
    implicit none

    integer i, j, dataset_index
    real(real64) Kgrowth_ALG_shift, Kgrowth_Haer_shift, Khyd_shift, KNH_aer_shift, &
                KO2_Haer_shift, KS_Haer_shift, Kgrowth_Anox_shift, KS_Anox_shift, Kgrowth_N1_shift, Kgrowth_N2_shift, & 
                Kdeath_ALG_shift, Kdeath_CON_shift, Kgrowth_CON_shift, Kresp_ALG_shift, Kresp_CON_shift, &
                Kresp_Haer_shift, Kresp_Anox_shift, Kresp_N1_shift, Kresp_N2_shift, KHPO4_ALG_shift, KHPO4_Haer_shift, &
                KHPO4_Anox_shift, KHPO4_N1_shift, KHPO4_N2_shift, KN_ALG_shift, KNH4_ALG_shift, KNH4_N1_shift, &
                K1_shift, KNO3_Anox_shift, KNO2_Anox_shift, KNO2_N2_shift, KO2_ALG_shift, KO2_CON_shift, & 
                KO2_N1_shift, KO2_N2_shift

    real(real64) base_output(num_output)
    real(real64) start(num_target_params), parameter_shift(num_target_params,num_target_params), &
            delta_parameters(num_target_params), &
            shift_output(num_output,num_target_params), diff_output(num_output,num_target_params), &
            parameter_sig(num_target_params), shift_list(num_target_params)
    real(real64) shift_factor, delta_factor
    real(real64) par(num_params)  
    logical ex 


    ! The following two commands works only for gfortran compiler
    inquire(file='./sensitivity-output/.', exist=ex) 

    if (ex) then
      print*, 'Necessary directory already there'
      print*, 'Delete csv files inside the directory...'
      print*, ''
      call system ('cd sensitivity-output/ && rm -f *.csv')

      ! Use the followings in the Windows system instead
      ! call system ('cd sensitivity-output && del *.csv')

    else       
        print*, 'Creating a necessary directory'
        call system('mkdir sensitivity-output' ) 
    end if


    par(:) = param_pooling(overwrite_params = [0.0d0], param_id_list=[0], is_overwrite=.false.)

    ! Kdeath_CON = par(1)
    ! Kgrowth_CON = par(2)
    ! Kresp_CON = par(3)
    ! Kresp_N2 = par(4)
    ! KHPO4_ALG = par(5)
    ! KHPO4_Haer = par(6)
    ! KHPO4_Anox = par(7)
    ! KHPO4_N1 = par(8)
    ! KHPO4_N2 = par(9)
    ! KN_ALG = par(10)
    ! KNH4_ALG = par(11)
    ! KNO3_Anox = par(12)
    ! KNO2_Anox = par(13)
    ! KO2_ALG = par(14)
    ! KO2_CON = par(15)
    ! KO2_N1 = par(16)
    ! Kresp_Haer = par(24)
    ! Kresp_N1 = par(25)
    ! K1 = par(26)
    ! Kgrowth_N2 = par(27)
    ! Kgrowth_Haer = par(28)
    ! KS_Haer = par(29)
    ! Kgrowth_ALG = par(30)
    ! Kgrowth_Anox = par(31)
    ! Kdeath_ALG = par(32)
    ! KO2_Haer = par(33)
    ! KNH_aer = par(34)
    ! KS_Anox = par(35)
    ! Kresp_ALG = par(36)
    ! Kresp_Anox = par(37)
    ! KNO2_N2 = par(38)
    ! KO2_N2 = par(39)
    ! Khyd = par(40)
    ! Kgrowth_N1  = par(41)
    ! KNH4_N1 = par(42)

    
    ! delta_params should be 1% of sd of a parameter, not a parameter value itself
    shift_factor = 1.01d0
    delta_factor = 0.01d0

    Kgrowth_ALG_shift = Kgrowth_ALG * shift_factor
    Kgrowth_Haer_shift = Kgrowth_Haer * shift_factor
    Khyd_shift = Khyd * shift_factor
    KNH_aer_shift = KNH_aer * shift_factor
    KO2_Haer_shift = KO2_Haer * shift_factor
    KS_Haer_shift = KS_Haer * shift_factor
    Kgrowth_Anox_shift = Kgrowth_Anox * shift_factor
    KS_Anox_shift = KS_Anox * shift_factor
    Kgrowth_N1_shift = Kgrowth_N1 * shift_factor
    Kgrowth_N2_shift = Kgrowth_N2 * shift_factor
    Kdeath_ALG_shift = Kdeath_ALG * shift_factor
    Kdeath_CON_shift = Kdeath_CON * shift_factor
    Kgrowth_CON_shift = Kgrowth_CON * shift_factor
    Kresp_ALG_shift = Kresp_ALG * shift_factor
    Kresp_CON_shift = Kresp_CON * shift_factor
    Kresp_Haer_shift = Kresp_Haer * shift_factor
    Kresp_Anox_shift = Kresp_Anox * shift_factor
    Kresp_N1_shift = Kresp_N1 * shift_factor
    Kresp_N2_shift = Kresp_N2 * shift_factor
    KHPO4_ALG_shift = KHPO4_ALG * shift_factor
    KHPO4_Haer_shift = KHPO4_Haer * shift_factor
    KHPO4_Anox_shift = KHPO4_Anox * shift_factor
    KHPO4_N1_shift = KHPO4_N1 * shift_factor
    KHPO4_N2_shift = KHPO4_N2 * shift_factor
    KN_ALG_shift = KN_ALG * shift_factor
    KNH4_ALG_shift = KNH4_ALG * shift_factor
    KNH4_N1_shift = KNH4_N1 * shift_factor
    K1_shift = K1 * shift_factor
    KNO3_Anox_shift = KNO3_Anox * shift_factor
    KNO2_Anox_shift = KNO2_Anox * shift_factor
    KNO2_N2_shift = KNO2_N2 * shift_factor
    KO2_ALG_shift = KO2_ALG * shift_factor
    KO2_CON_shift = KO2_CON * shift_factor
    KO2_N1_shift = KO2_N1 * shift_factor
    KO2_N2_shift = KO2_N2 * shift_factor


    shift_list(:) = [Kgrowth_ALG_shift, Kgrowth_Haer_shift, Khyd_shift, KNH_aer_shift, KO2_Haer_shift, &
                    KS_Haer_shift, Kgrowth_Anox_shift, KS_Anox_shift, Kgrowth_N1_shift, Kgrowth_N2_shift, &
                    Kdeath_ALG_shift, Kdeath_CON_shift, Kgrowth_CON_shift, Kresp_ALG_shift, Kresp_CON_shift, &
                    Kresp_Haer_shift, Kresp_Anox_shift, Kresp_N1_shift, Kresp_N2_shift, KHPO4_ALG_shift, &
                    KHPO4_Haer_shift, KHPO4_Anox_shift, KHPO4_N1_shift, KHPO4_N2_shift, KN_ALG_shift, &
                    KNH4_ALG_shift, KNH4_N1_shift, K1_shift, KNO3_Anox_shift, KNO2_Anox_shift, KNO2_N2_shift, & 
                    KO2_ALG_shift, KO2_CON_shift, KO2_N1_shift, KO2_N2_shift] !, &
                    ! Dis_rate_shift, ratio_G_jkc_shift, ratio_G_direct_shift]

    delta_parameters(:) = [Kgrowth_ALG*delta_factor, Kgrowth_Haer*delta_factor, Khyd*delta_factor, &
        KNH_aer*delta_factor, KO2_Haer*delta_factor, KS_Haer*delta_factor, Kgrowth_Anox*delta_factor, &
        KS_Anox*delta_factor, Kgrowth_N1*delta_factor, Kgrowth_N2*delta_factor, &
        Kdeath_ALG*delta_factor, Kdeath_CON*delta_factor, Kgrowth_CON*delta_factor, Kresp_ALG*delta_factor, &
        Kresp_CON*delta_factor, Kresp_Haer*delta_factor, Kresp_Anox*delta_factor, Kresp_N1*delta_factor, &
        Kresp_N2*delta_factor, KHPO4_ALG*delta_factor, KHPO4_Haer*delta_factor, KHPO4_Anox*delta_factor, &
        KHPO4_N1*delta_factor, KHPO4_N2*delta_factor, KN_ALG*delta_factor, KNH4_ALG*delta_factor, &
        KNH4_N1*delta_factor, K1*delta_factor, KNO3_Anox*delta_factor, KNO2_Anox*delta_factor, KNO2_N2*delta_factor, & 
        KO2_ALG*delta_factor, KO2_CON*delta_factor, KO2_N1*delta_factor, KO2_N2*delta_factor] !, &
        ! Dis_rate*delta_factor, ratio_G_jkc*delta_factor, ratio_G_direct*delta_factor]


    start(:) = [Kgrowth_ALG, Kgrowth_Haer, Khyd, KNH_aer, KO2_Haer, KS_Haer, Kgrowth_Anox, KS_Anox, &
                Kgrowth_N1, Kgrowth_N2, Kdeath_ALG, Kdeath_CON, Kgrowth_CON, Kresp_ALG, Kresp_CON, Kresp_Haer, & 
                Kresp_Anox, Kresp_N1, Kresp_N2, KHPO4_ALG, KHPO4_Haer, KHPO4_Anox, KHPO4_N1, & 
                KHPO4_N2, KN_ALG, KNH4_ALG, KNH4_N1, K1, KNO3_Anox, KNO2_Anox, KNO2_N2, & 
                KO2_ALG, KO2_CON, KO2_N1, KO2_N2] !, &
                ! Dis_rate, ratio_G_jkc, ratio_G_direct]

    do j = 1, 3

      dataset_index = j

      print*, 'Base output calculation starting...'

      base_output(:) = output(start(:), dataset_index) 
      print*, 'Base output calculation ended'


      do i = 1, num_target_params
        parameter_shift(i, :) = [Kgrowth_ALG, Kgrowth_Haer, Khyd, KNH_aer, KO2_Haer, KS_Haer, Kgrowth_Anox, KS_Anox, &
                  Kgrowth_N1, Kgrowth_N2, Kdeath_ALG, Kdeath_CON, Kgrowth_CON, Kresp_ALG, Kresp_CON, Kresp_Haer, & 
                  Kresp_Anox, Kresp_N1, Kresp_N2, KHPO4_ALG, KHPO4_Haer, KHPO4_Anox, KHPO4_N1, & 
                  KHPO4_N2, KN_ALG, KNH4_ALG, KNH4_N1, K1, KNO3_Anox, KNO2_Anox, KNO2_N2, & 
                  KO2_ALG, KO2_CON, KO2_N1, KO2_N2] 
        parameter_shift(i,i) = shift_list(i)
      end do


      if (dataset_index == 1) then
        open(unit=21, file='./sensitivity-output/sensitivity-1.csv')
        open(unit=22, file='./sensitivity-output/output-1.csv')
        write(22, '(*(g0:,","))') base_output(:)
        print*, 'Running for dataset 1...';
        
        do i = 1, num_target_params
          write ( *, '(a,i2)' ) 'Sensitivity calculation starting, no.', i
          shift_output(:,i) = output(parameter_shift(i,:), dataset_index)
          diff_output(:,i) = abs(shift_output(:,i)-base_output(:))/delta_parameters(i) 
          ! print*, 'base_output', base_output(1)
          ! print*, 'shift_output', shift_output(1, i)
          write(21, '(*(g0:,","))') diff_output(:,i)
          write ( *, '(a,i2)' ) 'Sensitivity calculation ended, no.', i
        end do

        close(21)
        close(22)
      else if (dataset_index == 2) then
        open(unit=23, file='./sensitivity-output/sensitivity-2.csv')
        open(unit=24, file='./sensitivity-output/output-2.csv')
        write(24, '(*(g0:,","))') base_output(:)
        print*, 'Running for dataset 2...';
        do i = 1,  num_target_params
          write ( *, '(a,i2)' ) 'Sensitivity calculation starting, no.', i
          shift_output(:,i) = output(parameter_shift(i,:), dataset_index)
          diff_output(:,i) = abs(shift_output(:,i)-base_output(:))/delta_parameters(i)
          ! diff_output(:,i) = (shift_output(:,i)-base_output(:))/delta_parameters(i)
          write(23, '(*(g0:,","))') diff_output(:,i)
          write ( *, '(a,i2)' ) 'Sensitivity calculation ended, no.', i
        end do

        close(23)
        close(24)

      else if (dataset_index == 3) then
        open(unit=25, file='./sensitivity-output/sensitivity-3.csv')
        open(unit=26, file='./sensitivity-output/output-3.csv')
        write(26, '(*(g0:,","))') base_output(:)
        print*, 'Running for dataset 3...';
        do i = 1, num_target_params
          write ( *, '(a,i2)' ) 'Sensitivity calculation starting, no.', i
          shift_output(:,i) = output(parameter_shift(i,:), dataset_index)
          diff_output(:,i) = abs(shift_output(:,i)-base_output(:))/delta_parameters(i)
          write(25, '(*(g0:,","))') diff_output(:,i)
          write ( *, '(a,i2)' ) 'Sensitivity calculation ended, no.', i
        end do

        close(25)
        close(26)

      end if

    end do

    
end program main