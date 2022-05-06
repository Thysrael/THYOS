INCLUDES := -I../include

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

.PHONY: clean

all: mmu.o pmap.o tlb.o

clean:
	rm -rf *~ *.o

include ../include.mk