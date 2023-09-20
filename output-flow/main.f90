Program IWA
    use,intrinsic :: iso_fortran_env
    use :: River_hydraulic
    implicit none

    integer dataset_number, i, month_counter
    real(real64) hydraulic_data(num_mixing,total_dataset,month_run,num_hydraulic_data) 
    real(real64) SepticDischarge(5), WeatherData(month_run), WaterTemp(total_dataset,month_run), &
                Precipitation(total_dataset,month_run), RiverWQ_set(total_dataset,month_run,num_variables) 
    logical ex


    ! The following two commands works only for gfortran compiler
    inquire(file='./output-csv/.', exist=ex)


    if (ex) then
      print*, 'Necessary directory already there'
      print*, 'Delete csv files inside the directory...'
      print*, ''
      call system ('cd output-csv/ && rm -f *.csv')
      ! Use the followings in the Windows system instead
      ! call system ('cd output-csv && del *.csv')

    else       
        print*, 'Creating a necessary directory'
        call system('mkdir output-csv' ) 

    end if

    print*, 'Simulation starting...'


    ! dataset No.1
    dataset_number = 1
     do i = 1, month_run
        month_counter = i
        call flow(dataset_number, month_counter, hydraulic_data, num_mixing, &
                SepticDischarge, WeatherData, WaterTemp, Precipitation, &
                overwrite_params = [0.0d0], &
                param_id_list = [0], &
                is_overwrite = .false., is_print_results = .true.)  
    end do 

    ! dataset No.2
    dataset_number = 2
    do i = 1, month_run
        month_counter = i
        call flow(dataset_number, month_counter, hydraulic_data, num_mixing, &
                SepticDischarge, WeatherData, WaterTemp, Precipitation, &
                overwrite_params = [0.0d0], &
                param_id_list = [0], &
                is_overwrite = .false., is_print_results = .true.)
    end do

    ! dataset No.3
    dataset_number = 3

    do i = 1, month_run
        month_counter = i
        call flow(dataset_number, month_counter, hydraulic_data, num_mixing, &
                SepticDischarge, WeatherData, WaterTemp, Precipitation, &
                overwrite_params = [0.0d0], &
                param_id_list = [0], &
                is_overwrite = .false., is_print_results = .true.)
    end do

    print*, 'Simulation completed...'
end program IWA