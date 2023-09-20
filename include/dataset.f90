module dataset
    use,intrinsic :: iso_fortran_env
    use :: param_pool_2
    integer(int32), parameter :: num_variables = 14, num_processes = 22, &
                                  month_run = 12, num_mixing = 3, total_dataset = 3, &
                                  num_WQ = 5, num_hydraulic_data = 8

contains
subroutine import_data_flow(dataset_number, SepticDischarge, WeatherData, WaterTemp, Precipitation, &
                      RiverFlow, velocity_observed_Ch, velocity_observed_Ku, glob_fsig_C)
    integer, intent(in) :: dataset_number
    real(real64), intent(out) :: SepticDischarge(5), WeatherData(month_run), WaterTemp(total_dataset,month_run), &
                                Precipitation(total_dataset,month_run)
    real(real64), intent(out) :: RiverFlow(total_dataset,month_run), velocity_observed_Ch(total_dataset, month_run), &
                                velocity_observed_Ku(total_dataset,month_run)
    real(real64), intent(out) :: glob_fsig_C(total_dataset, month_run)
    integer i

    ! Median precipitation (2005-2010) 
    Precipitation(1, :) = [16d0, 33.25d0, 38d0, 63.25d0, 105.5d0, 127.75d0, &
      172.25d0, 123.25d0, 123d0, 143.5d0, 63.75d0, 53.75d0]

    ! Average water temperature(2005-2010) 
    WaterTemp(1, :) = [11.8d0, 11.5d0, 13.4d0, 18.0d0, 21.0d0, 22.7d0, &
        23.6d0, 24.2d0, 21.7d0, 19.8d0, 18.2d0, 15.1d0]

    ! unit m^3/s avg observed data at Chubu (2005-2010)
    RiverFlow(1, :) = [0.0808d0, 0.0478d0, 0.0504d0, 0.07567d0, 0.0477d0, 0.05917d0, &
      0.09283d0, 0.2258d0, 0.3337d0, 0.3885d0, 0.2767d0, 0.1763d0]
    ! unit m^3/d
    RiverFlow(1, :) = 86400d0 * RiverFlow(1, :) 

     ! avg velocity observed at Chubu and Kuki (2005-2010) 
    velocity_observed_Ch(1, :) = [0.138d0, 0.10675d0, 0.0965d0, 0.1036d0,0.0964d0, 0.1134d0, 0.138d0, 0.1934d0, &
      0.198d0,0.2034d0, 0.1932d0, 0.2028d0]

    velocity_observed_Ku(1,:) = [0.167d0, 0.11675d0, 0.124d0, 0.1214d0, 0.0884d0, 0.1148d0, 0.161d0, 0.1706d0, 0.1644d0, &
      0.1854d0, 0.1576d0, 0.1544d0]

   

    ! avg precipitation (2011-2014) 
    Precipitation(2, :) = [29.0d0, 23.0d0, 35.5d0, 54.5d0, 158.0d0, 207.0d0, &
    88.0d0, 77.8d0, 216.8d0, 170.3d0, 31.3d0, 26.8d0]

    ! avg water temperature(2011-2014) 
    WaterTemp(2, :) = [10.9d0, 11.4d0, 14.5d0, 22.3d0, 22.4d0, 24.2d0, &
      23.3d0, 24.8d0, 21.2d0, 20.5d0, 18.5d0, 15.9d0] 

    ! unit m^3/s avg observed data at Chubu (2011-2014)
    RiverFlow(2, :) = [0.05825d0, 0.03075d0, 0.03525d0, 0.038d0, 0.0575d0, 0.09d0, & 
      0.1385d0, 0.23175d0, 0.4085d0, 0.3675d0, 0.3135d0, 0.173d0]

    ! unit m^3/d
    RiverFlow(2, :) = 86400d0 * RiverFlow(2, :) 

    ! avg velocity observed at Chubu and Kuki (2011-2014) 
    velocity_observed_Ch(2, :) = [0.0835d0, 0.05475d0, 0.0665d0, 0.0635d0, 0.08725d0, 0.111d0, 0.14325d0, 0.19725d0, &
      0.248d0, 0.246d0, 0.2395d0, 0.18675d0]

    velocity_observed_Ku(2,:) = [0.118d0, 0.09075d0, 0.083d0, 0.151d0, 0.14975d0, 0.15675d0, 0.15775d0, 0.217d0, &
      0.2245d0, 0.2195d0, 0.2245d0, 0.1615d0]


    ! avg precipitation (2015-2018) 
    Precipitation(3, :) = [18.5d0, 15d0, 76d0, 45.75d0, 56d0, 122d0, &
      141d0, 217.75d0, 278d0, 28.25d0, 42.25d0, 13d0]

    ! avg water temperature(2015-2018) 
    WaterTemp(3, :) = [12.5d0, 12.3d0, 14.1d0, 22.3d0, 24.8d0, 26.0d0, &
      25.4d0, 25.8d0, 21.8d0, 20.5d0, 18.0d0, 15.8d0]

    ! unit m^3/s avg observed data at Chubu (2015-2018)
    RiverFlow(3, :) = [0.0774d0, 0.0446d0, 0.032d0, 0.0267d0, 0.0273d0, 0.07d0, & 
      0.0925d0, 0.15675d0, 0.36375d0, 0.47525d0, 0.35675d0, 0.189d0]
    ! unit m^3/d
    RiverFlow(3, :) = 86400d0 * RiverFlow(3, :) 

    ! avg velocity observed at Chubu and Kuki(2015-2018) 
    velocity_observed_Ch(3, :) = [0.1396d0, 0.1008d0, 0.0716d0, 0.062d0, 0.062d0, 0.0923d0, 0.103d0, 0.137d0, &
      0.14675d0, 0.21675d0, 0.22975d0, 0.20475d0]

    velocity_observed_Ku(3,:) = [0.1224d0, 0.1176d0, 0.096d0, 0.09767d0, 0.092d0, 0.108d0, 0.12725d0, &
      0.141d0, 0.1885d0, 0.2265d0, 0.24525d0, 0.18825d0]


    ! unit: m^3/d - Mixing points(Jugo, Kyugo, Chubu, Direct, Kuki)
    SepticDischarge(:) = [135.35d0, 52.73d0, 78.91d0, 1107.04d0, 421.42d0]

    
    
    ! unit: W/m^2 - January to December assume that this data has not varied over yeas
    WeatherData(:) = [120.1d0, 177.3d0, 194.5d0, 184.8d0, 167.0d0, 155.8d0, 139.9d0, 169.6d0, 139.0d0, 125.4d0, 116.5d0, 100.0d0]

    ! velocity standard deviation observed at Chubu (2005-2010) 
    glob_fsig_C(1, :) = [0.262d0, 0.018d0, 0.017d0, 0.025d0, 0.039d0, 0.050d0, 0.107d0, 0.088d0, 0.060d0, 0.052d0, 0.023d0, 0.017d0]

    ! velocity standard deviation observed at Chubu (2011-2014) 
    glob_fsig_C(2, :) = [0.022d0, 0.020d0, 0.046d0, 0.041d0, 0.045d0, 0.059d0, 0.052d0, 0.022d0, 0.026d0, 0.039d0, 0.021d0, 0.062d0]

    ! velocity standard deviation observed at Chubu (2015-2018) 
    glob_fsig_C(3, :) = [0.040d0, 0.049d0, 0.029d0, 0.014d0, 0.019d0, 0.034d0, 0.034d0, 0.048d0, 0.029d0, 0.055d0, 0.033d0, 0.041d0]


