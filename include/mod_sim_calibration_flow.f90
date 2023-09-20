module sim_calibration_flow
 use,intrinsic :: iso_fortran_env
 use :: dataset
 use :: River_hydraulic
implicit none 
  

contains
function output(npar, par, dataset_number) result (chi2)
  integer, intent(in) :: npar, dataset_number
  real(real64), intent(in) :: par(npar)
  real(real64) chi2
  integer  i, month_counter
  real(real64) SepticDischarge(5), WeatherData(month_run), WaterTemp(total_dataset,month_run), &
              Precipitation(total_dataset,month_run), &
              RiverFlow(total_dataset,month_run), velocity_observed_Ch(total_dataset, month_run), &
              velocity_observed_Ku(total_dataset,month_run), glob_fsig_C(total_dataset,month_run), &
              ALLRiver_U, hydraulic_data(num_mixing,total_dataset,month_run, num_hydraulic_data)
  logical is_overwrite
  real(real64) overwrite_params(3)
  integer param_id_list(3)  

    ALLRiver_n = par(1)
    ALLRiver_I = par(2)
    ALLRiver_B = par(3)

    chi2 = 0.0d0
    
   call import_data_flow(dataset_number, SepticDischarge, WeatherData, WaterTemp, Precipitation, &
                      RiverFlow, velocity_observed_Ch, velocity_observed_Ku, glob_fsig_C)

    MonthCounterLoop: &
    do i = 1, month_run
      month_counter = i
      call flow(dataset_number, month_counter, hydraulic_data, num_mixing, &
        SepticDischarge, WeatherData, WaterTemp, Precipitation, &
        overwrite_params = [ &
          ALLRiver_n, ALLRiver_I, ALLRiver_B ], &
        param_id_list = [&
          81, 82, 83], is_overwrite = .true., is_print_results = .false.) 

      ALLRiver_U = hydraulic_data(2 ,dataset_number,month_counter, 2)
      print*, 'ALLRiver_U', ALLRiver_U

      chi2 = chi2 + (velocity_observed_Ch(dataset_number, month_counter)- ALLRiver_U)* &
                    (velocity_observed_Ch(dataset_number, month_counter)- ALLRiver_U) &
                /(glob_fsig_C(dataset_number, month_counter)*glob_fsig_C(dataset_number, month_counter));


    end do MonthCounterLoop

  end function



end module sim_calibration_flow
