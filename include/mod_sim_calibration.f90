module sim_calibration
 use,intrinsic :: iso_fortran_env
 use :: param_pool
 use :: dataset
 use :: River_WQ
implicit none 
  

contains
function output(npar, par, dataset_number) result (chi2)
  integer, intent(in) :: npar, dataset_number
  real(real64), intent(in) :: par(npar)
  real(real64) chi2
  real(real64) monitoring_data_K(total_dataset,num_WQ,month_run), glob_fsig_K(total_dataset,num_WQ,month_run)
  integer i, j, month_counter
  real(real64) conc_data(num_WQ)
  real(real64) param_vals_retrieved(num_params)  

  chi2 = 0.0d0; conc_data = 0.0d0 !zero reset
  
  call import_data_monitoring_WQ(monitoring_data_K, glob_fsig_K) 

  ! loading kinetic parameters
  param_vals_retrieved(:) = param_pooling(overwrite_params = [0.0d0], param_id_list=[0], is_overwrite=.false.)

  MonthCounterLoop: &
  do j = 1, month_run
    month_counter = j

    ! call river(dataset_number, conc_data, month_counter, & 
    !   overwrite_params = [ &
    !     K1, Khyd, KS_Haer, KS_Anox, Kgrowth_ALG], &
    !   param_id_list = [&
    !     26, 40, 29, 35, 30], is_overwrite = .true., is_print_results = .false.)

    K1 = par(1); Khyd = par(2); 
    KS_Haer = par(3); KS_Anox = par(4); Kgrowth_ALG = par(5)


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

    

    do i = 1, num_WQ
      chi2 = chi2 + (monitoring_data_K(dataset_number,i, month_counter)- conc_data(i))* &
                  (monitoring_data_K(dataset_number,i, month_counter) - conc_data(i)) &
              /(glob_fsig_K(dataset_number,i,month_counter)*glob_fsig_K(dataset_number,i,month_counter))

      ! print*, 'month_counter', month_counter, 'num_WQ: ', i, &
      !     ' monitoring_data_K: ', monitoring_data_K(dataset_number, i, month_counter), ' Model WQ: ', Model_WQ(i)
      !     print*, 'X_ALG ', conc_data(11)

    end do

  end do MonthCounterLoop

end function


end module sim_calibration
