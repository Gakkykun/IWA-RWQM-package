Program main
    use,intrinsic :: iso_fortran_env
    use :: param_pool_2
     use :: sim_sensitivity_WQ
    implicit none

    integer i, j, dataset_index 
    real(real64) Ss_GW_shift, SNH4_GW_shift, SNO2_GW_shift, SNO3_GW_shift, SHPO4_GW_shift, XH_GW_shift, XN1_GW_shift
    real(real64) XN2_GW_shift, XS_GW_shift 
    real(real64) Ss_TG_shift, SNH4_TG_shift, SNO2_TG_shift, SNO3_TG_shift, SHPO4_TG_shift, XH_TG_shift, XN1_TG_shift
    real(real64) XN2_TG_shift, XS_TG_shift 
    real(real64) Ss_TB_shift, SNH4_TB_shift, SNO2_TB_shift, SNO3_TB_shift, SHPO4_TB_shift, XH_TB_shift, XN1_TB_shift
    real(real64) XN2_TB_shift,  XS_TB_shift
    real(real64) Ss_KU_shift, SNH4_KU_shift, SNO2_KU_shift, SNO3_KU_shift, SHPO4_KU_shift, XH_KU_shift, XN1_KU_shift
    real(real64) XN2_KU_shift,  XS_KU_shift 
    real(real64) ratio_G_jkc_shift, ratio_G_direct_shift

    real(real64) base_output(num_output), start(num_target_params), parameter_shift(num_target_params,num_target_params), &
            delta_parameters(num_target_params), shift_output(num_output,num_target_params), &
            diff_output(num_output,num_target_params), &
            parameter_sig(num_target_params), shift_list(num_target_params)
    real(real64) shift_factor, delta_factor 
    real(real64) par(num_params_2)
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
   

    par(:) = param_pooling_2(overwrite_params = [0.0d0], param_id_list=[0], is_overwrite=.false.)

    ! Ss_GW=par(1); SNH4_GW=par(2); SNO2_GW=par(3); SNO3_GW=par(4); SHPO4_GW=par(5) 
    ! XH_GW=par(6); XN1_GW=par(7); XN2_GW=par(8); XS_GW=par(9);

    ! Ss_TG=par(10); SNH4_TG=par(11); SNO2_TG=par(12); SNO3_TG=par(13); SHPO4_TG=par(14) 
    ! XH_TG=par(15); XN1_TG=par(16); XN2_TG=par(17); XS_TG=par(18)

    ! Ss_TB=par(19);  SNH4_TB=par(20); SNO2_TB=par(21); SNO3_TB=par(22); SHPO4_TB=par(23) 
    ! XH_TB=par(24); XN1_TB=par(25); XN2_TB=par(26); XS_TB=par(27); 

    ! Ss_KU=par(28);  SNH4_KU=par(29); SNO2_KU=par(30); SNO3_KU=par(31); SHPO4_KU=par(32) 
    ! XH_KU=par(33); XN1_KU=par(34); XN2_KU=par(35); XS_KU=par(36); 
    
    ! ratio_G_jkc = par(37); ratio_G_direct = par(38)
    
    ! delta_params should be 1% of sd of a parameter, not a parameter value itself
    shift_factor = 1.01d0
    delta_factor = 0.01d0

    Ss_GW_shift= Ss_GW * shift_factor
    SNH4_GW_shift= SNH4_GW * shift_factor
    SNO2_GW_shift= SNO2_GW * shift_factor
    SNO3_GW_shift= SNO3_GW * shift_factor
    SHPO4_GW_shift= SHPO4_GW * shift_factor
    XH_GW_shift= XH_GW * shift_factor
    XN1_GW_shift = XN1_GW * shift_factor
    XN2_GW_shift= XN2_GW * shift_factor
    ! XALG_GW_shift= XALG_GW * shift_factor
    ! XCON_GW_shift= XCON_GW* shift_factor
    XS_GW_shift= XS_GW * shift_factor

    Ss_TG_shift = Ss_TG * shift_factor
    SNH4_TG_shift = SNH4_TG * shift_factor
    SNO2_TG_shift = SNO2_TG * shift_factor
    SNO3_TG_shift = SNO3_TG * shift_factor
    SHPO4_TG_shift = sHPO4_TG * shift_factor
    XH_TG_shift = XH_TG * shift_factor
    XN1_TG_shift = XN1_TG * shift_factor
    XN2_TG_shift = XN2_TG * shift_factor
    ! XALG_TG_shift = XALG_TG * shift_factor
    ! XCON_TG_shift = XCON_TG * shift_factor
    XS_TG_shift = XS_TG * shift_factor

    Ss_TB_shift = Ss_TB* shift_factor
    SNH4_TB_shift = SNH4_TB* shift_factor
    SNO2_TB_shift = SNO2_TB* shift_factor
    SNO3_TB_shift = SNO3_TB* shift_factor
    SHPO4_TB_shift = SHPO4_TB* shift_factor
    XH_TB_shift = XH_TB* shift_factor
    XN1_TB_shift = XN1_TB*shift_factor
    XN2_TB_shift = XN2_TB* shift_factor
    ! XALG_TB_shift = XALG_TB* shift_factor
    ! XCON_TB_shift = XCON_TB* shift_factor
    XS_TB_shift = XS_TB* shift_factor
    
    Ss_KU_shift = Ss_KU * shift_factor
    SNH4_KU_shift = SNH4_KU * shift_factor
    SNO2_KU_shift = SNO2_KU * shift_factor
    SNO3_KU_shift = SNO3_KU * shift_factor
    SHPO4_KU_shift = SHPO4_KU * shift_factor
    XH_KU_shift = XH_KU * shift_factor
    XN1_KU_shift = XN1_KU * shift_factor
    XN2_KU_shift = XN2_KU * shift_factor
    ! XALG_KU_shift = XALG_KU * shift_factor
    ! XCON_KU_shift = XCON_KU * shift_factor
    XS_KU_shift = XS_KU * shift_factor

    ! Dis_rate_shift = Dis_rate * shift_factor
    ratio_G_jkc_shift = ratio_G_jkc * shift_factor
    ratio_G_direct_shift = ratio_G_direct * shift_factor


    shift_list(:) = [Ss_GW_shift, SNH4_GW_shift, SNO2_GW_shift, SNO3_GW_shift, &
      SHPO4_GW_shift, XH_GW_shift, XN1_GW_shift, &
      XN2_GW_shift, XS_GW_shift, & 
      Ss_TG_shift, SNH4_TG_shift, SNO2_TG_shift, SNO3_TG_shift, &
      SHPO4_TG_shift, XH_TG_shift, XN1_TG_shift, XN2_TG_shift, XS_TG_shift, &
      Ss_TB_shift, SNH4_TB_shift, SNO2_TB_shift, SNO3_TB_shift, &
      SHPO4_TB_shift, XH_TB_shift, XN1_TB_shift, XN2_TB_shift, XS_TB_shift, &
      Ss_KU_shift, SNH4_KU_shift, SNO2_KU_shift, SNO3_KU_shift, &
      SHPO4_KU_shift, XH_KU_shift, XN1_KU_shift, XN2_KU_shift, &
      XS_KU_shift, & !Dis_rate_shift, 
      ratio_G_jkc_shift, ratio_G_direct_shift]

    delta_parameters(:) = [Ss_GW*delta_factor, SNH4_GW*delta_factor, SNO2_GW*delta_factor, &
      SNO3_GW*delta_factor, SHPO4_GW*delta_factor, XH_GW*delta_factor, XN1_GW*delta_factor, XN2_GW*delta_factor, &
      XS_GW*delta_factor, & 
      Ss_TG*delta_factor, SNH4_TG*delta_factor, SNO2_TG*delta_factor, SNO3_TG*delta_factor, &
      SHPO4_TG*delta_factor, XH_TG*delta_factor, XN1_TG*delta_factor, XN2_TG*delta_factor, XS_TG*delta_factor, & 
      Ss_TB*delta_factor, SNH4_TB*delta_factor, SNO2_TB*delta_factor, SNO3_TB*delta_factor, &
      SHPO4_TB*delta_factor, XH_TB*delta_factor, XN1_TB*delta_factor, XN2_TB*delta_factor, XS_TB*delta_factor, &
      Ss_KU*delta_factor, SNH4_KU*delta_factor, SNO2_KU*delta_factor, SNO3_KU*delta_factor, &
      SHPO4_KU*delta_factor, XH_KU*delta_factor, XN1_KU*delta_factor, XN2_KU*delta_factor, XS_KU*delta_factor, &
      ratio_G_jkc*delta_factor, ratio_G_direct*delta_factor]


    start(:) = [Ss_GW, SNH4_GW, SNO2_GW, SNO3_GW, SHPO4_GW, XH_GW, XN1_GW, XN2_GW, XS_GW, & 
      Ss_TG, SNH4_TG, SNO2_TG, SNO3_TG, SHPO4_TG, XH_TG, XN1_TG, XN2_TG, XS_TG, & 
      Ss_TB, SNH4_TB, SNO2_TB, SNO3_TB, SHPO4_TB, XH_TB, XN1_TB, XN2_TB, XS_TB, &
      Ss_KU, SNH4_KU, SNO2_KU, SNO3_KU, SHPO4_KU, XH_KU, XN1_KU, XN2_KU, XS_KU, &
      ratio_G_jkc, ratio_G_direct]

  
    do j = 1, 3

      dataset_index = j

      print*, 'Base output calculation starting...'
      base_output(:) = output(start(:), dataset_index) 
      print*, 'Base output calculation ended'


      do i = 1, num_target_params
        parameter_shift(i, :) = [Ss_GW, SNH4_GW, SNO2_GW, SNO3_GW, SHPO4_GW, &
            XH_GW, XN1_GW, XN2_GW, XS_GW, & 
            Ss_TG, SNH4_TG, SNO2_TG, SNO3_TG, SHPO4_TG, &
            XH_TG, XN1_TG, XN2_TG, XS_TG, & 
            Ss_TB, SNH4_TB, SNO2_TB, SNO3_TB, SHPO4_TB, &
            XH_TB, XN1_TB, XN2_TB,  XS_TB, &
            Ss_KU, SNH4_KU, SNO2_KU, SNO3_KU, SHPO4_KU, &
            XH_KU, XN1_KU, XN2_KU,  XS_KU, &
            ratio_G_jkc, ratio_G_direct]
        parameter_shift(i,i) = shift_list(i)
      end do

      if (dataset_index == 1) then
        open(unit=31, file='./sensitivity-output/sensitivity-1.csv')
        open(unit=32, file='./sensitivity-output/output-1.csv')
        write(32, '(*(g0:,","))') base_output(:)
        print*, 'Running for dataset 1...';
        
        do i = 1, num_target_params
          write ( *, '(a,i2)' ) 'Sensitivity calculation starting, no.', i
          shift_output(:,i) = output(parameter_shift(i,:), dataset_index)          
          diff_output(:,i) = abs(shift_output(:,i)-base_output(:))/delta_parameters(i) 
          ! print*, 'base_output', base_output(1)
          ! print*, 'shift_output', shift_output(1, i)
          write(31, '(*(g0:,","))') diff_output(:,i)
          write ( *, '(a,i2)' ) 'Sensitivity calculation ended, no.', i
        end do


        close(31)
        close(32)
      else if (dataset_index == 2) then
        open(unit=33, file='./sensitivity-output/sensitivity-2.csv')
        open(unit=34, file='./sensitivity-output/output-2.csv')
        write(34, '(*(g0:,","))') base_output(:)
        print*, 'Running for dataset 2...';
        do i = 1, num_target_params
          write ( *, '(a,i2)' ) 'Sensitivity calculation starting, no.', i
          shift_output(:,i) = output(parameter_shift(i,:), dataset_index)
          diff_output(:,i) = abs(shift_output(:,i)-base_output(:))/delta_parameters(i)
          write(33, '(*(g0:,","))') diff_output(:,i)
          write ( *, '(a,i2)' ) 'Sensitivity calculation ended, no.', i
        end do


        close(33)
        close(34)

      else if (dataset_index == 3) then
        open(unit=35, file='./sensitivity-output/sensitivity-3.csv')
        open(unit=36, file='./sensitivity-output/output-3.csv')
        write(36, '(*(g0:,","))') base_output(:)
        print*, 'Running for dataset 3...';
        do i = 1, num_target_params
          write ( *, '(a,i2)' ) 'Sensitivity calculation starting, no.', i
          shift_output(:,i) = output(parameter_shift(i,:), dataset_index)
          diff_output(:,i) = abs(shift_output(:,i)-base_output(:))/delta_parameters(i)
          write(35, '(*(g0:,","))') diff_output(:,i)
          write ( *, '(a,i2)' ) 'Sensitivity calculation ended, no.', i
        end do

        close(35)
        close(36)

      end if

    end do

    
end program main