module River_WQ
    use,intrinsic :: iso_fortran_env
    use :: param_pool
    use :: param_pool_2
    use :: River_hydraulic

    implicit none
    real(real64) :: dillution_rate = 0.1d0
    

contains
subroutine river(dataset_number, conc_data, month_counter, overwrite_params, is_print_results, &
                 is_output, is_kinetic)
    integer, intent(in) :: dataset_number, month_counter
    logical, intent(in) :: is_print_results, is_output, is_kinetic
    real(real64), intent(in) :: overwrite_params(:) 
    real(real64), intent(out) :: conc_data(num_WQ)
    integer Loc_Pointer, Time_Pointer, Runge_Pointer, Div_Total
    integer i
    real(real64) TempPointer(num_variables), Tempval_Inf(num_variables), ReactionTerm(num_variables,1) 
    real(real64) RungeK(num_variables,4), RiverWQ(num_variables)
    real(real64) ALLRiver_Q, ALLRiver_TankV, ALLRiver_H, ALLRiver_U, ALLRiver_Temp, SunlightSd
    real(real64) PrecipiQ, River_Q, PrecipiData, ALLRiver_A, ALLRiver_R, ALLRiver_E
    real(real64) Initial_ALLRiver_Q_For_3
    real(real64) River_K220, River_K2T, River_DOsat
    real(real64) Chemsp(num_processes,num_variables), ProcessMat(num_processes,1)
    real(real64) Process_1,Process_2,Process_3,Process_4,Process_5,Process_6,Process_7,Process_8,Process_9,Process_10,&
                Process_11,Process_12,Process_13,Process_14,Process_15,Process_16,Process_17,Process_18,Process_19,Process_20,&
                Process_21,Process_22
    real(real64), allocatable :: ALLRiver_SS(:,:), ALLRiver_SI(:,:), ALLRiver_SNH4(:,:), & 
                ALLRiver_SNO2(:,:), ALLRiver_SNO3(:,:), ALLRiver_SHPO4(:,:), ALLRiver_SO2(:,:), &
                ALLRiver_XH(:,:), ALLRiver_XN1(:,:), ALLRiver_XN2(:,:), ALLRiver_XALG(:,:), ALLRiver_XCON(:,:), ALLRiver_XS(:,:), &
                ALLRiver_XI(:,:), ALLRiver_BOD(:), ALLRiver_NOX(:), ALLRiver_NH4(:), ALLRiver_SSolid(:), ALLRiver_O2(:)
    character(2) :: iter_month, dataset_number_char
    real(real64) SepticDischarge(5), WeatherData(month_run), WaterTemp(total_dataset,month_run), &
                Precipitation(total_dataset,month_run), RiverWQ_set(total_dataset,month_run,num_variables) 
    real(real64) DischargeWQ(num_variables), Direct_DischargeWQ(num_variables)
    real(real64) hydraulic_data(num_mixing,total_dataset,month_run, num_hydraulic_data)
    real(real64) DO_dataset1(month_run), DO_dataset2(month_run), DO_dataset3(month_run), &
               BOD_dataset1(month_run), BOD_dataset2(month_run), BOD_dataset3(month_run) 
  real(real64) SS_dataset1(month_run), SS_dataset2(month_run), SS_dataset3(month_run), &
               NH4_dataset1(month_run), NH4_dataset2(month_run), NH4_dataset3(month_run)
  real(real64) NOx_dataset1(month_run), NOx_dataset2(month_run), NOx_dataset3(month_run)
  real(real64) SNO2_ratio, SNO3_ratio, XH_ratio, XI_ratio, XN1_ratio, XN2_ratio, XS_ratio
  real(real64) XALG_ratio, XCON_ratio, SS_ratio
  real(real64) Gappei_WQ(num_variables), Tandoku_GWQ(num_variables), Tandoku_BWQ(num_variables), Kumitori_WQ(num_variables)
  real(real64) ratio_chubu(total_dataset), ratio_direct(total_dataset)
  real(real64) par_remaining(num_params), par_remaining_2(num_params_2)

  if (is_output) then
    par_remaining(:) = param_pooling(overwrite_params = [0.0d0], param_id_list = [0], is_overwrite = .false.)
    par_remaining_2(:) = param_pooling_2(overwrite_params = [0.0d0], param_id_list=[0], is_overwrite = .false.)
    
  else
    if (is_kinetic) then
      Kdeath_CON = overwrite_params(1)  
      Kgrowth_CON = overwrite_params(2)
      Kresp_CON = overwrite_params(3)
      Kresp_N2 = overwrite_params(4) 
      KHPO4_ALG = overwrite_params(5)
      KHPO4_Haer = overwrite_params(6) 
      KHPO4_Anox = overwrite_params(7) 
      KHPO4_N1 = overwrite_params(8) 
      KHPO4_N2 = overwrite_params(9) 
      KN_ALG = overwrite_params(10) 
      KNH4_ALG = overwrite_params(11) 
      KNO3_Anox = overwrite_params(12) 
      KNO2_Anox = overwrite_params(13) 
      KO2_ALG = overwrite_params(14) 
      KO2_CON = overwrite_params(15) 
      KO2_N1 = overwrite_params(16) 
      Beta_ALG = overwrite_params(17)
      Beta_CON = overwrite_params(18) 
      Beta_H = overwrite_params(19) 
      Beta_HY = overwrite_params(20) 
      Beta_N1 = overwrite_params(21)
      Beta_N2 = overwrite_params(22) 
      Temp0 = overwrite_params(23) 
      Kresp_Haer = overwrite_params(24) 
      Kresp_N1 = overwrite_params(25) 
      K1 = overwrite_params(26)
      Kgrowth_N2 = overwrite_params(27) 
      Kgrowth_Haer = overwrite_params(28) 
      KS_Haer = overwrite_params(29)                       
      Kgrowth_ALG = overwrite_params(30) 
      Kgrowth_Anox = overwrite_params(31) 
      Kdeath_ALG = overwrite_params(32) 
      KO2_Haer = overwrite_params(33) 
      KNH_aer = overwrite_params(34) 
      KS_Anox = overwrite_params(35) 
      Kresp_ALG = overwrite_params(36) 
      Kresp_Anox = overwrite_params(37) 
      KNO2_N2 = overwrite_params(38) 
      KO2_N2 = overwrite_params(39) 
      Khyd = overwrite_params(40) 
      Kgrowth_N1 = overwrite_params(41) 
      KNH4_N1 = overwrite_params(42)

      par_remaining_2(:) = param_pooling_2(overwrite_params = [0.0d0], param_id_list=[0], is_overwrite = .false.)

    else
      Ss_GW = overwrite_params(1) 
      SNH4_GW = overwrite_params(2) 
      SNO2_GW = overwrite_params(3)
      SNO3_GW = overwrite_params(4)
      SHPO4_GW = overwrite_params(5)
      XH_GW = overwrite_params(6)
      XN1_GW = overwrite_params(7)
      XN2_GW = overwrite_params(8)
      XS_GW = overwrite_params(9)
      Ss_TG = overwrite_params(10)
      SNH4_TG = overwrite_params(11) 
      SNO2_TG = overwrite_params(12)
      SNO3_TG = overwrite_params(13)
      SHPO4_TG = overwrite_params(14)
      XH_TG = overwrite_params(15)
      XN1_TG = overwrite_params(16)
      XN2_TG = overwrite_params(17)
      XS_TG = overwrite_params(18)
      Ss_TB = overwrite_params(19)
      SNH4_TB = overwrite_params(20)
      SNO2_TB = overwrite_params(21) 
      SNO3_TB = overwrite_params(22) 
      SHPO4_TB = overwrite_params(23) 
      XH_TB = overwrite_params(24)
      XN2_TB = overwrite_params(25)
      XN2_TB = overwrite_params(26)
      XS_TB = overwrite_params(27)
      Ss_KU = overwrite_params(28)
      SNH4_KU = overwrite_params(29) 
      SNO2_KU = overwrite_params(30)
      SNO3_KU = overwrite_params(31)
      SHPO4_KU = overwrite_params(32)
      XH_KU = overwrite_params(33)
      XN1_KU = overwrite_params(34)
      XN2_KU = overwrite_params(35)
      XS_KU = overwrite_params(36)
      ratio_G_jkc = overwrite_params(37)
      ratio_G_direct = overwrite_params(38)

      par_remaining(:) = param_pooling(overwrite_params = [0.0d0], param_id_list = [0], is_overwrite = .false.)
    end if

  end if

     ! These ratios were introduced to convert monitoring data into IWA components
    SS_ratio = 0.75d0; XS_ratio = 0.25d0 
    XH_ratio = 0.03d0; XN1_ratio = 0.16d0; XN2_ratio = 0.20d0; 
    XALG_ratio = 0.15d0; XCON_ratio = 0.12d0; XI_ratio = 0.27d0 
    SNO2_ratio = 0.05d0; SNO3_ratio = 0.95d0

    ! Data-set from 2005 - 2010 (1)
    DO_dataset1 = [6.3d0, 5.4d0, 6.1d0, 4.9d0, 4.5d0, 6.55d0, &
      5.25d0, 7.05d0, 7.35d0, 7.4d0, 7.55d0, 6.95d0]
    BOD_dataset1 = [7.2d0, 9d0, 6.6d0, 9.35d0, 5.15d0, 3.05d0, &
     4.4d0, 4.5d0, 3.8d0, 4.05d0, 2.7d0, 4.5d0]
    SS_dataset1 = [13d0, 20d0, 25d0, 15.9d0, 8.5d0, 6.85d0, &
     15.55d0, 19.15d0, 18.25d0, 13.5d0, 11d0, 14d0]
    NH4_dataset1 = [7.75d0, 10.42d0, 13.59d0, 12.11d0, 19.92d0, 10.06d0, &
      13.47d0, 4.04d0, 3.61d0, 3.17d0, 2.49d0, 10.02d0]
    NOx_dataset1 = [15.80d0, 17.20d0, 12.60d0, 16.40d0, 15.75d0, 11.55d0, &
      16.80d0, 11.70d0, 12.65d0, 13.80d0, 14.30d0, 20.35d0]

     ! Ss, SI, SNH4, SNO2, SNO3, SHPO4, SO2 
        ! XH, XN1, XN2, XALG, XCON, XS, XI 
    do i = 1, 12
      RiverWQ_set(1, i, :) = [BOD_dataset1(i)*SS_ratio, 1.12d0, NH4_dataset1(i), & 
        NOx_dataset1(i)*SNO2_ratio, NOx_dataset1(i)*SNO3_ratio, 0.27d0, DO_dataset1(i), &
        SS_dataset1(i)*XH_ratio, SS_dataset1(i)*XN1_ratio, SS_dataset1(i)*XN2_ratio, &
        SS_dataset1(i)*XALG_ratio, SS_dataset1(i)*XCON_ratio, BOD_dataset1(i)*XS_ratio,&
        SS_dataset1(i)*XI_ratio]
    end do

     ! Dataset 2 from 2011-2014

     DO_dataset2 = [7.9d0, 8.85d0, 9.75d0, 7.75d0, 8.05d0, 8.2d0, &
      6.95d0, 6.35d0, 7.15d0, 7.65d0, 8.05d0, 8.25d0]
    BOD_dataset2 = [5.4d0, 5.95d0, 5.55d0, 5.2d0, 3.7d0, 3.2d0, &
      2.55d0, 2.35d0, 2.1d0, 1.55d0, 1.55d0, 2.65d0]
    SS_dataset2 = [10.65d0, 7.75d0, 6.4d0, 11.45d0, 6.4d0, 9.3d0, &
      10.55d0, 12.55d0, 19.05d0, 10.25d0, 5.95d0, 6.45d0]
    NH4_dataset2 = [6.81d0, 5.46d0, 7.35d0, 6.055d0, 5.975d0, 2.555d0, &
      1.675d0, 0.655d0, 0.415d0, 0.5d0, 0.425d0, 1.5d0]
    NOx_dataset2 = [10.45d0, 9.165d0, 8.34d0, 7.03d0, 7.275d0, 8.47d0, &
      8.76d0, 8.765d0, 9.15d0, 9.735d0, 9.93d0, 9.585d0]

    do i = 1, 12
      RiverWQ_set(2, i, :) = [BOD_dataset2(i)*SS_ratio, 1.12d0, NH4_dataset2(i), & 
        NOx_dataset2(i)*SNO2_ratio, NOx_dataset2(i)*SNO3_ratio, 0.27d0, DO_dataset2(i), &
        SS_dataset2(i)*XH_ratio, SS_dataset2(i)*XN1_ratio, SS_dataset2(i)*XN2_ratio, &
        SS_dataset2(i)*XALG_ratio, SS_dataset2(i)*XCON_ratio, BOD_dataset2(i)*XS_ratio,&
        SS_dataset2(i)*XI_ratio]
    end do 


    ! dataset 3 from 2015-2018
    DO_dataset3 = [8.4d0, 9.5d0, 8.9d0, 6.7d0, 6.5d0, 4.6d0, &
      4.6d0, 4.85d0, 6.4d0, 7.55d0, 8d0, 7.65d0]
    BOD_dataset3 = [2.4d0, 3.5d0, 3.9d0, 3.8d0, 2.5d0, 3.9d0, &
      4.4d0, 3.4d0, 1.95d0, 1.35d0, 1.3d0, 2d0]
    SS_dataset3 = [2.6d0, 5d0, 3.5d0, 4d0, 3.4d0, 13d0, &
     20.5d0, 21.85d0, 15.5d0, 11.3d0, 5.55d0, 3.1d0]
    NH4_dataset3 = [2.5d0, 2.64d0, 2.6d0, 4.24d0, 2.44d0, 1.89d0, &
      1.12d0, 0.425d0, 0.215d0, 0.2d0, 0.37d0, 0.69d0]
    NOx_dataset3 = [9.94d0, 8.8d0, 7.51d0, 7.19d0, 5.76d0, 7.97d0, &
      7.485d0, 9.065d0, 8.98d0, 9.3d0, 9.965d0, 10.165d0]

    do i = 1, 12
      RiverWQ_set(3, i, :) = [BOD_dataset3(i)*SS_ratio, 1.12d0, NH4_dataset3(i), & 
        NOx_dataset3(i)*SNO2_ratio, NOx_dataset3(i)*SNO3_ratio, 0.27d0, DO_dataset3(i), &
        SS_dataset3(i)*XH_ratio, SS_dataset3(i)*XN1_ratio, SS_dataset3(i)*XN2_ratio, &
        SS_dataset3(i)*XALG_ratio, SS_dataset3(i)*XCON_ratio, BOD_dataset3(i)*XS_ratio,&
        SS_dataset3(i)*XI_ratio]
    end do 

    ratio_chubu(:) = [ratio_G_jkc, (1.0d0 - ratio_G_jkc)*0.69d0, (1.0d0 - ratio_G_jkc)*0.31d0]
    ratio_direct(:) = [ratio_G_direct, (1.0d0 - ratio_G_direct)*0.64d0, (1.0d0 - ratio_G_direct)*0.26d0]


    ! unit: g/day 
    ! At Chubu

    ! Ss, SI, SNH4, SNO2, SNO3, SHPO4, SO2 
    ! XH, XN1, XN2, XALG, XCON, XS, XI 
    Gappei_WQ(:) = [Ss_GW, 15.74d0, SNH4_GW, SNO2_GW, SNO3_GW, SHPO4_GW, 0.0d0, & 
       XH_GW, XN1_GW, XN2_GW, 0.0d0, 0.0d0, XS_GW, 3.66d0]

    Tandoku_GWQ(:) = [Ss_TG, 144.71d0,SNH4_TG, SNO2_TG, SNO3_TG, SHPO4_TG, 0.0d0, &
       XH_TG, XN1_TG, XN2_TG, 0.0d0, 0.0d0, XS_TG, 23.82d0]

    Tandoku_BWQ(:) = [Ss_TB, 54.16d0, SNH4_TB, SNO2_TB, SNO3_TB, SHPO4_TB, 0.0d0, &
       XH_TB, XN1_TB, XN2_TB, 0.0d0, 0.0d0, XS_TB, 11.7d0]

    Kumitori_WQ(:) = [Ss_KU, 144.71d0, SNH4_KU, SNO2_KU, SNO3_KU, SHPO4_KU, 0.0d0, &
       XH_KU, XN1_KU, XN2_KU, 0.0d0, 0.0d0, XS_KU, 23.82d0]


    call flow(dataset_number, month_counter, hydraulic_data, num_mixing, &
              SepticDischarge, WeatherData, WaterTemp, Precipitation, &
              overwrite_params = [0.0d0], param_id_list = [0], is_overwrite = .false., &
              is_print_results = .false.)


    ! Displaying pollution load
    ! if (month_counter == 1) then
    !   print*, 'Pollution load at Chubu... (point source)'
    !   print*, ''
    !   call pollution_load_diplay(SepticDischarge(3), ratio_chubu, &
    !                   Gappei_WQ, Tandoku_GWQ, Tandoku_BWQ, Kumitori_WQ)
    !   print*, 'Pollution load at the direct discharge area... (non-point source)'                     
    !   print*, ''
    !   call pollution_load_diplay(SepticDischarge(4), ratio_direct, &
    !                   Gappei_WQ, Tandoku_GWQ, Tandoku_BWQ, Kumitori_WQ)
    ! end if


    DischargeWQ(:) = DischargeWQ_calc_rev(SepticDischarge(3), ratio_chubu, &
                      Gappei_WQ, Tandoku_GWQ, Tandoku_BWQ, Kumitori_WQ) 

    Direct_DischargeWQ(:) = DischargeWQ_calc_rev(SepticDischarge(4), ratio_direct, &
                      Gappei_WQ, Tandoku_GWQ, Tandoku_BWQ, Kumitori_WQ)  


    Chemsp(:,:) = 0.0d0
    call form_chemsp(Chemsp(:,:))

    ! zero reset
    TempPointer = 0.0d0; Tempval_Inf=0.0d0; ReactionTerm=0.0d0; RungeK=0.0d0;

    ! The orignal state of the river [mg/L] - monitored data at Chubu
    RiverWQ = RiverWQ_set(dataset_number, month_counter, :)

   

    PrecipiData = Precipitation(dataset_number, month_counter)  
    SunlightSd = WeatherData(month_counter)
    ALLRiver_Temp = WaterTemp(dataset_number, month_counter)
  
    
    ALLRiver_n =  hydraulic_data(3,dataset_number,month_counter,1)
    ALLRiver_U = hydraulic_data(3,dataset_number,month_counter,2)
    ALLRiver_H = hydraulic_data(3,dataset_number,month_counter,3)
    River_Q = hydraulic_data(3,dataset_number,month_counter,4)
    ALLRIver_Q = hydraulic_data(3,dataset_number,month_counter,5)
    Div_Total = hydraulic_data(3,dataset_number,month_counter,6) 
    ALLRiver_TankV = hydraulic_data(3,dataset_number,month_counter,7) 
    PrecipiQ = hydraulic_data(3,dataset_number,month_counter,8) 


    River_K220 = 6.02d0*10.0d0**(-4.0)*ALLRiver_n**0.75*ALLRiver_U**1.125/ALLRiver_H**1.5
    River_K2T = River_K220*(1.047d0**(ALLRiver_Temp - 20.0))    
    River_DOsat = 14.652d0 - 0.41022d0*ALLRiver_Temp + 0.007991d0*ALLRiver_Temp**2 - 0.000077774d0*ALLRiver_Temp**3
  
    allocate (ALLRiver_SS(month_time_total,Div_Total), ALLRiver_SI(month_time_total,Div_Total), &
        ALLRiver_SNH4(month_time_total,Div_Total), ALLRiver_SNO2(month_time_total,Div_Total), &
        ALLRiver_SNO3(month_time_total,Div_Total), ALLRiver_SHPO4(month_time_total,Div_Total), &
        ALLRiver_SO2(month_time_total,Div_Total), ALLRiver_XH(month_time_total,Div_Total), &
        ALLRiver_XN1(month_time_total,Div_Total), ALLRiver_XN2(month_time_total,Div_Total), &
        ALLRiver_XALG(month_time_total,Div_Total), ALLRiver_XCON(month_time_total,Div_Total), &
        ALLRiver_XS(month_time_total,Div_Total), ALLRiver_XI(month_time_total,Div_Total), &
        ALLRiver_BOD(Div_Total), ALLRiver_NOX(Div_Total), &
        ALLRiver_NH4(Div_Total), ALLRiver_SSolid(Div_Total), ALLRIver_O2(Div_Total))
    
    ! Boundary conditions to ALLRiver
    ALLRiver_SS(:,1) = (River_Q*RiverWQ(1) + DischargeWQ(1))/ALLRiver_Q
    ALLRiver_SI(:,1) = (River_Q*RiverWQ(2) + DischargeWQ(2))/ALLRiver_Q
    ALLRiver_SNH4(:,1) = (River_Q*RiverWQ(3) + DischargeWQ(3))/ALLRiver_Q
    ALLRiver_SNO2(:,1) = (River_Q*RiverWQ(4) + DischargeWQ(4))/ALLRiver_Q
    ALLRiver_SNO3(:,1) = (River_Q*RiverWQ(5) + DischargeWQ(5))/ALLRiver_Q
    ALLRiver_SHPO4(:,1) = (River_Q*RiverWQ(6) + DischargeWQ(6))/ALLRiver_Q
    ALLRiver_SO2(:,1) = (River_Q*RiverWQ(7) + River_DOsat*PrecipiQ)/ALLRiver_Q
    ALLRiver_XH(:,1) = (River_Q*RiverWQ(8) + DischargeWQ(8))/ALLRiver_Q
    ALLRiver_XN1(:,1) = (River_Q*RiverWQ(9) + DischargeWQ(9))/ALLRiver_Q
    ALLRiver_XN2(:,1) = (River_Q*RiverWQ(10) + DischargeWQ(10))/ALLRiver_Q
    ALLRiver_XALG(:,1) = (River_Q*RiverWQ(11) + DischargeWQ(11))/ALLRiver_Q
    ALLRiver_XCON(:,1) = (River_Q*RiverWQ(12) + DischargeWQ(12))/ALLRiver_Q
    ALLRiver_XS(:,1) = (River_Q*RiverWQ(13) + DischargeWQ(13))/ALLRiver_Q
    ALLRiver_XI(:,1) = (River_Q*RiverWQ(14) + DischargeWQ(14))/ALLRiver_Q

    ! Initial conditions to ALLRiver
    ALLRiver_SS(1,2:Div_Total) = RiverWQ(1)
    ALLRiver_SI(1,2:Div_Total) = RiverWQ(2)
    ALLRiver_SNH4(1,2:Div_Total) = RiverWQ(3)
    ALLRiver_SNO2(1,2:Div_Total) = RiverWQ(4) 
    ALLRiver_SNO3(1,2:Div_Total) = RiverWQ(5)
    ALLRiver_SHPO4(1,2:Div_Total) = RiverWQ(6)
    ALLRiver_SO2(1,2:Div_Total) = RiverWQ(7)
    ALLRiver_XH(1,2:Div_Total) = RiverWQ(8)
    ALLRiver_XN1(1,2:Div_Total) = RiverWQ(9)
    ALLRiver_XN2(1,2:Div_Total) = RiverWQ(10)
    ALLRiver_XALG(1,2:Div_Total) = RiverWQ(11)
    ALLRiver_XCON(1,2:Div_Total) = RiverWQ(12)
    ALLRiver_XS(1,2:Div_Total) = RiverWQ(13)
    ALLRiver_XI(1,2:Div_Total) = RiverWQ(14)

    Initial_ALLRiver_Q_For_3 = ALLRiver_Q
    
    ! Loop calculation
    do Time_Pointer = 2, month_time_total

      ALLRiver_Q = Initial_ALLRiver_Q_For_3

      do Loc_Pointer = 2, Div_Total    

        do Runge_Pointer = 1, 4                  
            if (Runge_Pointer == 1) then
                TempPointer(1) = ALLRiver_SS(Time_Pointer-1, Loc_Pointer)    
                TempPointer(2) = ALLRiver_SI(Time_Pointer-1, Loc_Pointer)
                TempPointer(3) = ALLRiver_SNH4(Time_Pointer-1, Loc_Pointer)
                TempPointer(4) = ALLRiver_SNO2(Time_Pointer-1, Loc_Pointer) 
                TempPointer(5) = ALLRiver_SNO3(Time_Pointer-1, Loc_Pointer) 
                TempPointer(6) = ALLRiver_SHPO4(Time_Pointer-1, Loc_Pointer) 
                TempPointer(7) = ALLRiver_SO2(Time_Pointer-1, Loc_Pointer) 
                TempPointer(8) = ALLRiver_XH(Time_Pointer-1, Loc_Pointer) 
                TempPointer(9) = ALLRiver_XN1(Time_Pointer-1, Loc_Pointer) 
                TempPointer(10) = ALLRiver_XN2(Time_Pointer-1, Loc_Pointer) 
                TempPointer(11) = ALLRiver_XALG(Time_Pointer-1, Loc_Pointer) 
                TempPointer(12) = ALLRiver_XCON(Time_Pointer-1, Loc_Pointer) 
                TempPointer(13) = ALLRiver_XS(Time_Pointer-1, Loc_Pointer) 
                TempPointer(14) = ALLRiver_XI(Time_Pointer-1, Loc_Pointer)  
            else if (Runge_Pointer == 2) then
                TempPointer(1) = ALLRiver_SS(Time_Pointer-1, Loc_Pointer) + (RungeK(1,1)*deltaT/2.0d0)
                TempPointer(2) = ALLRiver_SI(Time_Pointer-1, Loc_Pointer)+ (RungeK(2,1)*deltaT/2.0d0)
                TempPointer(3) = ALLRiver_SNH4(Time_Pointer-1, Loc_Pointer)+ (RungeK(3,1)*deltaT/2.0d0)
                TempPointer(4) = ALLRiver_SNO2(Time_Pointer-1, Loc_Pointer) + (RungeK(4,1)*deltaT/2.0d0)
                TempPointer(5) = ALLRiver_SNO3(Time_Pointer-1, Loc_Pointer) + (RungeK(5,1)*deltaT/2.0d0)
                TempPointer(6) = ALLRiver_SHPO4(Time_Pointer-1, Loc_Pointer) + (RungeK(6,1)*deltaT/2.0d0)
                TempPointer(7) = ALLRiver_SO2(Time_Pointer-1, Loc_Pointer) + (RungeK(7,1)*deltaT/2.0d0)
                TempPointer(8) = ALLRiver_XH(Time_Pointer-1, Loc_Pointer) + (RungeK(8,1)*deltaT/2.0d0)
                TempPointer(9) = ALLRiver_XN1(Time_Pointer-1, Loc_Pointer) + (RungeK(9,1)*deltaT/2.0d0)
                TempPointer(10) = ALLRiver_XN2(Time_Pointer-1, Loc_Pointer) + (RungeK(10,1)*deltaT/2.0d0)
                TempPointer(11) = ALLRiver_XALG(Time_Pointer-1, Loc_Pointer) + (RungeK(11,1)*deltaT/2.0d0)
                TempPointer(12) = ALLRiver_XCON(Time_Pointer-1, Loc_Pointer) + (RungeK(12,1)*deltaT/2.0d0)
                TempPointer(13) = ALLRiver_XS(Time_Pointer-1, Loc_Pointer) + (RungeK(13,1)*deltaT/2.0d0)
                TempPointer(14) = ALLRiver_XI(Time_Pointer-1, Loc_Pointer)  + (RungeK(14,1)*deltaT/2.0d0)
            else if (Runge_Pointer == 3) then
                TempPointer(1) = ALLRiver_SS(Time_Pointer-1, Loc_Pointer) + (RungeK(1,2)*deltaT/2.0d0)
                TempPointer(2) = ALLRiver_SI(Time_Pointer-1, Loc_Pointer)+ (RungeK(2,2)*deltaT/2.0d0)
                TempPointer(3) = ALLRiver_SNH4(Time_Pointer-1, Loc_Pointer)+ (RungeK(3,2)*deltaT/2.0d0)
                TempPointer(4) = ALLRiver_SNO2(Time_Pointer-1, Loc_Pointer) + (RungeK(4,2)*deltaT/2.0d0)
                TempPointer(5) = ALLRiver_SNO3(Time_Pointer-1, Loc_Pointer) + (RungeK(5,2)*deltaT/2.0d0)
                TempPointer(6) = ALLRiver_SHPO4(Time_Pointer-1, Loc_Pointer) + (RungeK(6,2)*deltaT/2.0d0)
                TempPointer(7) = ALLRiver_SO2(Time_Pointer-1, Loc_Pointer) + (RungeK(7,2)*deltaT/2.0d0)
                TempPointer(8) = ALLRiver_XH(Time_Pointer-1, Loc_Pointer) + (RungeK(8,2)*deltaT/2.0d0)
                TempPointer(9) = ALLRiver_XN1(Time_Pointer-1, Loc_Pointer) + (RungeK(9,2)*deltaT/2.0d0)
                TempPointer(10) = ALLRiver_XN2(Time_Pointer-1, Loc_Pointer) + (RungeK(10,2)*deltaT/2.0d0)
                TempPointer(11) = ALLRiver_XALG(Time_Pointer-1, Loc_Pointer) + (RungeK(11,2)*deltaT/2.0d0)
                TempPointer(12) = ALLRiver_XCON(Time_Pointer-1, Loc_Pointer) + (RungeK(12,2)*deltaT/2.0d0)
                TempPointer(13) = ALLRiver_XS(Time_Pointer-1, Loc_Pointer) + (RungeK(13,2)*deltaT/2.0d0)
                TempPointer(14) = ALLRiver_XI(Time_Pointer-1, Loc_Pointer)  + (RungeK(14,2)*deltaT/2.0d0)
            else if (Runge_Pointer == 4) then
                TempPointer(1) = ALLRiver_SS(Time_Pointer-1, Loc_Pointer) + RungeK(1,3)*deltaT
                TempPointer(2) = ALLRiver_SI(Time_Pointer-1, Loc_Pointer)+ RungeK(2,3)*deltaT
                TempPointer(3) = ALLRiver_SNH4(Time_Pointer-1, Loc_Pointer)+ RungeK(3,3)*deltaT
                TempPointer(4) = ALLRiver_SNO2(Time_Pointer-1, Loc_Pointer) + RungeK(4,3)*deltaT
                TempPointer(5) = ALLRiver_SNO3(Time_Pointer-1, Loc_Pointer) + RungeK(5,3)*deltaT
                TempPointer(6) = ALLRiver_SHPO4(Time_Pointer-1, Loc_Pointer) + RungeK(6,3)*deltaT
                TempPointer(7) = ALLRiver_SO2(Time_Pointer-1, Loc_Pointer) + RungeK(7,3)*deltaT
                TempPointer(8) = ALLRiver_XH(Time_Pointer-1, Loc_Pointer) + RungeK(8,3)*deltaT
                TempPointer(9) = ALLRiver_XN1(Time_Pointer-1, Loc_Pointer) + RungeK(9,3)*deltaT
                TempPointer(10) = ALLRiver_XN2(Time_Pointer-1, Loc_Pointer) + RungeK(10,3)*deltaT
                TempPointer(11) = ALLRiver_XALG(Time_Pointer-1, Loc_Pointer) + RungeK(11,3)*deltaT
                TempPointer(12) = ALLRiver_XCON(Time_Pointer-1, Loc_Pointer) + RungeK(12,3)*deltaT
                TempPointer(13) = ALLRiver_XS(Time_Pointer-1, Loc_Pointer) + RungeK(13,3)*deltaT
                TempPointer(14) = ALLRiver_XI(Time_Pointer-1, Loc_Pointer)  + RungeK(14,3)*deltaT
            end if

            ! Set influent concentrations
            Tempval_Inf(1) = ALLRiver_SS(Time_Pointer-1, Loc_Pointer-1)                                      
            Tempval_Inf(2) = ALLRiver_SI(Time_Pointer-1, Loc_Pointer-1)                                      
            Tempval_Inf(3) = ALLRiver_SNH4(Time_Pointer-1, Loc_Pointer-1)                                     
            Tempval_Inf(4) = ALLRiver_SNO2(Time_Pointer-1, Loc_Pointer-1)                                     
            Tempval_Inf(5) = ALLRiver_SNO3(Time_Pointer-1, Loc_Pointer-1)                                     
            Tempval_Inf(6) = ALLRiver_SHPO4(Time_Pointer-1, Loc_Pointer-1)                                     
            Tempval_Inf(7) = ALLRiver_SO2(Time_Pointer-1, Loc_Pointer-1)                                     
            Tempval_Inf(8) = ALLRiver_XH(Time_Pointer-1, Loc_Pointer-1)                                      
            Tempval_Inf(9) = ALLRiver_XN1(Time_Pointer-1, Loc_Pointer-1)                                     
            Tempval_Inf(10) = ALLRiver_XN2(Time_Pointer-1, Loc_Pointer-1)                                      
            Tempval_Inf(11) = ALLRiver_XALG(Time_Pointer-1, Loc_Pointer-1)                                      
            Tempval_Inf(12) = ALLRiver_XCON(Time_Pointer-1, Loc_Pointer-1)                                      
            Tempval_Inf(13) = ALLRiver_XS(Time_Pointer-1, Loc_Pointer-1)                                      
            Tempval_Inf(14) = ALLRiver_XI(Time_Pointer-1, Loc_Pointer-1)    

            Process_1 = Kgrowth_Haer * exp(Beta_H * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(1), KS_Haer) * Frac(TempPointer(7), KO2_Haer) * & 
                Frac(TempPointer(3), KNH_aer) * &
                Frac(TempPointer(6), KHPO4_Haer) * TempPointer(8)
            Process_2 = Kgrowth_Haer * exp(Beta_H * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(1), KS_Haer) * Frac(TempPointer(7), KO2_Haer) * &
                Frac(KNH_aer, TempPointer(3))  * &
                Frac(TempPointer(5), KNH_aer) * Frac(TempPointer(6), KHPO4_Haer) * TempPointer(8) 
            Process_3 = Kresp_Haer * exp(Beta_H * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(7), KO2_Haer) * TempPointer(8)
            Process_4 = Kgrowth_Anox * exp(Beta_H * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(1), KS_Anox) * Frac(KO2_Haer, TempPointer(7)) * Frac(TempPointer(5), KNO3_Anox) * &
                Frac(TempPointer(6), KHPO4_Anox) * TempPointer(8)
            Process_5 = Kgrowth_Anox * exp(Beta_H * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(1), KS_Anox) * Frac(KO2_Haer, TempPointer(7)) * Frac(TempPointer(4), KNO2_Anox) * &
                Frac(TempPointer(6), KHPO4_Anox) * TempPointer(8)
            Process_6 = Kresp_Anox * exp(Beta_H * (ALLRiver_Temp - Temp0)) * &
                Frac(KO2_Haer, TempPointer(7)) * Frac(TempPointer(5), KNO3_Anox) * TempPointer(8)
            Process_7 = Kgrowth_N1 * exp(Beta_N1 * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(7), KO2_N1) * Frac(TempPointer(3), KNH4_N1) *&
                Frac(TempPointer(6), KHPO4_N1) * TempPointer(9)
            Process_8 = Kresp_N1 * exp(Beta_N1 * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(7), KO2_N1) * TempPointer(9)
            Process_9 = Kgrowth_N2 * exp(Beta_N2 * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(7), KO2_N2) * Frac(TempPointer(4), KNO2_N2) * &
                Frac(TempPointer(6), KHPO4_N2) * TempPointer(10)
            Process_10 = Kresp_N2 * exp(Beta_N2 * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(7), KO2_N2) * TempPointer(10)
            Process_11 = Kgrowth_ALG * exp(Beta_ALG * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(3) + TempPointer(5), KN_ALG) * &
                Frac(TempPointer(3), KNH4_ALG) * &
                Frac(TempPointer(6), KHPO4_ALG) * (SunlightSd / K1) * exp(1 - (Sunlightsd/K1)) * &
                TempPointer(11)
            Process_12 = Kgrowth_ALG * exp(Beta_ALG * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(3) + TempPointer(5), KN_ALG) * &
                Frac(KNH4_ALG, TempPointer(3)) * &
                Frac(TempPointer(6), KHPO4_ALG) * (Sunlightsd / K1) * exp(1 - (Sunlightsd / K1)) * &
                TempPointer(11)
            Process_13 = Kresp_ALG * exp(Beta_ALG * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(7), KO2_ALG) * TempPointer(11)
            Process_14 = Kdeath_ALG * exp(Beta_ALG * (ALLRiver_Temp - Temp0)) * TempPointer(11)
            Process_15 = Kgrowth_CON * exp(Beta_CON * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(7), KO2_CON) * TempPointer(11) * TempPointer(12)
            Process_16 = Kgrowth_CON * exp(Beta_CON * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(7), KO2_CON) * TempPointer(13) * TempPointer(12)   
            Process_17 = Kgrowth_CON * exp(Beta_CON * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(7), KO2_CON) * TempPointer(8) * TempPointer(12)
            Process_18 = Kgrowth_CON * exp(Beta_CON * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(7), KO2_CON) * TempPointer(9) * TempPointer(12)
            Process_19 = Kgrowth_CON * exp(Beta_CON * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(7), KO2_CON) * TempPointer(10) * TempPointer(12)
            Process_20 = Kresp_CON * exp(Beta_CON * (ALLRiver_Temp - Temp0)) * &
                Frac(TempPointer(7), KO2_CON) * TempPointer(12)
            Process_21 = Kdeath_CON * exp(Beta_CON * (ALLRiver_Temp - Temp0)) * TempPointer(12)
            Process_22 = Khyd * exp(Beta_HY * (ALLRiver_Temp - Temp0)) * TempPointer(13)


            ProcessMat(:,1) = [ &
                Process_1,Process_2,Process_3,Process_4,Process_5,Process_6,Process_7,Process_8,Process_9,Process_10,&
                Process_11,Process_12,Process_13,Process_14,Process_15,Process_16,Process_17,Process_18,Process_19, &
                Process_20,Process_21,Process_22]

            ReactionTerm = matmul(transpose(Chemsp), ProcessMat)
                
            ! add a reaeration term to oxygen
            ReactionTerm(7, 1) = ReactionTerm(7, 1) + River_K2T * (River_DOsat - TempPointer(7))

            ! Calculation of derivatives in the Runge-Kutta method
            do i = 1, num_variables
              RungeK(i, Runge_Pointer) = (1/ ALLRiver_TankV) * &
                  (ALLRiver_Q * Tempval_Inf(i) + &
                  (SepticDischarge(4)/Div_Total) * (Direct_DischargeWQ(i)/SepticDischarge(4)) * dillution_rate - & 
                  ! (SepticDischarge(4)/Div_Total) * (Direct_DischargeWQ(i)/SepticDischarge(4)) - & 
                  (ALLRiver_Q + SepticDischarge(4)/Div_Total)*TempPointer(i)) + ReactionTerm(i, 1)
            end do 



        end do !Runge_Pointer

        ! Update of concentrations
        ALLRiver_SS(Time_Pointer,Loc_Pointer) = ALLRiver_SS(Time_Pointer-1,Loc_Pointer) &
            + (RungeK(1,1) + RungeK(1,2)*2.0d0 + RungeK(1,3)*2.0d0 + RungeK(1,4)) * deltaT/6.0d0

        if (ALLRiver_SS(Time_Pointer, Loc_Pointer) < 0.0d0) then
          ALLRiver_SS(Time_Pointer, Loc_Pointer) = 0.0d0
        end if

        ALLRiver_SI(Time_Pointer,Loc_Pointer) = ALLRiver_SI(Time_Pointer-1,Loc_Pointer) &
            + (RungeK(2,1) + RungeK(2,2)*2.0d0 + RungeK(2,3)*2.0d0 + RungeK(2,4)) * deltaT/6.0d0

        if (ALLRiver_SI(Time_Pointer, Loc_Pointer) < 0.0d0) then
            ALLRiver_SI(Time_Pointer, Loc_Pointer) = 0.0d0
        end if

        ALLRiver_SNH4(Time_Pointer,Loc_Pointer) = ALLRiver_SNH4(Time_Pointer-1,Loc_Pointer) &
            + (RungeK(3,1) + RungeK(3,2)*2.0d0 + RungeK(3,3)*2.0d0 + RungeK(3,4)) * deltaT/6.0d0

        if (ALLRiver_SNH4(Time_Pointer, Loc_Pointer) < 0.0d0) then
            ALLRiver_SNH4(Time_Pointer, Loc_Pointer) = 0.0d0
        end if

        ALLRiver_SNO2(Time_Pointer,Loc_Pointer) = ALLRiver_SNO2(Time_Pointer-1,Loc_Pointer) &
            + (RungeK(4,1) + RungeK(4,2)*2.0d0 + RungeK(4,3)*2.0d0 + RungeK(4,4)) * deltaT/6.0d0

        if (ALLRiver_SNO2(Time_Pointer, Loc_Pointer) < 0.0d0) then
            ALLRiver_SNO2(Time_Pointer, Loc_Pointer) = 0.0d0 
        end if  

        ALLRiver_SNO3(Time_Pointer,Loc_Pointer) = ALLRiver_SNO3(Time_Pointer-1,Loc_Pointer) &
            + (RungeK(5,1) + RungeK(5,2)*2.0d0 + RungeK(5,3)*2.0d0 + RungeK(5,4)) * deltaT/6.0d0

        if (ALLRiver_SNO3(Time_Pointer, Loc_Pointer) < 0.0d0) then
            ALLRiver_SNO3(Time_Pointer, Loc_Pointer) = 0.0d0 
        end if

        ALLRiver_SHPO4(Time_Pointer,Loc_Pointer) = ALLRiver_SHPO4(Time_Pointer-1,Loc_Pointer) &
            + (RungeK(6,1) + RungeK(6,2)*2.0d0 + RungeK(6,3)*2.0d0 + RungeK(6,4)) * deltaT/6.0d0

        if (ALLRiver_SHPO4(Time_Pointer, Loc_Pointer) < 0.0d0) then
            ALLRiver_SHPO4(Time_Pointer, Loc_Pointer) = 0.0d0
        end if 
       
        ALLRiver_SO2(Time_Pointer,Loc_Pointer) = ALLRiver_SO2(Time_Pointer-1,Loc_Pointer) &
            + (RungeK(7,1) + RungeK(7,2)*2.0d0 + RungeK(7,3)*2.0d0 + RungeK(7,4)) * deltaT/6.0d0

        if (ALLRiver_SO2(Time_Pointer, Loc_Pointer) < 0.0d0) then
          ALLRiver_SO2(Time_Pointer, Loc_Pointer) = 0.0d0 
        end if

        if (ALLRiver_SO2(Time_Pointer, Loc_Pointer) > River_DOsat) then
            ALLRiver_SO2(Time_Pointer, Loc_Pointer) = River_DOsat
        end if

        ALLRiver_XH(Time_Pointer,Loc_Pointer) = ALLRiver_XH(Time_Pointer-1,Loc_Pointer) &
            + (RungeK(8,1) + RungeK(8,2)*2.0d0 + RungeK(8,3)*2.0d0 + RungeK(8,4)) * deltaT/6.0d0

        if (ALLRiver_XH(Time_Pointer, Loc_Pointer) < 0.0d0) then
            ALLRiver_XH(Time_Pointer, Loc_Pointer) = 0.0d0 
        end if

        ALLRiver_XN1(Time_Pointer,Loc_Pointer) = ALLRiver_XN1(Time_Pointer-1,Loc_Pointer) &
            + (RungeK(9,1) + RungeK(9,2)*2.0d0 + RungeK(9,3)*2.0d0 + RungeK(9,4)) * deltaT/6.0d0

        if (ALLRiver_XN1(Time_Pointer, Loc_Pointer) < 0.0d0) then
            ALLRiver_XN1(Time_Pointer, Loc_Pointer) = 0.0d0 
        end if

        ALLRiver_XN2(Time_Pointer,Loc_Pointer) = ALLRiver_XN2(Time_Pointer-1,Loc_Pointer) &
            + (RungeK(10,1) + RungeK(10,2)*2.0d0 + RungeK(10,3)*2.0d0 + RungeK(10,4)) * deltaT/6.0d0

        if (ALLRiver_XN2(Time_Pointer, Loc_Pointer) < 0.0d0) then
          ALLRiver_XN2(Time_Pointer, Loc_Pointer) = 0.0d0 
        end if

        ALLRiver_XALG(Time_Pointer,Loc_Pointer) = ALLRiver_XALG(Time_Pointer-1,Loc_Pointer) &
            + (RungeK(11,1) + RungeK(11,2)*2.0d0 + RungeK(11,3)*2.0d0 + RungeK(11,4)) * deltaT/6.0d0

        if (ALLRiver_XALG(Time_Pointer, Loc_Pointer) < 0.0d0) then
            ALLRiver_XALG(Time_Pointer, Loc_Pointer) = 0.0d0 
        end if  

        ALLRiver_XCON(Time_Pointer,Loc_Pointer) = ALLRiver_XCON(Time_Pointer-1,Loc_Pointer) &
            + (RungeK(12,1) + RungeK(12,2)*2.0d0 + RungeK(12,3)*2.0d0 + RungeK(12,4)) * deltaT/6.0d0

        if (ALLRiver_XCON(Time_Pointer, Loc_Pointer) < 0.0d0) then
            ALLRiver_XCON(Time_Pointer, Loc_Pointer) = 0.0d0 
        end if

        ALLRiver_XS(Time_Pointer,Loc_Pointer) = ALLRiver_XS(Time_Pointer-1,Loc_Pointer) &
            + (RungeK(13,1) + RungeK(13,2)*2.0d0 + RungeK(13,3)*2.0d0 + RungeK(13,4)) * deltaT/6.0d0

        if (ALLRiver_XS(Time_Pointer, Loc_Pointer) < 0.0d0) then
            ALLRiver_XS(Time_Pointer, Loc_Pointer) = 0.0d0 
        end if  

        ALLRiver_XI(Time_Pointer,Loc_Pointer) = ALLRiver_XI(Time_Pointer-1,Loc_Pointer) &
            + (RungeK(14,1) + RungeK(14,2)*2.0d0 + RungeK(14,3)*2.0d0 + RungeK(14,4)) * deltaT/6.0d0
            
        if (ALLRiver_XI(Time_Pointer, Loc_Pointer) < 0.0d0) then
            ALLRiver_XI(Time_Pointer, Loc_Pointer) = 0.0d0 
        end if

        ALLRiver_Q = ALLRiver_Q + SepticDischarge(4)/Div_Total
                                                                                              
    end do !Loc_counter

    ALLRiver_BOD(:) = ALLRiver_SS(Time_Pointer, :) + ALLRiver_XS(Time_Pointer, :)
    ALLRiver_SSolid(:) = ALLRiver_XH(Time_Pointer, :) + ALLRiver_XN1(Time_Pointer, :) + &
        ALLRiver_XN2(Time_Pointer, :) + ALLRiver_XALG(Time_Pointer, :) + &
        ALLRiver_XCON(Time_Pointer, :) + ALLRiver_XS(Time_Pointer, :) + &
        ALLRiver_XI(Time_Pointer, :)
    ALLRiver_NOX(:) = ALLRiver_SNO2(Time_Pointer, :) + ALLRiver_SNO3(Time_Pointer, :)
    ALLRiver_NH4(:) = ALLRiver_SNH4(Time_Pointer, :) 
    ALLRIver_O2(:) = ALLRiver_SO2(Time_Pointer, :)


    ! Writing data in a csv file
    if(is_print_results)then
      if (mod(Time_Pointer, print_count).eq. 0) then


          write(iter_month, '(I2.2)') month_counter
          write(dataset_number_char, '(I2.2)') dataset_number

          open(unit=12, file='./output-csv/OutputBOD.'//iter_month//'-'//dataset_number_char//'.csv')
          open(unit=13, file='./output-csv/OutputSSolids.'//iter_month//'-'//dataset_number_char//'.csv')
          open(unit=14, file='./output-csv/OutputNOX.'//iter_month//'-'//dataset_number_char//'.csv')
          open(unit=15, file='./output-csv/OutputNH4.'//iter_month//'-'//dataset_number_char//'.csv')
          open(unit=16, file='./output-csv/OutputO2.'//iter_month//'-'//dataset_number_char//'.csv')

          write(12, '(*(g0:,","))') ALLRiver_BOD(:)
          write(13, '(*(g0:,","))') ALLRiver_SSolid(:)
          write(14, '(*(g0:,","))') ALLRiver_NOX(:)
          write(15, '(*(g0:,","))') ALLRiver_NH4(:)
          write(16, '(*(g0:,","))') ALLRiver_O2(:)
      end if


    end if 

    end do  !Time_counter

    close(12);close(13);close(14);close(15); close(16)

    conc_data(:) = 0.0d0 ! zero reset

    ! conc_data(:) = [&
    !   ALLRiver_SS(month_time_total,Div_Total), & 
    !   ALLRiver_SI(month_time_total,Div_Total), &
    !   ALLRiver_SNH4(month_time_total,Div_Total), &
    !   ALLRiver_SNO2(month_time_total,Div_Total), &
    !   ALLRiver_SNO3(month_time_total,Div_Total), &
    !   ALLRiver_SHPO4(month_time_total,Div_Total), &
    !   ALLRiver_SO2(month_time_total,Div_Total), &
    !   ALLRiver_XH(month_time_total,Div_Total), & 
    !   ALLRiver_XN1(month_time_total,Div_Total), & 
    !   ALLRiver_XN2(month_time_total,Div_Total), & 
    !   ALLRiver_XALG(month_time_total,Div_Total), & 
    !   ALLRiver_XCON(month_time_total,Div_Total), & 
    !   ALLRiver_XS(month_time_total,Div_Total), & 
    !   ALLRiver_XI(month_time_total,Div_Total)]

    conc_data(:) = [&
      ALLRiver_O2(Div_Total), &
      ALLRiver_BOD(Div_Total), &
      ALLRiver_SSolid(Div_Total), &
      ALLRiver_NH4(Div_Total), &
      ALLRiver_NOX(Div_Total)]

    deallocate(ALLRiver_SS, ALLRiver_SI, ALLRiver_SNH4, &
        ALLRiver_SNO2, ALLRiver_SNO3, ALLRiver_SHPO4, ALLRiver_SO2, &
        ALLRiver_XH, ALLRiver_XN1, ALLRiver_XN2, ALLRiver_XALG, ALLRiver_XCON, ALLRiver_XS, &
        ALLRiver_XI, ALLRiver_BOD, ALLRiver_NOX, ALLRiver_NH4, ALLRiver_SSolid, ALLRiver_O2)
  

end subroutine river


function Frac(x,y) result(f)
    real(real64), intent(in) :: x,y

    real(real64) f
    
    if (x == 0.0d0) then
        f = 1.0d0
    else 
        f = (x) / (x + y)
    end if 

end function Frac



  subroutine form_chemsp(Chemsp)
  real(real64), intent(inout) :: Chemsp(:,:)

  ! component #1 - SS
  Chemsp(1,1) = -1.67d0 
  Chemsp(2,1) = -1.67d0
  Chemsp(4,1) = -2.0d0
  Chemsp(5,1) = -3.3d0
  Chemsp(22,1) = 1.0d0

  ! component #2 - SI

  ! component #3 - SNH4
  Chemsp(1,3) = -0.0014d0
  Chemsp(3,3) = 0.0081d0
  Chemsp(6,3) = 0.0081d0
  Chemsp(7,3) = -0.55d0
  Chemsp(8,3) = 0.0081d0
  Chemsp(10,3) = 0.0081d0
  Chemsp(11,3) = -0.0043d0
  Chemsp(13,3) = 0.0039d0
  Chemsp(14,3) = 0.0011d0
  Chemsp(15,3) = 0.0086d0
  Chemsp(16,3) = 0.0086d0
  Chemsp(17,3) = 0.03d0
  Chemsp(18,3) = 0.03d0
  Chemsp(19,3) = 0.03d0
  Chemsp(20,3) = 0.0039d0
  Chemsp(21,3) = 0.0019d0


  ! component #4 - SNO2
  Chemsp(4,4) = 0.12d0
  Chemsp(5,4) = -0.19d0
  Chemsp(7,4) = 0.55d0
  Chemsp(9,4) = -2.38d0


  ! component #5 - SNO3
  Chemsp(2,5) = -0.0014d0
  Chemsp(4,5) = -0.12d0
  Chemsp(6,5) = -0.031d0
  Chemsp(9,5) = 2.37d0
  Chemsp(12,5) = -0.0043d0


  ! component #6 - SHPO4
  Chemsp(1,6) = -0.00043d0
  Chemsp(2,6) = -0.00043d0
  Chemsp(3,6) = 0.0009d0
  Chemsp(4,6) = -0.00032d0
  Chemsp(5,6) = 0.0001d0
  Chemsp(6,6) = 0.0009d0
  Chemsp(7,6) = -0.0009d0
  Chemsp(8,6) = 0.0009d0
  Chemsp(9,6) = -0.00097d0
  Chemsp(10,6) = 0.0009d0
  Chemsp(11,6) = -0.0003d0
  Chemsp(12,6) = -0.0003d0
  Chemsp(13,6) = 0.00026d0
  Chemsp(14,6) = 0.00012d0
  Chemsp(15,6) = 0.00065d0
  Chemsp(16,6) = 0.00065d0
  Chemsp(17,6) = 0.0039d0
  Chemsp(18,6) = 0.0039d0
  Chemsp(19,6) = 0.0039d0
  Chemsp(20,6) = 0.00026d0
  Chemsp(21,6) = 0.00012d0


  ! component #7 - SO2
  Chemsp(1,7) = -0.043d0
  Chemsp(2,7) = -0.04d0
  Chemsp(3,7) = -0.039d0
  Chemsp(7,7) = -0.76d0
  Chemsp(8,7) = -0.039d0
  Chemsp(9,7) = -1.12d0
  Chemsp(10,7) = -0.039d0
  Chemsp(11,7) = 0.029d0
  Chemsp(12,7) = 0.038d0
  Chemsp(13,7) = -0.017d0
  Chemsp(14,7) = 0.006d0
  Chemsp(15,7) = -0.0044d0
  Chemsp(16,7) = -0.14d0
  Chemsp(17,7) = -0.11d0
  Chemsp(18,7) = -0.11d0
  Chemsp(19,7) = -0.11d0
  Chemsp(20,7) = -0.017d0
  Chemsp(21,7) = 0.006d0

  ! component #8 - XH
  Chemsp(1,8) = 1.0d0
  Chemsp(2,8) = 1.0d0
  Chemsp(3,8) = -1.0d0
  Chemsp(4,8) = 1.0d0
  Chemsp(5,8) = 1.0d0
  Chemsp(6,8) = -1.0d0
  Chemsp(17,8) = -5.0d0

  ! component #9 - XN1
  Chemsp(7,9) = 1.0d0
  Chemsp(8,9) = -1.0d0
  Chemsp(18,9) = -5.0d0

  ! component #10 - XN2
  Chemsp(9,10) = 1.0d0
  Chemsp(10,10) = -1.0d0
  Chemsp(19,10) = -5.0d0

  ! component #11 - XALG
  Chemsp(11,11) = 1.0d0
  Chemsp(12,11) = 1.0d0
  Chemsp(13,11) = -1.0d0
  Chemsp(14,11) = -1.0d0
  Chemsp(15,11) = -5.0d0

  ! component #12 - XCON
  Chemsp(15,12) = 1.0d0
  Chemsp(16,12) = 1.0d0
  Chemsp(17,12) = 1.0d0
  Chemsp(18,12) = 1.0d0
  Chemsp(19,12) = 1.0d0
  Chemsp(20,12) = -1.0d0
  Chemsp(21,12) = -1.0d0

  ! component #13 - XS
  Chemsp(14,13) = 0.5d0
  Chemsp(15,13) = 2.0d0
  Chemsp(16,13) = 2.0d0
  Chemsp(17,13) = 2.0d0
  Chemsp(18,13) = 2.0d0
  Chemsp(19,13) = 2.0d0
  Chemsp(21,13) = 0.5d0
  Chemsp(22,13) = -1.0d0

  ! component #14 - XI
  Chemsp(3,14) = 0.2d0
  Chemsp(6,14) = 0.2d0
  Chemsp(8,14) = 0.2d0
  Chemsp(10,14) = 0.2d0
  Chemsp(13,14) = 0.2d0
  Chemsp(14,14) = 0.12d0
  Chemsp(20,14) = 0.2d0
  Chemsp(21,14) = 0.12d0


  
end subroutine form_chemsp

function DischargeWQ_calc_rev(Dis_flow_rate, ratio, &
                      Gappei_WQ, Tandoku_GWQ, Tandoku_BWQ, Kumitori_WQ) result(WQ_list)
      real(real64), intent(in) :: Dis_flow_rate, ratio(3)
      real(real64), intent(in) :: Gappei_WQ(num_variables), Tandoku_GWQ(num_variables), &
                    Tandoku_BWQ(num_variables), Kumitori_WQ(num_variables)
      real(real64) WQ_list(num_variables), Gappei_PL(num_variables), Tandoku_PL(num_variables), &
                    Kumitori_PL(num_variables)
      real(real64) Gappei_Flow, Tandoku_G_Flow, Tandoku_B_Flow, &
                 Kumitori_Flow

      ! unit: m^3/d
      Gappei_Flow = Dis_flow_rate * ratio(1)
      Tandoku_G_Flow = Dis_flow_rate * ratio(2) * 0.8
      Tandoku_B_Flow = Dis_flow_rate * ratio(2) * 0.2
      Kumitori_Flow = Dis_flow_rate * ratio(3)

      ! unit: g/day
      WQ_list = Gappei_WQ*Gappei_Flow + Tandoku_GWQ*Tandoku_G_Flow + &
              Tandoku_BWQ*Tandoku_B_Flow + Kumitori_WQ*Kumitori_Flow


end function DischargeWQ_calc_rev

subroutine pollution_load_diplay(Dis_flow_rate, ratio, &
                      Gappei_WQ, Tandoku_GWQ, Tandoku_BWQ, Kumitori_WQ) 
      real(real64), intent(in) :: Dis_flow_rate, ratio(3)
      real(real64), intent(in) :: Gappei_WQ(num_variables), Tandoku_GWQ(num_variables), &
                    Tandoku_BWQ(num_variables), Kumitori_WQ(num_variables)
      real(real64)  Gappei_PL(num_variables), Tandoku_PL(num_variables), &
                    Kumitori_PL(num_variables)
      real(real64) Gappei_Flow, Tandoku_G_Flow, Tandoku_B_Flow, &
                 Kumitori_Flow

      ! unit: m^3/d
      Gappei_Flow = Dis_flow_rate * ratio(1)
      Tandoku_G_Flow = Dis_flow_rate * ratio(2) * 0.8
      Tandoku_B_Flow = Dis_flow_rate * ratio(2) * 0.2
      Kumitori_Flow = Dis_flow_rate * ratio(3)

      ! unit: g/day
      Gappei_PL = Gappei_WQ*Gappei_Flow 
      Tandoku_PL = Tandoku_GWQ*Tandoku_G_Flow + Tandoku_BWQ*Tandoku_B_Flow
      Kumitori_PL = Kumitori_WQ*Kumitori_Flow

      ! Ss, SI, SNH4, SNO2, SNO3, SHPO4, SO2 
      ! XH, XN1, XN2, XALG, XCON, XS, XI 

      print*, 'Gappei pollution BOD load (g/d): ', Gappei_PL(1)
      print*, 'Gappei pollution NH4 load (g/d): ', Gappei_PL(3) 
      print*, 'Gappei pollution NOx load (g/d): ', Gappei_PL(4) + Gappei_PL(5)
      print*, ''
      print*, 'Tandoku pollution BOD load (g/d): ', Tandoku_PL(1)
      print*, 'Tandoku pollution NH4 load (g/d): ', Tandoku_PL(3)
      print*, 'Tandoku pollution NOx load (g/d): ', Tandoku_PL(4) + Tandoku_PL(5)
      print*, ''
      print*, 'Kumitori pollution BOD load (g/d): ', Kumitori_PL(1)
      print*, 'Kumitori pollution NH4 load (g/d): ', Kumitori_PL(3)
      print*, 'Kumitori pollution Nox load (g/d): ', Kumitori_PL(4) + Kumitori_PL(5)
      print*, ''

end subroutine pollution_load_diplay



end module River_WQ