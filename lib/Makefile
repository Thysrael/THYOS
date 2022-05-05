INCLUDES := -I../include/
%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

%.o: %.S
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

.PHONY: clean

all: print.o printf.o tool.o get_EL.o env.o

clean:
	rm -rf *~ *.o


include ../include.mk