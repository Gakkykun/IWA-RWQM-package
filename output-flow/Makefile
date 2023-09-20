FC = gfortran
FCFLAGS = -O3

SRCS := ../include/param_pool_2.f90 \
		../include/param_pool_3.f90 \
		../include/dataset.f90 \
		../include/flow.f90 \

OBJS := $(addsuffix .o, $(SRCS))

.PHONY: all clean cleanall
.SUFFIXES: .f90 .o

all: main

main: main.f90 $(OBJS)
	$(FC) $(FCFLAGS) $< $(OBJS) -o $@


$(OBJS): %.o: %
	$(FC) -c $(FCFLAGS) -I ../include -o $@ $<

# param_pool.mod := ../include/param_pool.f90.o
param_pool_2.mod := ../include/param_pool_2.f90.o
param_pool_3.mod := ../include/param_pool_3.f90.o
dataset.mod := ../include/dataset.f90.o
River_hydraulic.mod := ../include/flow.f90.o

../include/dataset.f90.o: ${param_pool_2.mod}
../include/flow.f90.o: ${param_pool_3.mod}
../include/flow.f90.o: ${dataset.mod}

UNAME_S := $(shell uname -s)

cleanall: 	
ifeq ($(UNAME_S),Linux)
	cd output-csv && rm -f *.csv
	$(RM) main *.o *.mod ../include/*.o 
endif

ifeq ($(OS),Windows_NT)
	cd output-csv && del *.csv
	del main *.o *.mod ..\include\*.o
endif
