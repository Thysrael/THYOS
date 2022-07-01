INCLUDES = -I../include/ -I../user/

user_dir 	:= ../user

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

%.b: %.o $(USERLIB)
	$(LD) -o $@ $(LDFLAGS) -G 0 -static -n -nostdlib -T $(user_dir)/user.lds $^

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

.PHONY: clean

all: echo.b cat.b

clean:
	rm -rf *~ *.o *.b

include ../include.mk 