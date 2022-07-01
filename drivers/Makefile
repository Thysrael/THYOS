INCLUDES	  := -I../include/

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< 

.PHONY: clean

all: uart.o emmc.o lfb.o mbox.o

clean:
	rm -rf *~ *.o

include ../include.mk