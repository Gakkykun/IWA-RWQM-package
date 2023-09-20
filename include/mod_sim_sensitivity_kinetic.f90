module sim_sensitivity_kinetic
 use,intrinsic :: iso_fortran_env
 use :: River_WQ
  implicit none 
  integer, parameter :: num_target_params=35, num_output = 60
  

contains
function output(par, dataset_number) result(eta)
  integer, intent(in) :: dataset_number
  real(real64), intent(in) :: par(num_target_params)
  real(real64) eta(num_output)
  integer month_counter, i
  real(real64) conc_data(num_WQ)

  eta = 0.0d0; conc_data = 0.0d0
  ! print*, 'params in output', par(:)

    MonthCounterLoop: &
    do i = 1, month_run
      month_counter = i

        Kgrowth_ALG = par(1)
        Kgrowth_Haer = par(2)
        Khyd = par(3)
        KNH_aer = par(4)
        KO2_Haer = par(5)
        KS_Haer = par(6)
        Kgrowth_Anox = par(7)
        KS_Anox = par(8)
        Kgrowth_N1  = par(9)
        Kgrowth_N2 = par(10)
        Kdeath_ALG = par(11)
        Kdeath_CON = par(12)
        Kgrowth_CON = par(13)
        Kresp_ALG = par(14)
        Kresp_CON = par(15)
        Kresp_Haer = par(16)
        Kresp_Anox = par(17)
        Kresp_N1 = par(18)
        Kresp_N2 = par(19)
        KHPO4_ALG = par(20)
        KHPO4_Haer = par(21)
        KHPO4_Anox = par(22)
        KHPO4_N1 = par(23)
        KHPO4_N2 = par(24)
        KN_ALG = par(25)
        KNH4_ALG = par(26)
        KNH4_N1 = par(27)
        K1 = par(28)
        KNO3_Anox = par(29)
        KNO2_Anox = par(30)
        KNO2_N2 = par(31)
        KO2_ALG = par(32)
        KO2_CON = par(33)
        KO2_N1 = par(34)
        KO2_N2 = par(35)

        ! print*, 'Kgrowth_ALG in mod_sim', Kgrowth_ALG


      call river(dataset_number, conc_data, month_counter, & 
        overwrite_params = [ &
               Kdeath_CON, &    
               Kgrowth_CON, &    
               Kresp_CON, &    
               Kresp_N2, &    
               KHPO4_ALG, &    
               KHPO4_Haer, &    
               KHPO4_Anox, &    
               KHPO4_N1, &    
               KHPO4_N2, &    
               KN_ALG, &
                KNH4_ALG, &
                KNO3_Anox, &
                KNO2_Anox, &
                KO2_ALG, &
                KO2_CON, &
                KO2_N1, &
                Beta_ALG, &
                Beta_CON, & 
                Beta_H, & 
                Beta_HY, & 
                Beta_N1, &
                Beta_N2, & 
                Temp0, &
                Kresp_Haer, &
                Kresp_N1, &
                K1, &
                Kgrowth_N2, &
                Kgrowth_Haer, &
                KS_Haer, &
                Kgrowth_ALG, &
                Kgrowth_Anox, &
                Kdeath_ALG, &
                KO2_Haer, &
                KNH_aer, &
                KS_Anox, &
                Kresp_ALG, &
                Kresp_Anox, &
                KNO2_N2, &
                KO2_N2, &
                Khyd, &
                Kgrowth_N1 , &
                KNH4_N1], &
         is_print_results = .false., &
         is_output = .false., is_kinetic = .true.)   
      
      eta(month_counter) = conc_data(1)
      eta(month_counter+12) = conc_data(2)
      eta(month_counter+24) = conc_data(3)
      eta(month_counter+36) = conc_data(4)
      eta(month_counter+48) = conc_data(5)

    end do MonthCounterLoop

    
  end function



end module sim_sensitivity_kinetic
