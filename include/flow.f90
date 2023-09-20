module River_hydraulic
    use,intrinsic :: iso_fortran_env
    use :: param_pool_3
    use :: dataset
    
    implicit none

    real(real64):: Simulation_days = 30.0d0, deltaT = 1.0d-3, Dis_rate = 0.74d0
    integer :: month_time_total, print_count


contains
subroutine flow(dataset_number, month_counter, hydraulic_data, num_mixing, &
                SepticDischarge, WeatherData, WaterTemp, Precipitation, &
                overwrite_params, param_id_list, is_overwrite, is_print_results)
    integer, intent(in) :: dataset_number, num_mixing, month_counter
    logical, intent(in) :: is_overwrite, is_print_results
    real(real64), intent(out) :: hydraulic_data(num_mixing,total_dataset,month_run, num_hydraulic_data) 
    real(real64), intent(in) :: overwrite_params(:)
    integer, intent(in) :: param_id_list(:) 
    real(real64), intent(out) :: SepticDischarge(5), WeatherData(month_run), WaterTemp(total_dataset,month_run), &
                 Precipitation(total_dataset,month_run)
    integer Loc_Pointer, Time_Pointer, Div_Total
    integer mixingPoint
    real(real64) ALLRiver_Q_sec, ALLRiver_Q, ALLRiver_TankV, ALLRiver_H, ALLRiver_U
    real(real64) ALLRiver_L, land_area, PrecipiQ, River_Q, PrecipiData, ALLRiver_A, ALLRiver_R, ALLRiver_E
    real(real64) Initial_ALLRiver_Q_For_3
    
    real(real64) RiverFlow(total_dataset,month_run), velocity_observed_Ch(total_dataset, month_run), &
                 velocity_observed_Ku(total_dataset,month_run)
    real(real64) glob_fsig_C(total_dataset,month_run)
    real(real64) par(num_params_3)

    call import_data_flow(dataset_number, SepticDischarge, WeatherData, WaterTemp, Precipitation, &
                      RiverFlow, velocity_observed_Ch, velocity_observed_Ku, glob_fsig_C)


    month_time_total = int(Simulation_days/deltaT)

    print_count = ceiling(1/deltaT)

    if(is_overwrite .eqv. .false.) then
      par(:) = param_pooling_3(overwrite_params, param_id_list, is_overwrite)
    else
      ALLRiver_n = overwrite_params(1)
      ALLRiver_I = overwrite_params(2)
      ALLRiver_B = overwrite_params(3)
    end if

    ! print*, 'AllRiver n, I, B in flow.f90', ALLRiver_n, ALLRiver_I, ALLRiver_B
    

    if (is_print_results) then
      if (dataset_number == 1) then
        ! ALLRiver_n=0.041d0; ALLRiver_I=0.001d0; ALLRiver_B=10.4d0
          open(unit=51, file='./output-csv/Model-evaluation-Ch-1.csv')
          open(unit=52, file='./output-csv/Model-evaluation-Ku-1.csv')
      else if (dataset_number == 2) then
        ! ALLRiver_n=0.041d0; ALLRiver_I=0.001d0; ALLRiver_B=10.4d0
          open(unit=53, file='./output-csv/Model-evaluation-Ch-2.csv')
          open(unit=54, file='./output-csv/Model-evaluation-Ku-2.csv')
      else if (dataset_number == 3) then
        ! overwrite paramter values
        ! ALLRiver_n=0.049d0; ALLRiver_I=0.001d0; ALLRiver_B=11.3d0 
          open(unit=55, file='./output-csv/Model-evaluation-Ch-3.csv')
          open(unit=56, file='./output-csv/Model-evaluation-Ku-3.csv')
      end if
    end if

    MixingPointLoop: &
    do mixingPoint = 1, num_mixing

      PrecipiData = Precipitation(dataset_number, month_counter)  

      ! Unit: ALLRiver_L [m], land_area [m^2]
      select case(mixingPoint)
          case (1) ! Jugo mixing point
              ALLRiver_L = 390.0d0
              land_area = 860000.0d0  ! covering area for Kyugo
              PrecipiQ = Dis_rate * land_area * PrecipiData/1000.0d0/30.0d0 
              ALLRiver_Q = RiverFlow(dataset_number, month_counter) - SepticDischarge(2) - PrecipiQ

              ! update PrecipiQ used for DO calculation
              land_area = 926000.0d0  ! covering area for Jugo
              PrecipiQ = Dis_rate * land_area * PrecipiData/1000.0d0/30.0d0 
              River_Q = ALLRiver_Q - SepticDischarge(1) - PrecipiQ

              ! print*, 'Diff between ALLRiver_Q and River_Q at mixing point 1', ALLRiver_Q - River_Q
          case (2) ! Kyugo mixing point
              ALLRiver_L = 870.0d0

              ! Just for DO calculation
              land_area = 860000.0d0  ! covering area for Kyugo
              PrecipiQ = Dis_rate * land_area * PrecipiData/1000.0d0/30.0d0 
              ALLRiver_Q = RiverFlow(dataset_number, month_counter) ! Using monitored data in Chubu

              ! print*, 'Diff between ALLRiver_Q and River_Q at mixing point 2', ALLRiver_Q - River_Q
          case (3)
              ALLRiver_L = 1490.0d0
              land_area = 1521000.0d0 ! covering area for Chubu
              PrecipiQ = Dis_rate * land_area * PrecipiData/1000.0d0/30.0d0 
              ALLRiver_Q = RiverFlow(dataset_number, month_counter) + SepticDischarge(3) + PrecipiQ
              Initial_ALLRiver_Q_For_3 = ALLRiver_Q

              ! print*, 'Diff between ALLRiver_Q and River_Q at mixing point 3', ALLRiver_Q - River_Q
      end select

      ! calculate a height of water level in the stream using a function defined below
      ALLRiver_H = depth_calc(ALLRiver_B, ALLRiver_I, ALLRiver_n, ALLRiver_Q)

      ALLRiver_A = ALLRiver_B * ALLRiver_H
      ALLRiver_R = ALLRiver_A/(2.0d0 * ALLRiver_H + ALLRiver_B)
      ALLRiver_U = (1 / ALLRiver_n) * ALLRiver_R ** 0.6666666667 * ALLRiver_I ** 0.5d0

      ! print*,'Month: ', month_counter, 'Mixing point: ', mixingPoint, ', Velocity: ', ALLRiver_U
      
      ALLRiver_E = 2.0d0*sqrt(9.8d0*ALLRiver_R*((ALLRiver_n**2 * ALLRiver_U**2)/ALLRiver_R**(1.3333333333))) & 
                  * ALLRiver_H * (ALLRiver_B/ALLRiver_H)**1.5
      Div_Total = int((ALLRiver_U * ALLRiver_L)/(2.0d0 * ALLRiver_E) + 1.0d0)

      if (Div_Total < 10) Then
          Div_Total = 10
      End if

      ! print*,'Month: ', month_counter, 'Mixing point: ', mixingPoint, ', Div Total ', Div_Total

      select case(mixingPoint)
        case(2)
            ALLRiver_Q_sec = ALLRiver_Q/dble(86400)
            if (is_print_results) then
              if (dataset_number == 1) then
                write(51, '(*(g0:,","))') month_counter, ALLRiver_U, velocity_observed_Ch(dataset_number, month_counter)
              else if (dataset_number == 2) then
                write(53, '(*(g0:,","))') month_counter, ALLRiver_U, velocity_observed_Ch(dataset_number, month_counter)
              else if (dataset_number == 3) then
                write(55, '(*(g0:,","))') month_counter, ALLRiver_U, velocity_observed_Ch(dataset_number, month_counter)
              end if
            end if
        case(3)
            ALLRiver_Q_sec = ALLRiver_Q/dble(86400)
            if (is_print_results) then
              if (dataset_number == 1) then
                write(52, '(*(g0:,","))') month_counter, ALLRiver_U, velocity_observed_Ku(dataset_number, month_counter)
              else if (dataset_number == 2) then
                write(54, '(*(g0:,","))') month_counter, ALLRiver_U, velocity_observed_Ku(dataset_number, month_counter)
              else if (dataset_number == 3) then
                write(56, '(*(g0:,","))') month_counter, ALLRiver_U, velocity_observed_Ku(dataset_number, month_counter)
              end if
            end if
      end select

      ALLRiver_TankV = ALLRiver_B * ALLRiver_H * ALLRiver_L / Div_Total

      
      ! Loop calculation
      do Time_Pointer = 2, month_time_total

        if(mixingPoint == 3) then
          ALLRiver_Q = Initial_ALLRiver_Q_For_3
        end if 

        do Loc_Pointer = 2, Div_Total    


          if (mixingPoint == 3) then
            ALLRiver_Q = ALLRiver_Q + SepticDischarge(4)/Div_Total
          end if            
                                                                                                
      end do !Loc_counter

      end do  !Time_counter

      hydraulic_data(mixingPoint,dataset_number,month_counter,1) = ALLRiver_n
      hydraulic_data(mixingPoint,dataset_number,month_counter,2) = ALLRiver_U
      hydraulic_data(mixingPoint,dataset_number,month_counter,3) = ALLRiver_H
      hydraulic_data(mixingPoint,dataset_number,month_counter,4) = River_Q
      hydraulic_data(mixingPoint,dataset_number,month_counter,5) = ALLRiver_Q
      if (mixingPoint == 3) then
        hydraulic_data(mixingPoint,dataset_number,month_counter,5) = Initial_ALLRiver_Q_For_3
      end if
      hydraulic_data(mixingPoint,dataset_number,month_counter,6) = Div_Total
      hydraulic_data(mixingPoint,dataset_number,month_counter,7) = ALLRiver_TankV
      hydraulic_data(mixingPoint,dataset_number,month_counter,8) = PrecipiQ

      River_Q = ALLRiver_Q

