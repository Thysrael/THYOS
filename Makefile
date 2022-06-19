drivers_dir   := drivers
boot_dir      := boot
init_dir      := init
lib_dir       := lib
mmu_dir       := mmu
user_dir	  := user

vmlinux_elf   := kernel.elf
vmlinux_img   := kernel.img

link_script   := kernel.lds

# calling them directory other than modules maybe more easy to understand
modules       := drivers boot init lib mmu user

objects       := $(drivers_dir)/*.o 	\
				 $(boot_dir)/*.o 		\
                 $(init_dir)/*.o 		\
                 $(lib_dir)/*.o 		\
				 $(mmu_dir)/*.o			\
				 $(user_dir)/*.x

.PHONY: all $(modules) clean debug run

all: $(modules) vmlinux

vmlinux: $(modules)
	$(LD) -o $(vmlinux_elf) -T $(link_script) $(objects)
	$(OC) $(vmlinux_elf) -O binary $(vmlinux_img)

# $(MAKE) is the path of the 'make' program, 
# it equals to run the 'make' command on the shell
# $@ is the name of the target, so it's also the name of dictionary
$(modules):
	$(MAKE) --directory=$@

# '$$module' we use two '$', maybe because the 'module' is the variable of shell, 
# not the variable of Makefile, so we need to use one '$' to transfer the other '$' 
clean:
	for module in $(modules);						\
		do 											\
			$(MAKE) --directory=$$module clean;		\
		done;										\
	rm -rf *.o *~ $(vmlinux_elf) $(vmlinux_img)

run:
	qemu-system-aarch64 -M raspi3b -serial null -serial stdio -kernel $(vmlinux_img)

debug:
	qemu-system-aarch64 -S -s -M raspi3b -serial null -serial stdio -kernel $(vmlinux_img) 

target:
	aarch64-none-elf-gdb kernel.elf

gdb:
	gdb-multiarch kernel.elf

int:
	qemu-system-aarch64 -M raspi3 -serial null -serial stdio -kernel $(vmlinux_img) -d int 

include include.mk