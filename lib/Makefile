INCLUDES := -I../include/
%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

%.o: %.S
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

.PHONY: clean

all: tool.o asm_tool.o entry.o env_asm.o env.o load.o \
     print.o printf.o sched.o sync.o syscall_all.o timer.o
	

clean:
	rm -rf *~ *.o


include ../include.mk