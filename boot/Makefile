INCLUDES	  := -I../include/

%.o: %.S
	$(CC) $(CFLAGS) $(INCLUDES) -c $< 

.PHONY: clean

all: start.o

clean:
	rm -rf *~ *.o

include ../include.mk