end do MixingPointLoop


end subroutine flow


function depth_calc(ALL_River_B, ALLRiver_I, ALLRiver_n, ALL_River_Q) result(ALL_RIver_H)
    real(real64), intent(in) :: ALL_River_B, ALLRiver_I, ALLRiver_n, ALL_River_Q

    real(real64) ALL_RIver_H, f, fp, ALL_River_Q_sec
    integer i

    !initial guess
    ALL_RIver_H = 0.2d0
    ALL_River_Q_sec = ALL_River_Q/dble(86400)

    do i = 1, 5
        f = (ALL_River_B * ALLRiver_I**0.5)/(ALLRiver_n * ALL_River_Q_sec) * ALL_RIver_H**1.67 &
            - (2.0d0*ALL_RIver_H/ALL_River_B  + 1)**0.67
        fp = 5.0d0/3.0d0 * (ALL_River_B  * ALLRiver_I**0.5)/(ALLRiver_n * ALL_River_Q_sec) * ALL_RIver_H**0.67 &
            - 2.0d0/3.0d0 * (2.0d0*ALL_RIver_H/ALL_River_B  + 1)**(-0.33) * (2.0d0/ALL_River_B)
        
        ALL_RIver_H  = ALL_RIver_H  - f/fp
    end do 
end function depth_calc


end module River_hydraulic