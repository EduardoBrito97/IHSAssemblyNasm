org 0x7c00 
jmp 0x0000:start

start:
	xor ax, ax
	mov ds, ax

	reset:
	mov ah, 0
	mov dl, 0
	int 13h 
	jc reset

	mov ax, 0x7E0
	mov es, ax

	Retry:
	mov ah, 0x02
	mov al, 3
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, 0
	int 13h
	jc Retry

	jmp 0x7E0:0x0
	
times 510-($-$$) db 0
dw 0xaa55