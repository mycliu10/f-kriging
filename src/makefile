ROUTINES=kriging.o cokriging.o analytical_solver.f90
CONSTRUCT=construct_kriging_RS.o
MODULES=params.o analytical_functions.o grid.o utils.o matrix.o regression.o correlation.o sensitivity.o mle.o
LDFLAGS=-I/usr/lib/lapack95_modules/ -llapack95 -llapack -lblas 
BINDIR=../bin

OPT = -O3
#PROFILE=-pg #comment out if you don't want profiling

default : f.f90 $(MODULES) $(CONSTRUCT) $(ROUTINES)
	gfortran $(PROFILE) -o ../foo f.f90 $(MODULES) $(TEST) $(FUNCTIONS) $(CONSTRUCT) $(ROUTINES) $(LDFLAGS) -J$(BINDIR)

%.o : %.f90
	gfortran $(PROFILE) $(OPT) -c $< $(LDFLAGS) -J$(BINDIR)

clear :
	rm *.o *.mod ../foo

sensitivity : sensitivity.o correlation.o regression.o params.o matrix.o
	gfortran -c sensitivity.f90 params.o correlation.o regression.o matrix.o $(LDFLAGS)
	gfortran -o sens ./unit-tests/sensitivity-unittests.f90 sensitivity.o params.o correlation.o regression.o matrix.o $(LDFLAGS) && ./sens
	