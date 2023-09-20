module param_pool_2 
    use,intrinsic :: iso_fortran_env
    integer(int32), parameter :: num_params_2 = 38
    real(real64) ::  &
          Ss_GW, SNH4_GW, SNO2_GW, SNO3_GW, SHPO4_GW, XH_GW, XN1_GW, XN2_GW, XS_GW, & 
          Ss_TG, SNH4_TG, SNO2_TG, SNO3_TG, SHPO4_TG, XH_TG, XN1_TG, XN2_TG, XS_TG, & 
          Ss_TB, SNH4_TB, SNO2_TB, SNO3_TB, SHPO4_TB, XH_TB, XN1_TB, XN2_TB, XS_TB, &
          Ss_KU, SNH4_KU, SNO2_KU, SNO3_KU, SHPO4_KU, XH_KU, XN1_KU, XN2_KU, XS_KU, &
          ratio_G_jkc, ratio_G_direct
          

contains
function param_pooling_2(overwrite_params, param_id_list, is_overwrite) result (param_vals_filled)
    real(real64), intent(in) :: overwrite_params(:)
    integer(int32), intent(in) :: param_id_list(:)
    logical, intent(in) :: is_overwrite
    real(real64) :: param_values(num_params_2), param_vals_filled(num_params_2)
    integer i
    character(80) param_names(num_params_2)

    param_values = 0.0d0

    open(unit=89, file='../param_list_2.csv', status='old')
    do i=1,num_params_2
      read(89,*) param_names(i), param_values(i)
    end do
    close(89)


    Ss_GW = param_values(1)
    SNH4_GW = param_values(2)
    SNO2_GW = param_values(3)
    SNO3_GW = param_values(4)
    SHPO4_GW = param_values(5)
    XH_GW = param_values(6)
    XN1_GW = param_values(7)
    XN2_GW = param_values(8)
    XS_GW = param_values(9)

    Ss_TG = param_values(10)
    SNH4_TG = param_values(11)
    SNO2_TG = param_values(12)
    SNO3_TG = param_values(13)
    SHPO4_TG = param_values(14)
    XH_TG = param_values(15)
    XN1_TG = param_values(16)
    XN2_TG = param_values(17)
    XS_TG = param_values(18)
    
    Ss_TB = param_values(19)
    SNH4_TB = param_values(20)
    SNO2_TB = param_values(21)
    SNO3_TB = param_values(22)
    SHPO4_TB = param_values(23)
    XH_TB = param_values(24)
    XN1_TB = param_values(25)
    XN2_TB = param_values(26)
    XS_TB = param_values(27)
    
    Ss_KU = param_values(28)
    SNH4_KU = param_values(29)
    SNO2_KU = param_values(30)
    SNO3_KU = param_values(31)
    SHPO4_KU = param_values(32)
    XH_KU = param_values(33)
    XN1_KU = param_values(34)
    XN2_KU = param_values(35)
    XS_KU = param_values(36)
    
    ratio_G_jkc = param_values(37)
    ratio_G_direct = param_values(38)
    

    param_vals_filled = [&
          Ss_GW, SNH4_GW, SNO2_GW, SNO3_GW, SHPO4_GW, XH_GW, XN1_GW, XN2_GW, XS_GW, & 
          Ss_TG, SNH4_TG, SNO2_TG, SNO3_TG, SHPO4_TG, XH_TG, XN1_TG, XN2_TG, XS_TG, & 
          Ss_TB, SNH4_TB, SNO2_TB, SNO3_TB, SHPO4_TB, XH_TB, XN1_TB, XN2_TB, XS_TB, &
          Ss_KU, SNH4_KU, SNO2_KU, SNO3_KU, SHPO4_KU, XH_KU, XN1_KU, XN2_KU, XS_KU, &
          ratio_G_jkc, ratio_G_direct]


    if (is_overwrite) then
      if (param_id_list(1) /= 0) then
        do i = 1, size(param_id_list)
          param_vals_filled(param_id_list(i)) = overwrite_params(i)
        end do
      end if


    end if

end function

end module 
