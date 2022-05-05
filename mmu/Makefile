INCLUDES := -I../include

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

.PHONY: clean

all: mmu.o

clean:
	rm -rf *~ *.o

include ../include.mk