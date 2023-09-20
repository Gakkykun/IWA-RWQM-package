FC = gfortran
FCFLAGS = -O3

SRCS := ../include/param_pool.f90 \
		../include/param_pool_2.f90 \
		../include/param_pool_3.f90 \
		../include/dataset.f90 \
		../include/flow.f90 \
		../include/river.f90 \
		../include/mod_sim_calibration.f90

OBJS := $(addsuffix .o, $(SRCS))

.PHONY: all clean
.SUFFIXES: .f90 .o

all: main

main: main.f90 $(OBJS) 
	$(FC) $(FCFLAGS) $< $(OBJS) -o $@


$(OBJS): %.o: %
	$(FC) -c $(FCFLAGS) -o $@ $<

param_pool.mod := param_pool.f90.o 
param_pool_2.mod := ../include/param_pool_2.f90.o
param_pool_3.mod := ../include/param_pool_3.f90.o
dataset.mod := ../include/dataset.f90.o
River_hydraulic.mod := ../include/flow.f90.o
River_WQ.mod := ../include/river.f90.o
sim_calibration.mod := mod_sim_calibration.f90.o


dataset.f90.o: ${param_pool_2.mod}
flow.f90.o: ${param_pool_3.mod}
flow.f90.o: ${dataset.mod}
river.f90.o: ${dataset.mod}
river.f90.o: ${param_pool.mod}
river.f90.o: ${param_pool_2.mod}
river.f90.o: ${River_hydraulic.mod}
mod_sim_calibration.f90.o: ${param_pool.mod}
mod_sim_calibration.f90.o: ${param_pool_2.mod}
mod_sim_calibration.f90.o: ${param_pool_3.mod}
mod_sim_calibration.f90.o: ${dataset.mod}
mod_sim_calibration.f90.o: ${River_hydraulic.mod}
mod_sim_calibration.f90.o: ${River_WQ.mod}

UNAME_S := $(shell uname -s)

cleanall: 	
ifeq ($(UNAME_S),Linux)
	$(RM) main *.o *.mod ../include/*.o 
endif

ifeq ($(OS),Windows_NT)
	del main *.o *.mod ..\include\*.o
endif
