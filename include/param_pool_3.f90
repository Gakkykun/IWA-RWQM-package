module param_pool_3 
    use,intrinsic :: iso_fortran_env
    integer(int32), parameter :: num_params_3 = 3
    real(real64) ::  ALLRiver_n, ALLRiver_I, ALLRiver_B 
          

contains
function param_pooling_3(overwrite_params, param_id_list, is_overwrite) result (param_vals_filled)
    real(real64), intent(in) :: overwrite_params(:)
    integer(int32), intent(in) :: param_id_list(:)
    logical, intent(in) :: is_overwrite
    real(real64) :: param_values(num_params_3), param_vals_filled(num_params_3)
    integer i
    character(80) param_names(num_params_3)

    param_values = 0.0d0

    open(unit=79, file='../param_list_3.csv', status='old')
    do i=1,num_params_3
      read(79,*) param_names(i), param_values(i)
    end do
    close(79)

  
    ALLRiver_n = param_values(1)
    ALLRiver_I = param_values(2)
    ALLRiver_B = param_values(3)
    

    param_vals_filled = [ALLRiver_n, ALLRiver_I, ALLRiver_B]


    if (is_overwrite) then
      if (param_id_list(1) /= 0) then
        do i = 1, size(param_id_list)
          param_vals_filled(param_id_list(i)) = overwrite_params(i)
        end do
      end if


    end if

end function

end module 
