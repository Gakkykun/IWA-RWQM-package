module param_pool 
    use,intrinsic :: iso_fortran_env
    integer(int32), parameter :: num_params = 42
    real(real64) ::  Kdeath_CON, & 
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
          Kgrowth_N1, & 
          KNH4_N1
          

contains
function param_pooling(overwrite_params, param_id_list, is_overwrite) result (param_vals_filled)
    real(real64), intent(in) :: overwrite_params(:)
    integer(int32), intent(in) :: param_id_list(:)
    logical, intent(in) :: is_overwrite
    real(real64) :: param_values(num_params), param_vals_filled(num_params)
    integer i
    character(80) param_names(num_params)

    param_values = 0.0d0

    open(unit=99, file='../param_list.csv', status='old')
    do i=1,num_params
      read(99,*) param_names(i), param_values(i)
    end do
    close(99)

    Kdeath_CON = param_values(1) 
    Kgrowth_CON = param_values(2)
    Kresp_CON = param_values(3)
    Kresp_N2 = param_values(4) 
    KHPO4_ALG = param_values(5)
    KHPO4_Haer = param_values(6) 
    KHPO4_Anox = param_values(7) 
    KHPO4_N1 = param_values(8) 
    KHPO4_N2 = param_values(9) 
    KN_ALG = param_values(10) 
    KNH4_ALG = param_values(11) 
    KNO3_Anox = param_values(12) 
    KNO2_Anox = param_values(13) 
    KO2_ALG = param_values(14) 
    KO2_CON = param_values(15) 
    KO2_N1 = param_values(16) 
    Beta_ALG = param_values(17)
    Beta_CON = param_values(18) 
    Beta_H = param_values(19) 
    Beta_HY = param_values(20) 
    Beta_N1 = param_values(21)
    Beta_N2 = param_values(22) 
    Temp0 = param_values(23) 
    Kresp_Haer = param_values(24) 
    Kresp_N1 = param_values(25) 
    K1 = param_values(26)
    Kgrowth_N2 = param_values(27) 
    Kgrowth_Haer = param_values(28) 
    KS_Haer = param_values(29)                       
    Kgrowth_ALG = param_values(30) 
    Kgrowth_Anox = param_values(31) 
    Kdeath_ALG = param_values(32) 
    KO2_Haer = param_values(33) 
    KNH_aer = param_values(34) 
    KS_Anox = param_values(35) 
    Kresp_ALG = param_values(36) 
    Kresp_Anox = param_values(37) 
    KNO2_N2 = param_values(38) 
    KO2_N2 = param_values(39) 
    Khyd = param_values(40) 
    Kgrowth_N1 = param_values(41) 
    KNH4_N1 = param_values(42)
    

    param_vals_filled = [&
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
          Kgrowth_N1, & 
          KNH4_N1]


    if (is_overwrite) then
      if (param_id_list(1) /= 0) then
        do i = 1, size(param_id_list)
          param_vals_filled(param_id_list(i)) = overwrite_params(i)
        end do
      end if


    end if

end function

end module 
