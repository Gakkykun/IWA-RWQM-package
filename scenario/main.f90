Program main
    use,intrinsic :: iso_fortran_env
    use :: param_pool_2
     use :: sim_sensitivity_WQ
    implicit none

    integer i, j, dataset_index    
    real(real64) Ss_TG_shift10dec, &
                  Ss_TG_shift50dec, &
                  Ss_TG_shift90dec, &
                  Ss_TG_shift10inc, &
                  Ss_TG_shift50inc, &
                  Ss_TG_shift100inc, &
                  ! SNH4_TB_shift10, &
                  ! SNH4_TB_shift50, &
                  ! SNH4_TB_shift90, &
                  Ss_KU_shift10dec, &
                  Ss_KU_shift50dec, &
                  Ss_KU_shift90dec, &
                  Ss_KU_shift10inc, &
                  Ss_KU_shift50inc, &
                  Ss_KU_shift100inc, &
                  ! XS_TG_shift10, &
                  ! XS_TG_shift50, &
                  ! XS_TG_shift90, &
                  ! XS_KU_shift10, &
                  ! XS_KU_shift50, &
                  ! XS_KU_shift90, &
                  ! ratio_G_jkc_shift10, &
                  ! ratio_G_jkc_shift50, &
                  ratio_G_direct_shift10, &
                  ratio_G_direct_shift50
    integer, parameter :: num_scenario_cases = 14
    real(real64) base_output(num_output), start(num_target_params), parameter_shift(num_target_params,num_target_params), &
            scenario_output(num_output,num_target_params), shift_list(num_scenario_cases)
    real(real64) shift_factor10inc, shift_factor50inc, shift_factor100inc, & 
                shift_factor10dec, shift_factor50dec, shift_factor90dec
    real(real64) par(num_params_2)
    logical ex 


    ! The following two commands works only for gfortran compiler
    inquire(file='./scenario-output/.', exist=ex) 

    if (ex) then
      print*, 'Necessary directory already there'
      print*, 'Delete csv files inside the directory...'
      print*, ''
      call system ('cd scenario-output/ && rm -f *.csv')

      ! Use the following in the Windows system instead
      ! call system ('cd sensitivity-output && del *.csv')

    else       
        print*, 'Creating a necessary directory'
        call system('mkdir scenario-output' ) 
    end if

    par(:) = param_pooling_2(overwrite_params = [0.0d0], param_id_list=[0], is_overwrite=.false.)

    
    shift_factor10dec = 0.9d0
    shift_factor50dec = 0.5d0
    shift_factor90dec = 0.1d0

    shift_factor10inc = 1.1d0
    shift_factor50inc = 1.5d0
    shift_factor100inc = 2.0d0
    

    Ss_TG_shift10dec = Ss_TG * shift_factor10dec
    Ss_TG_shift50dec = Ss_TG * shift_factor50dec
    Ss_TG_shift90dec = Ss_TG * shift_factor90dec
    
    Ss_TG_shift10inc = Ss_TG * shift_factor10inc
    Ss_TG_shift50inc = Ss_TG * shift_factor50inc
    Ss_TG_shift100inc = Ss_TG * shift_factor100inc
    
    ! SNH4_TB_shift10 = SNH4_TB* shift_factor10dec
    ! SNH4_TB_shift50 = SNH4_TB* shift_factor50dec
    ! SNH4_TB_shift90 = SNH4_TB* shift_factor90dec
    
    Ss_KU_shift10dec = Ss_KU * shift_factor10dec
    Ss_KU_shift50dec = Ss_KU * shift_factor50dec
    Ss_KU_shift90dec = Ss_KU * shift_factor90dec
    
    Ss_KU_shift10inc = Ss_KU * shift_factor10inc
    Ss_KU_shift50inc = Ss_KU * shift_factor50inc
    Ss_KU_shift100inc = Ss_KU * shift_factor100inc
    
    ! XS_TG_shift10 = XS_TG * shift_factor10dec
    ! XS_TG_shift50 = XS_TG * shift_factor50dec
    ! XS_TG_shift90 = XS_TG * shift_factor90dec
    
    ! XS_KU_shift10 = XS_KU * shift_factor10dec
    ! XS_KU_shift50 = XS_KU * shift_factor50dec
    ! XS_KU_shift90 = XS_KU * shift_factor90dec

    ! ratio_G_jkc_shift10 = ratio_G_jkc * shift_factor10inc
    ! ratio_G_jkc_shift50 = ratio_G_jkc * shift_factor50inc

    ! ratio_G_direct_shift10 = ratio_G_direct * shift_factor10inc
    ! ratio_G_direct_shift50 = ratio_G_direct * shift_factor50inc
    ratio_G_direct_shift10 = 0.8d0 ! 80% prevalence
    ratio_G_direct_shift50 = 1.0d0 ! 100% prevalence


    shift_list(:) = [&
      Ss_TG_shift10dec, &
      Ss_TG_shift50dec, &
      Ss_TG_shift90dec, &
      Ss_TG_shift10inc, &
      Ss_TG_shift50inc, &
      Ss_TG_shift100inc, &
      Ss_KU_shift10dec, &
      Ss_KU_shift50dec, &
      Ss_KU_shift90dec, &
      Ss_KU_shift10inc, &
      Ss_KU_shift50inc, &
      Ss_KU_shift100inc, &
      ratio_G_direct_shift10, &
      ratio_G_direct_shift50]

    start(:) = [Ss_GW, SNH4_GW, SNO2_GW, SNO3_GW, SHPO4_GW, XH_GW, XN1_GW, XN2_GW, XS_GW, & 
      Ss_TG, SNH4_TG, SNO2_TG, SNO3_TG, SHPO4_TG, XH_TG, XN1_TG, XN2_TG, XS_TG, & 
      Ss_TB, SNH4_TB, SNO2_TB, SNO3_TB, SHPO4_TB, XH_TB, XN1_TB, XN2_TB, XS_TB, &
      Ss_KU, SNH4_KU, SNO2_KU, SNO3_KU, SHPO4_KU, XH_KU, XN1_KU, XN2_KU, XS_KU, &
      ratio_G_jkc, ratio_G_direct]
   
  
    dataset_index = 3

    print*, 'Base output calculation starting...'
    base_output(:) = output(start(:), dataset_index) 
    print*, 'Base output calculation ended'

    open(unit=45, file='./scenario-output/scenario.csv')
    write(45, '(*(g0:,","))') base_output(:)

    
    ! Forming an array storing default values
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
    end do
    
    ! SS_TG - 10
    parameter_shift(10,10) = shift_list(1)

    write ( *, '(a,i2)' ) 'Scenario calculation starting, no.1'
    scenario_output(:,10) = output(parameter_shift(10,:), dataset_index)
    write(45, '(*(g0:,","))') scenario_output(:,10)
    write ( *, '(a,i2)' ) 'Scenario calculation ended, no.1'

    parameter_shift(10,10) = shift_list(2)
    write ( *, '(a,i2)' ) 'Scenario calculation starting, no.2'
    scenario_output(:,10) = output(parameter_shift(10,:), dataset_index)
    write(45, '(*(g0:,","))') scenario_output(:,10)
    write ( *, '(a,i2)' ) 'Scenario calculation ended, no.2'

    parameter_shift(10,10) = shift_list(3)
    write ( *, '(a,i2)' ) 'Scenario calculation starting, no.3'
    scenario_output(:,10) = output(parameter_shift(10,:), dataset_index)
    write(45, '(*(g0:,","))') scenario_output(:,10)
    write ( *, '(a,i2)' ) 'Scenario calculation ended, no.3'

    parameter_shift(10,10) = shift_list(4)

    write ( *, '(a,i2)' ) 'Scenario calculation starting, no.4'
    scenario_output(:,10) = output(parameter_shift(10,:), dataset_index)
    write(45, '(*(g0:,","))') scenario_output(:,10)
    write ( *, '(a,i2)' ) 'Scenario calculation ended, no.4'

    parameter_shift(10,10) = shift_list(5)
    write ( *, '(a,i2)' ) 'Scenario calculation starting, no.5'
    scenario_output(:,10) = output(parameter_shift(10,:), dataset_index)
    write(45, '(*(g0:,","))') scenario_output(:,10)
    write ( *, '(a,i2)' ) 'Scenario calculation ended, no.5'

    parameter_shift(10,10) = shift_list(6)
    write ( *, '(a,i2)' ) 'Scenario calculation starting, no.6'
    scenario_output(:,10) = output(parameter_shift(10,:), dataset_index)
    write(45, '(*(g0:,","))') scenario_output(:,10)
    write ( *, '(a,i2)' ) 'Scenario calculation ended, no.6'

    ! ! SNH4_TB - 20
    ! parameter_shift(20,20) = shift_list(4)
    ! write ( *, '(a,i2)' ) 'Scenario calculation starting, no.4'
    ! scenario_output(:,20) = output(parameter_shift(20,:), dataset_index)
    ! write(45, '(*(g0:,","))') scenario_output(:,20)
    ! write ( *, '(a,i2)' ) 'Scenario calculation ended, no.4'

    ! parameter_shift(20,20) = shift_list(5)
    ! write ( *, '(a,i2)' ) 'Scenario calculation starting, no.5'
    ! scenario_output(:,20) = output(parameter_shift(20,:), dataset_index)
    ! write(45, '(*(g0:,","))') scenario_output(:,20)
    ! write ( *, '(a,i2)' ) 'Scenario calculation ended, no.5'

    ! parameter_shift(20,20) = shift_list(6)
    ! write ( *, '(a,i2)' ) 'Scenario calculation starting, no.6'
    ! scenario_output(:,20) = output(parameter_shift(20,:), dataset_index)
    ! write(45, '(*(g0:,","))') scenario_output(:,20)
    ! write ( *, '(a,i2)' ) 'Scenario calculation ended, no.6'

    ! ! Ss_Ku - 28
    parameter_shift(28,28) = shift_list(7)
    write ( *, '(a,i2)' ) 'Scenario calculation starting, no.7'
    scenario_output(:,28) = output(parameter_shift(28,:), dataset_index)
    write(45, '(*(g0:,","))') scenario_output(:,28)
    write ( *, '(a,i2)' ) 'Scenario calculation ended, no.7'

    parameter_shift(28,28) = shift_list(8)
    write ( *, '(a,i2)' ) 'Scenario calculation starting, no.8'
    scenario_output(:,28) = output(parameter_shift(28,:), dataset_index)
    write(45, '(*(g0:,","))') scenario_output(:,28)
    write ( *, '(a,i2)' ) 'Scenario calculation ended, no.8'

    parameter_shift(28,28) = shift_list(9)
    write ( *, '(a,i2)' ) 'Scenario calculation starting, no.9'
    scenario_output(:,28) = output(parameter_shift(28,:), dataset_index)
    write(45, '(*(g0:,","))') scenario_output(:,28)
    write ( *, '(a,i2)' ) 'Scenario calculation ended, no.9'

    parameter_shift(28,28) = shift_list(10)
    write ( *, '(a,i2)' ) 'Scenario calculation starting, no.10'
    scenario_output(:,28) = output(parameter_shift(28,:), dataset_index)
    write(45, '(*(g0:,","))') scenario_output(:,28)
    write ( *, '(a,i2)' ) 'Scenario calculation ended, no.10'

    parameter_shift(28,28) = shift_list(11)
    write ( *, '(a,i2)' ) 'Scenario calculation starting, no.11'
    scenario_output(:,28) = output(parameter_shift(28,:), dataset_index)
    write(45, '(*(g0:,","))') scenario_output(:,28)
    write ( *, '(a,i2)' ) 'Scenario calculation ended, no.11'

    parameter_shift(28,28) = shift_list(12)
    write ( *, '(a,i2)' ) 'Scenario calculation starting, no.12'
    scenario_output(:,28) = output(parameter_shift(28,:), dataset_index)
    write(45, '(*(g0:,","))') scenario_output(:,28)
    write ( *, '(a,i2)' ) 'Scenario calculation ended, no.12'


    ! ! XS_TG - 18
    ! parameter_shift(18,18) = shift_list(10)
    ! write ( *, '(a,i2)' ) 'Scenario calculation starting, no.10'
    ! scenario_output(:,18) = output(parameter_shift(18,:), dataset_index)
    ! write(45, '(*(g0:,","))') scenario_output(:,18)
    ! write ( *, '(a,i2)' ) 'Scenario calculation ended, no.10'

    ! parameter_shift(18,18) = shift_list(11)
    ! write ( *, '(a,i2)' ) 'Scenario calculation starting, no.11'
    ! scenario_output(:,18) = output(parameter_shift(18,:), dataset_index)
    ! write(45, '(*(g0:,","))') scenario_output(:,18)
    ! write ( *, '(a,i2)' ) 'Scenario calculation ended, no.11'

    ! parameter_shift(18,18) = shift_list(12)
    ! write ( *, '(a,i2)' ) 'Scenario calculation starting, no.12'
    ! scenario_output(:,18) = output(parameter_shift(18,:), dataset_index)
    ! write(45, '(*(g0:,","))') scenario_output(:,18)
    ! write ( *, '(a,i2)' ) 'Scenario calculation ended, no.12'

    ! ! XS_KU - 36
    ! parameter_shift(36,36) = shift_list(13)
    ! write ( *, '(a,i2)' ) 'Scenario calculation starting, no.13'
    ! scenario_output(:,36) = output(parameter_shift(36,:), dataset_index)
    ! write(45, '(*(g0:,","))') scenario_output(:,36)
    ! write ( *, '(a,i2)' ) 'Scenario calculation ended, no.13'

    ! parameter_shift(36,36) = shift_list(14)
    ! write ( *, '(a,i2)' ) 'Scenario calculation starting, no.14'
    ! scenario_output(:,36) = output(parameter_shift(36,:), dataset_index)
    ! write(45, '(*(g0:,","))') scenario_output(:,36)
    ! write ( *, '(a,i2)' ) 'Scenario calculation ended, no.14'

    ! parameter_shift(36,36) = shift_list(15)
    ! write ( *, '(a,i2)' ) 'Scenario calculation starting, no.15'
    ! scenario_output(:,36) = output(parameter_shift(36,:), dataset_index)
    ! write(45, '(*(g0:,","))') scenario_output(:,36)
    ! write ( *, '(a,i2)' ) 'Scenario calculation ended, no.15'

    ! ! ratio_G_jkc - 37
    ! parameter_shift(37,37) = shift_list(16)
    ! write ( *, '(a,i2)' ) 'Scenario calculation starting, no.16'
    ! scenario_output(:,37) = output(parameter_shift(37,:), dataset_index)
    ! write(45, '(*(g0:,","))') scenario_output(:,37)
    ! write ( *, '(a,i2)' ) 'Scenario calculation ended, no.16'

    ! parameter_shift(37,37) = shift_list(17)
    ! write ( *, '(a,i2)' ) 'Scenario calculation starting, no.17'
    ! scenario_output(:,37) = output(parameter_shift(37,:), dataset_index)
    ! write(45, '(*(g0:,","))') scenario_output(:,37)
    ! write ( *, '(a,i2)' ) 'Scenario calculation ended, no.17'

    ! ratio_G_direct - 38
    parameter_shift(38, 38) = shift_list(13)
    write ( *, '(a,i2)' ) 'Scenario calculation starting, no.13'
    scenario_output(:,38) = output(parameter_shift(38,:), dataset_index)
    write(45, '(*(g0:,","))') scenario_output(:,38)
    write ( *, '(a,i2)' ) 'Scenario calculation ended, no.13'

    parameter_shift(38, 38) = shift_list(14)
    write ( *, '(a,i2)' ) 'Scenario calculation starting, no.14'
    scenario_output(:,38) = output(parameter_shift(38,:), dataset_index)
    write(45, '(*(g0:,","))') scenario_output(:,38)
    write ( *, '(a,i2)' ) 'Scenario calculation ended, no.14'


    close(45)

    
end program main