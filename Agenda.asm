org 0x7c00
jmp start

dados:
    instructionOne: db "Pressione 1 para cadastrar contato", 0
    instructionTwo: db "Pressione 2 para buscar contato", 0
    instructionThree: db "Pressione 3 para editar contato", 0
    instructionFour: db "Pressione 4 para deletar contato", 0
    instructionFive: db "Pressione 5 para listar grupos", 0
    instructionSix: db "Pressione 6 para listar contatos de um grupo", 0

start:
xor ax, ax
mov ds, ax ; setando o ds, um registrador de segmento

mov ah, 0
mov al, 12h ; escolhendo o modo de vídeo (VGA)
int 10h

mov ah, 0xb 
mov bh, 0
mov bl, 0h ; selecionando a cor da tela (preta)
int 10h

mov cl, 0
mov si, instructionOne

menu1:

;setando o cursor do  menu
mov ah, 2   ;numero da chamada
mov bh, 0   ;numero da pagina
mov dh, 0 ;numero da linha
mov dl, 35 ;numero da coluna
int 10h

menu11:
lodsb

cmp cl, al
je menu2

mov ah, 0xe
mov bh, 0
mov bl, 2
int 10h
jmp menu11

menu2:

;setando o cursor do  menu
mov ah, 2
mov bh, 0
mov dh, 1
mov dl, 35
int 10h

mov cl, 0
mov si, instructionTwo

menu21:
lodsb

cmp cl, al
je menu3

mov ah, 0xe
mov bh, 0
mov bl, 2
int 10h
jmp menu21

menu3:

;setando o cursor do  menu
mov ah, 2
mov bh, 0
mov dh, 2
mov dl, 35
int 10h

mov cl, 0
mov si, instructionThree

menu31:
lodsb

cmp cl, al
je menu4

mov ah, 0xe
mov bh, 0
mov bl, 2
int 10h
jmp menu31

menu4:

;setando o cursor do  menu
mov ah, 2
mov bh, 0
mov dh, 3
mov dl, 35
int 10h

mov cl, 0
mov si, instructionFour

menu41:
lodsb

cmp cl, al
je menu5

mov ah, 0xe
mov bh, 0
mov bl, 2
int 10h
jmp menu41

menu5:

;setando o cursor do  menu
mov ah, 2
mov bh, 0
mov dh, 4
mov dl, 35
int 10h

mov cl, 0
mov si, instructionFive

menu51:
lodsb

cmp cl, al
je menu6

mov ah, 0xe
mov bh, 0
mov bl, 2
int 10h
jmp menu51

menu6:

;setando o cursor do  menu
mov ah, 2
mov bh, 0
mov dh, 5
mov dl, 35
int 10h

mov cl, 0
mov si, instructionSix

menu61:
lodsb

cmp cl, al
je printarlimite

mov ah, 0xe
mov bh, 0
mov bl, 2
int 10h
jmp menu61

printarlimite:

mov cx, 275
mov dx, 0
mov di, 105
mov si, 640

printarlimite1:

mov ah, 0Ch
mov al, 0x2
int 10h

inc dx
cmp dx, di
je printarlimite2
jmp printarlimite1

printarlimite2:

mov ah, 0Ch
mov al, 0x2
int 10h

inc cx
cmp cx, si
je fim
jmp printarlimite2

mov ah, 0Ch
mov al, bl
int 10h

mov ah, 0
int 16h

fim:
dw 0AA55h