INCLUDES = -I../include/

USERLIB := 	printf.o 		\
			entrance.o		\
			print.o 		\
			libos.o 		\
			fork.o 			\
			syscall_lib.o 	\
			ipc.o 			\
			string.o 		\
			fd.o 			\
			file.o 			\
			pipe.o 			\
			fsipc.o 		\
			console.o 		\
			msyscall.o 		\
			spawn.o 		\
			fprintf.o


CFLAGS += -nostdlib -static

all: test_sys.x test_fork.x test_ipc.x test_fs.x test_pipe.x test_piperace.x test_fdsharing.x test_console.x test_spawn.x\
	icode.x init.b test_screen.b $(USERLIB)

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