end subroutine import_data_flow

subroutine import_data_monitoring_WQ(monitoring_data_K, glob_fsig_K)
   real(real64), intent(out) :: monitoring_data_K(total_dataset,num_WQ,month_run), &
                               glob_fsig_K(total_dataset,num_WQ,month_run) 

     ! Median data at Kuki observatory point (2005 - 2010) 
    monitoring_data_K(1,1,:) = [6.7d0, 6.7d0, 6.6d0, 5.3d0, 5.3d0, 5.2d0, 4.5d0, 5.35d0, 6.75d0, 6.55d0, 7.2d0, 6.55d0] ! O2
    monitoring_data_K(1,2,:) = [6.1d0, 6.3d0, 7.5d0, 7.9d0, 5d0, 4.7d0, 5.2d0, 4.6d0, 5.4d0, 4.25d0, 3.75d0, 4.75d0] ! BOD
    monitoring_data_K(1,3,:) = [9d0, 12d0, 10d0, 16.3d0, 9d0, 4.95d0, 17d0, 15.5d0, 26.4d0, 16d0, 11.5d0, 8.65d0] ! SS
    monitoring_data_K(1,4,:) = [6.73d0, 7.26d0, 7.79d0, 8.08d0, 10.59d0, 7.88d0, 6.50d0, 4.04d0, 2.20d0, 2.52d0, 2.07d0, 7.24d0] ! NH4
    monitoring_data_K(1,5,:) = [10.20d0, 10.30d0, 8.00d0, 8.40d0, 9.65d0, 10.55d0, 10.35d0, 10.45d0, &
                                  11.60d0, 13.0d0, 12.45d0, 15.00d0] ! NOx

    ! Mean data at Kuki (2011 - 2014)
    monitoring_data_K(2,1,:) = [8.25d0, 9.25d0, 10.15d0, 7.85d0, 8.45d0, 8.6d0, 6.8d0, 7.05d0, 6.9d0, 7.2d0, 7.95d0,  8d0] ! O2
    monitoring_data_K(2,2,:) = [5.2d0, 6.7d0, 6.9d0, 7.75d0, 4.55d0, 4.6d0, 4.45d0, 3.55d0, 2.55d0, 1.75d0, 2.3d0, 3.15d0] ! BOD
    monitoring_data_K(2,3,:) = [6.8d0, 6.15d0, 10.65d0, 19.9d0, 8.4d0, 13.4d0, 21.1d0, 26d0, 21.95d0, 12.25d0, 8.25d0, 5.25d0] ! SS
    monitoring_data_K(2,4,:) = [6.685d0, 5.755d0, 6.2d0, 6.47d0, 5.555d0, 2.89d0, 1.94d0, 0.635d0, 0.455d0, &
                                  0.58d0, 0.535d0, 1.895d0] ! NH4
    monitoring_data_K(2,5,:) = [7.835d0, 6.89d0, 5.97d0, 4.71d0, 5.005d0, 6.49d0, 7.56d0, 8.055d0, 8.44d0, 9.11d0, 9.19d0, 8.91d0] ! NOx

    ! Mean data at Kuki (2015 - 2018)
    monitoring_data_K(3,1,:) = [8.6d0, 9.2d0, 9.4d0, 9.9d0, 8.1d0, 4.1d0, 4.7d0, 4.4d0, 6.15d0, 7.7d0, 7.7d0, 7.5d0] ! O2
    monitoring_data_K(3,2,:) = [3.2d0, 4.2d0, 5.1d0, 6.3d0, 3.2d0, 3.3d0, 3.85d0, 3.15d0, 1.6d0, 1.6d0, 1.3d0, 1.95d0] ! BOD
    monitoring_data_K(3,3,:) = [2.3d0, 5.2d0, 8.4d0, 5d0, 8d0, 28d0, 21.65d0, 25.35d0, 16.25d0, 13d0, 6.6d0, 3.3d0] ! SS
    monitoring_data_K(3,4,:) = [2.3d0, 2.7d0, 2.19d0, 3.11d0, 2.7d0, 1.68d0, 0.775d0, 0.37d0, 0.16d0, 0.175d0, 0.245d0, 0.63d0] ! NH4
    monitoring_data_K(3,5,:) = [8.32d0, 7.16d0, 6.19d0, 4.92d0, 2.78d0, 5.27d0, 6.79d0, 7.725d0, 8.42d0, 8.78d0, 9.45d0, 9.12d0] ! NOx


    ! Calculated standard deviation (2005 - 2010) 
    glob_fsig_K(1,1,:) = [1.06d0, 1.38d0, 0.77d0, 1.57d0, 1.67d0, 1.15d0, 0.71d0, 0.86d0, 0.99d0, 1.25d0, 0.83d0, 0.73d0] ! O2
    glob_fsig_K(1,2,:) = [1.69d0, 2.19d0, 2.24d0, 2.39d0, 1.84d0, 1.29d0, 2.34d0, 1.15d0, 2.20d0, 1.54d0, 1.29d0, 1.26d0] ! BOD
    glob_fsig_K(1,3,:) = [4.82d0, 4.22d0, 3.96d0, 13.09d0, 3.38d0, 18.94d0, 16.29d0, 11.04d0, 15.43d0, 2.39d0, 4.49d0,  13.62d0] ! SS
    glob_fsig_K(1,4,:) = [1.51d0, 3.59d0, 2.19d0, 4.55d0, 7.66d0, 10.96d0, 11.99d0, 2.72d0, 2.68d0, 1.71d0, 0.56d0, 2.87d0]
    glob_fsig_K(1,5,:) = [0.93d0, 1.32d0, 2.08d0, 2.90d0, 2.94d0, 2.60d0, 2.02d0, 4.45d0, 1.69d0, 2.78d0, 1.15d0, 4.00d0]

    ! Calculated standard deviation (2011 - 2014) 
    glob_fsig_K(2,1,:) = [1.47d0, 2.04d0, 2.37d0, 3.61d0, 3.74d0, 2.25d0, 0.81d0, 2.02d0, 0.54d0, 0.84d0, 1.08d0, 1.18d0] ! O2
    glob_fsig_K(2,2,:) = [3.15d0, 1.36d0, 1.87d0, 3.02d0, 1.89d0, 2.10d0, 2.99d0, 0.88d0, 1.05d0, 0.29d0, 0.91d0, 1.07d0] ! BOD
    glob_fsig_K(2,3,:) = [2.03d0, 2.57d0, 5.04d0, 23.22d0, 2.60d0, 13.34d0, 7.28d0, 4.61d0, 19.16d0, 1.40d0, 1.44d0, 2.05d0] ! SS
    glob_fsig_K(2,4,:) = [10.26d0, 2.72d0, 2.94d0, 4.25d0, 2.94d0, 2.25d0, 3.07d0, 2.18d0, 0.12d0, 0.39d0, 0.34d0, 1.33d0]
    glob_fsig_K(2,5,:) = [1.89d0, 2.03d0, 2.45d0, 2.93d0, 0.97d0, 2.25d0, 2.20d0, 3.32d0, 1.10d0, 1.39d0, 1.75d0, 1.59d0]

    ! Calculated standard deviation (2015 - 2018) 
    glob_fsig_K(3,1,:) = [0.53d0, 1.02d0, 1.33d0, 2.51d0, 1.00d0, 0.84d0, 0.95d0, 1.47d0, 1.45d0, 0.68d0, 0.88d0, 1.34d0] ! O2
    glob_fsig_K(3,2,:) = [0.72d0, 1.21d0, 1.91d0, 2.66d0, 1.42d0, 0.55d0, 1.85d0, 1.64d0, 0.50d0, 0.44d0, 0.34d0, 1.95d0] ! BOD
    glob_fsig_K(3,3,:) = [0.98d0, 3.96d0, 2.11d0, 2.75d0, 4.30d0, 12.55d0, 5.79d0, 2.62d0, 4.78d0, 4.93d0, 2.98d0, 7.45d0] ! SS
    glob_fsig_K(3,4,:) = [1.35d0, 0.82d0, 1.63d0, 0.78d0, 0.28d0, 0.42d0, 0.56d0, 0.03d0, 0.03d0, 0.12d0, 0.09d0, 0.34d0]
    glob_fsig_K(3,5,:) = [1.22d0, 0.74d0, 0.87d0, 1.27d0, 0.66d0, 2.46d0, 1.20d0, 0.77d0, 0.55d0, 0.89d0, 1.06d0, 1.45d0]

end subroutine import_data_monitoring_WQ


end module dataset