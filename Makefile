bootdisk=disk.img
blocksize=512
disksize=100

boot1=boot1

# preencha esses valores para rodar o segundo estágio do bootloader
boot2=boot2
boot2pos=1
boot2size=4

# preencha esses valores para rodar o kernel
kernel=kernel
kernelpos=5
kernelsize=300

ASMFLAGS=-f elf -g
file = $(bootdisk)

# adicionem os targets do kernel e do segundo estágio para usar o make all com eles

all: clean mydisk boot1 bin_boot1 write_boot1 boot2 bin_boot2 write_boot2 kernel bin_kernel write_kernel hexdump launchqemu

mydisk: 
	dd if=/dev/zero of=$(bootdisk) bs=$(blocksize) count=$(disksize) 

boot1: 
	nasm $(boot1).asm $(ASMFLAGS) -o $(boot1).elf 

boot2:
	nasm $(boot2).asm $(ASMFLAGS) -o $(boot2).elf

kernel:
	nasm $(kernel).asm $(ASMFLAGS) -o $(kernel).elf

bin_boot1:
	gobjcopy -O binary $(boot1).elf $(boot1).bin

bin_boot2:
	gobjcopy -O binary $(boot2).elf $(boot2).bin

bin_kernel:
	gobjcopy -O binary $(kernel).elf $(kernel).bin

write_boot1:
	dd if=$(boot1).bin of=$(bootdisk) bs=$(blocksize) count=1 conv=notrunc 

write_boot2:
	dd if=$(boot2).bin of=$(bootdisk) bs=$(blocksize) seek=$(boot2pos) count=$(boot2size) conv=notrunc 

write_kernel:
	dd if=$(kernel).bin of=$(bootdisk) bs=$(blocksize) seek=$(kernelpos) count=$(kernelsize) conv=notrunc

hexdump:
	hexdump $(file)

disasm:
	ndisasm $(boot1).asm

launchqemu:
	qemu-system-i386 -s -S -fda $(bootdisk)
	
clean:
	rm -f *.bin $(bootdisk) *~
