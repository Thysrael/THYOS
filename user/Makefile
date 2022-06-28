INCLUDES = -I../include/

USERLIB := entrance.o fork.o ipc.o libos.o msyscall.o print.o printf.o string.o syscall_lib.o

CFLAGS += -nostdlib -static

all: test_sys.x test_fork.x test_ipc.x $(USERLIB)

%.x: %.b.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.b.c: %.b
	chmod +x ./bintoc
	./bintoc $* $< > $@~ && mv -f $@~ $@

%.b: %.o $(USERLIB)
	$(LD) -o $@ $(LDFLAGS) -G 0 -static -n -nostdlib -T ./user.lds $^
	$(CROSS_COMPILE)objdump -alD $@ > ./$@.symbol

%.elf: %.o $(USERLIB)
	$(LD) -o $@ $(LDFLAGS) -T ./user.lds $^

%.asm: %.elf
	$(CROSS_COMPILE)objdump -alD $^ > $@

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

%.o: %.S
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

%.o: lib.h

.PHONY: clean

clean:
	rm -rf *~ *.o *.b.c *.x *.b *.symbol

include ../include.mk
