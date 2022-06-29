INCLUDES = -I../include/ -I../user/

user_dir := ../user
tools_dir := .
fsformat  := ./fsformat

USERLIB := entrance.o fork.o ipc.o libos.o msyscall.o print.o printf.o string.o syscall_lib.o
USERLIB :=	$(user_dir)/entrance.o \
		$(user_dir)/fork.o \
		$(user_dir)/ipc.o \
		$(user_dir)/libos.o \
		$(user_dir)/msyscall.o \
		$(user_dir)/print.o \
		$(user_dir)/printf.o \
		$(user_dir)/string.o \
		$(user_dir)/syscall_lib.o \
		$(user_dir)/pageref.o \
		$(user_dir)/pageref.o \
		$(user_dir)/fd.o \
		$(user_dir)/file.o \
		$(user_dir)/fsipc.o \
		$(user_dir)/fprintf.o

FSLIB :=	fs.o \
		ide.o \
		test.o

USERAPPS :=  $(user_dir)/num.b  \
			 $(user_dir)/echo.b \
			 $(user_dir)/ls.b \
			 $(user_dir)/sh.b  \
			 $(user_dir)/cat.b \
		 $(user_dir)/testptelibrary.b


FSIMGFILES := motd newmotd #$(user_dir)/testarg.b $(user_dir)/init.b $(USERAPPS)

CFLAGS += -nostdlib -static

all: fs.img serv.b serv.x

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
	echo user1 cc $<
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

%.o: %.S
	echo as $<
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
