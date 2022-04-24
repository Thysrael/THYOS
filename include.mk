CROSS_COMPILE   := aarch64-none-elf-
CC              := $(CROSS_COMPILE)gcc
CFLAGS          := -Wall -ffreestanding -g
LD              := $(CROSS_COMPILE)ld
# OC is used to transfer the file from one format to another format
# We use it to transfer the kernel from the elf to img
OC				:= $(CROSS_COMPILE)objcopy