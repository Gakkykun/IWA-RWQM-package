FC = gfortran
FCFLAGS = -O3

# OBJS = param_pool.o SBR.o mod_sim.o

SRCS := ../include/param_pool.f90 \
		../include/param_pool_2.f90 \
		../include/param_pool_3.f90 \
		../include/dataset.f90 \
		../include/flow.f90 \
		../include/river.f90 \
		../include/mod_sim_sensitivity_WQ.f90

OBJS := $(addsuffix .o, $(SRCS))

.PHONY: all clean
.SUFFIXES: .f90 .o

all: main

main: main.f90 $(OBJS)
	$(FC) $(FCFLAGS) $< $(OBJS) -o $@

$(OBJS): %.o: %
	$(FC) -c $(FCFLAGS) -o $@ $<


param_pool.mod := param_pool.f90.o
param_pool_2.mod := param_pool_2.f90.o
param_pool_3.mod := param_pool_3.f90.o
dataset.mod := dataset.f90.o
River_hydraulic.mod := flow.f90.o
River_WQ.mod := river.f90.o
sim_sensitivity_WQ.mod := mod_sim_sensitivity_WQ.f90.o

dataset.f90.o: ${param_pool_2.mod}
flow.f90.o: ${param_pool_3.mod}
flow.f90.o: ${dataset.mod}
river.f90.o: ${dataset.mod}
river.f90.o: ${param_pool.mod}
river.f90.o: ${param_pool_2.mod}
river.f90.o: ${param_pool_3.mod}
river.f90.o: ${River_hydraulic.mod}
mod_sim_sensitivity_WQ.f90.o: ${param_pool.mod}
mod_sim_sensitivity_WQ.f90.o: ${param_pool_2.mod}
mod_sim_sensitivity_WQ.f90.o: ${param_pool_3.mod}
mod_sim_sensitivity_WQ.f90.o: ${dataset.mod}
mod_sim_sensitivity_WQ.f90.o: ${River_hydraulic.mod}
mod_sim_sensitivity_WQ.f90.o: ${River_WQ.mod}

cleanall: 	
ifeq ($(UNAME_S),Linux)
	cd sensitivity-output && rm -f *.csv
	$(RM) main *.o *.mod ../include/*.o 
endif

ifeq ($(OS),Windows_NT)
	cd sensitivity-output && del *.csv
	del main *.o *.mod ..\include\*.o
endif
