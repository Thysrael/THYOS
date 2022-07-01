INCLUDES = -I../include/ -I../user/

user_dir 	:= ../user
tools_dir 	:= .
app_dir 	:= ../app
fsformat  	:= ./fsformat

USERLIB :=	$(user_dir)/entrance.o 	\
		$(user_dir)/fork.o 			\
		$(user_dir)/ipc.o 			\
		$(user_dir)/libos.o 		\
		$(user_dir)/msyscall.o 		\
		$(user_dir)/print.o 		\
		$(user_dir)/printf.o 		\
		$(user_dir)/string.o 		\
		$(user_dir)/syscall_lib.o 	\
		$(user_dir)/fd.o 			\
		$(user_dir)/file.o 			\
		$(user_dir)/fsipc.o 		\
		$(user_dir)/fprintf.o		\
		$(user_dir)/pipe.o 			\
		$(user_dir)/spawn.o 		\
		$(user_dir)/console.o

FSLIB := fs.o ide.o test.o

USERAPPS := $(app_dir)/sh.b  			\
			$(app_dir)/ls.b 			\
			$(app_dir)/echo.b			\
			$(app_dir)/cat.b 			\
			$(app_dir)/args.b 			\
			$(app_dir)/tsh.b			\
			$(app_dir)/bpmv.b


FSIMGFILES := name pic.bpm $(user_dir)/init.b $(USERAPPS)

CFLAGS += -nostdlib -static

all: fs.img serv.x

%.x: %.b.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.b.c: %.b
	chmod +x ./bintoc
	./bintoc $* $< > $@~ && mv -f $@~ $@

%.b: %.o $(USERLIB) $(FSLIB)
	$(LD) -o $@ $(LDFLAGS) -G 0 -static -n -nostdlib -T $(user_dir)/user.lds $^

%.elf: %.o $(USERLIB) $(FSLIB)
	$(LD) -o $@ $(LDFLAGS) -T $(user_dir)/user.lds $^

%.asm: %.elf
	$(CROSS_COMPILE)objdump -alD $^ > $@

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

%.o: %.S
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

%.o: $(user_dir)/lib.h

fs.img: $(FSIMGFILES)
	dd if=/dev/zero of=../fs.img bs=4096 count=1024 2>/dev/null
	gcc $(INCLUDES) fsformat.c -o $(tools_dir)/fsformat -m32
	chmod +x $(tools_dir)/fsformat
	$(tools_dir)/fsformat ../fs.img $(FSIMGFILES)

.PHONY: clean

clean:
	rm -rf *~ *.o *.b.c *.b *.x $(fsformat)

include ../include.mk
