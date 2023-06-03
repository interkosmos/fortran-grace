.POSIX:
.SUFFIXES:

FC      = gfortran
FFLAGS  = -Wall -fmax-errors=1
LDFLAGS =
LDLIBS  = -lgrace_np
AR      = ar
ARFLAGS = rcs
TARGET  = libfortran-grace.a

.PHONY: all clean examples

all: $(TARGET)

$(TARGET):
	$(FC) $(FFLAGS) -c src/grace.f90
	$(AR) $(ARFLAGS) $(TARGET) grace.o

examples: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o gracec examples/gracec/gracec.f90 $(TARGET) $(LDLIBS)
	$(FC) $(FFLAGS) $(LDFLAGS) -o gracef examples/gracef/gracef.f90 $(TARGET) $(LDLIBS)

clean:
	rm $(TARGET)
	rm *.mod
	rm *.o
	if [ -e gracec ]; then rm gracec; fi
	if [ -e gracef ]; then rm gracef; fi
