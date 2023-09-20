module sim_sensitivity_WQ
 use,intrinsic :: iso_fortran_env
 use :: River_WQ
  implicit none 
  integer, parameter :: num_target_params=38, num_output = 60 

contains
function output(par, dataset_number) result(eta)
  integer, intent(in) :: dataset_number
  real(real64), intent(in) :: par(num_target_params)
  real(real64) eta(num_output)
  integer month_counter, i
  real(real64) conc_data(num_WQ)
    
    eta = 0.0d0; conc_data = 0.0d0
    
    MonthCounterLoop: &
    do i = 1, month_run
       month_counter = i 

      Ss_GW=par(1); SNH4_GW=par(2); SNO2_GW=par(3); SNO3_GW=par(4); SHPO4_GW=par(5) 
      XH_GW=par(6); XN1_GW=par(7); XN2_GW=par(8); XS_GW=par(9);

      Ss_TG=par(10); SNH4_TG=par(11); SNO2_TG=par(12); SNO3_TG=par(13); SHPO4_TG=par(14) 
      XH_TG=par(15); XN1_TG=par(16); XN2_TG=par(17); XS_TG=par(18)

      Ss_TB=par(19);  SNH4_TB=par(20); SNO2_TB=par(21); SNO3_TB=par(22); SHPO4_TB=par(23) 
      XH_TB=par(24); XN1_TB=par(25); XN2_TB=par(26); XS_TB=par(27); 

      Ss_KU=par(28);  SNH4_KU=par(29); SNO2_KU=par(30); SNO3_KU=par(31); SHPO4_KU=par(32) 
      XH_KU=par(33); XN1_KU=par(34); XN2_KU=par(35); XS_KU=par(36); 
      
      ratio_G_jkc = par(37); ratio_G_direct = par(38)

      call river(dataset_number, conc_data, month_counter, & 
        overwrite_params = [ &
          Ss_GW, SNH4_GW, SNO2_GW, SNO3_GW, SHPO4_GW, XH_GW, XN1_GW, XN2_GW, XS_GW, & 
          Ss_TG, SNH4_TG, SNO2_TG, SNO3_TG, SHPO4_TG, XH_TG, XN1_TG, XN2_TG, XS_TG, & 
          Ss_TB, SNH4_TB, SNO2_TB, SNO3_TB, SHPO4_TB, XH_TB, XN1_TB, XN2_TB, XS_TB, &
          Ss_KU, SNH4_KU, SNO2_KU, SNO3_KU, SHPO4_KU, XH_KU, XN1_KU, XN2_KU, XS_KU, &
          ratio_G_jkc, ratio_G_direct], &
        is_print_results = .false., &
        is_output = .false., is_kinetic = .false.)    

      
      eta(month_counter) = conc_data(1)
      eta(month_counter+12) = conc_data(2)
      eta(month_counter+24) = conc_data(3)
      eta(month_counter+36) = conc_data(4)
      eta(month_counter+48) = conc_data(5)
  

  end do MonthCounterLoop

  end function



end module sim_sensitivity_WQ
