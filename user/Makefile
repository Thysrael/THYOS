INCLUDES = -I../include/

USERLIB := entrance.o fork.o ipc.o libos.o msyscall.o print.o printf.o string.o syscall_lib.o

CFLAGS += -nostdlib -static

all: test_sys.x test_sys.b test_fork.x test_fork.b test_ipc.x test_ipc.b $(USERLIB)

%.x: %.b.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.b.c: %.b
	chmod +x ./bintoc
	./bintoc $* $< > $@~ && mv -f $@~ $@

%.b: %.o $(USERLIB)
	$(LD) -o $@ $(LDFLAGS) -G 0 -static -n -nostdlib -T ./user.lds $^

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

%.o: %.S
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

%.o: lib.h

.PHONY: clean

clean:
	rm -rf *~ *.o *.b.c *.x *.b

include ../include.mk
