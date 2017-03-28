org 0x7E00
jmp 0x0000:start

dados:

start:

    reset:
	mov ah, 0
	mov dl, 0
	int 13h 
	jc reset

	mov ax, 0x50
	mov es, ax

	Retry:
	mov ah, 0x02
	mov al, 300					; >Como o kernel ainda tá sendo implementado, vou deixar 1 setor só mesmo<
	mov ch, 0
	mov cl, 6					;1 do boot1 + 3 do boot2
	mov dh, 0
	mov dl, 0
	int 13h
	jc Retry

	jmp 0x50:0x0 ;Posição da memória do kernel

.done:
	ret