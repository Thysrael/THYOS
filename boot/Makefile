INCLUDES	  := -I../include/

%.o: %.S
	$(CC) $(CFLAGS) $(INCLUDES) -c $< 

.PHONY: clean

all: start.o enmmu.o

clean:
	rm -rf *~ *.o

include ../include.mk

