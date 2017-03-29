org 0x500
jmp 0x0000:start

constantes:
	;Menu
	cor_Letras equ 7
	cor_limite equ 7
	linha_limite equ 120
	coluna_Mensagem equ 17
	
	;Tamanhos de constantes
	tam_nome equ 30
	tam_grupo equ 1
	tam_email equ 30
	tam_tel equ 11
	tam_grupoLista equ 15
	tam_contato equ 72
	tam_horizontal_limite equ 1280 ;Obs: uma linha é 640, botando 1280 ele fica uma linha mais grossa

	linhas_uma_pag equ 60

dados:
	;Mensagens
    instructionOne: db "Pressione 1 para cadastrar contato;", 0
    instructionTwo: db "Pressione 2 para buscar contato;", 0
    instructionThree: db "Pressione 3 para editar contato;", 0
    instructionFour: db "Pressione 4 para deletar contato;", 0
    instructionFive: db "Pressione 5 para listar grupos;", 0
    instructionSix: db "Pressione 6 para listar contatos de um grupo;", 0
    instructionSeven: db "Pressione 7 para limpar a tela.", 0
    mensagem_erro: db "Comando invalido ou contato nao encontrado.", 0
    nome: db "Nome:", 0
    grupo: db "Grupo:", 0
    email: db "Email:", 0
    telefone: db "Telefone:", 0

    ;Variáveis de controle de cursor
    linha_Ultima_msg db 0
    pag_Ultima_msg db 0
    caracter_lido db 0

    ;Variáveis de controle de endereço
    reservaContato times 200 db 0
	reservaGrupo times 200 db 0

    ptr_agenda dw reservaContato
    ptr_ultimo_contato dw reservaContato
    ptr_contato_atual dw reservaContato

    ptr_grupo dw reservaGrupo
	ptr_ultimo_grupo dw reservaGrupo
	ptr_grupo_atual dw reservaGrupo

	;Contadores
    num_contatos db 0
    MAX_contatos db 0
    MAX_contatos_aux db 0

    num_grupos db 0
    MAX_grupos db 0
   	stringNomeSearch times 30 db 0 
   	tam_String_Search db 0
   	tam_String_Search_aux db 0

    ;Testes
    testeAdd: db "Add", 0
    testeSearch: db "Search", 0
    testeDel: db "Del", 0
    testeEdit: db "Edit", 0
    testeList: db "List", 0
    testeListGroup: db "List Group", 0


printarMensagem:
	;Printa a string que tá em SI
	xor cl, cl
	loopPrint:
		lodsb
		cmp cl, al
		je endLoop
		mov ah, 0xe
		mov bh, 0
		mov bl, cor_Letras
		int 10h
		jmp loopPrint

	endLoop:
ret

readString:
	;Lê e printa os caracteres lidos e guarda no endereço DI
	xor cl, cl
	mov [tam_String_Search], cl
	loopRead:
		mov ah, 0
		int 16h
		mov ah, 0xe
		mov bh, 0
		mov bl, cor_Letras
		int 10h
		
		cmp al, 0dh ;É \n?
		je fimLoopRead
		
		stosb

		mov cl, [tam_String_Search]
		inc cl
		mov [tam_String_Search], cl

		cmp al, 08h ;É backspace?
		je backSpace
		jmp loopRead
		
		backSpace:
			;Pra printar o backSpace, vc precisa printar um backSpace pra voltar (já printado na chamada)
			;Printar um space pra apagar a letra
			;Printar outro backSpace pra voltar
			mov cl, [tam_String_Search]
			dec cl
			mov [tam_String_Search], cl
		    mov al, 0x20 ; ASCII for Space
    		mov ah, 0xe
			mov bh, 0
			mov bl, cor_Letras
			int 10h
		    mov al, 0x08 ; ASCII for Backspace
			mov ah, 0xe
			mov bh, 0
			mov bl, cor_Letras
			int 10h
	jmp loopRead 
	fimLoopRead:
	xor cl, cl 
	mov [di], cl ;Colocando um \0 no fim da string
ret

checkPage:
	;Checando se precisa avançar uma página
	mov dx, [linha_Ultima_msg]
	xor ax, ax
	add ax, linhas_uma_pag
	div ax
	xor cx, cx
	cmp cx, dx
	je incPage
ret

incPage:
	;Indo para a próxima página
	mov ax, [pag_Ultima_msg]
	inc ax
	mov [pag_Ultima_msg], ax

	;Iniciando na linha 0 da próxima página
	xor dx,dx
	mov [linha_Ultima_msg], dx

	;Limpando a tela
	xor ax, ax
	mov ds, ax
	mov ah, 0
	mov al, 12h
	int 10h

	mov ah, 0xb 
	mov bh, 0
	mov bl, 0h
	int 10h

	mov ah, 2
	mov bh, 0
	mov dh, [linha_Ultima_msg]
	mov dl, 0
	int 10h	
ret

setCursor:
	;Seta o cursor pra próxima linha
	mov ah, 2
	mov bh, [pag_Ultima_msg]
	mov dh, [linha_Ultima_msg]
	mov dl, 0
	int 10h
	mov dh, [linha_Ultima_msg]
	inc dh
	mov [linha_Ultima_msg], dh
ret

setCursorMenu:
	;Mesma coisa que o setCursor, só que pro menu (coluna 17, no meio)
	mov ah, 2
	mov bh, 0
	mov dh, [linha_Ultima_msg]
	mov dl, 17
	int 10h
	mov dh, [linha_Ultima_msg]
	inc dh
	mov [linha_Ultima_msg], dh
ret

start:
xor ax, ax
mov [linha_Ultima_msg], ax
mov ds, ax

mov si, reservaContato
mov [ptr_ultimo_contato], si
mov [ptr_agenda], si
mov [ptr_contato_atual], si

mov ah, 0
mov al, 12h ; escolhendo o modo de vídeo (VGA)
int 10h

mov ah, 0xb 
mov bh, 0
mov bl, 0h ; selecionando a cor da tela (preta)
int 10h

menu:
;Primeira Instrução
call setCursorMenu
mov si, instructionOne
call printarMensagem

;Segunda Instrução
call setCursorMenu
mov si, instructionTwo
call printarMensagem

;Terceira instrução
call setCursorMenu
mov si, instructionThree
call printarMensagem

;Quarta Instrução
call setCursorMenu
mov si, instructionFour
call printarMensagem

;Quinta Instrução
call setCursorMenu
mov si, instructionFive
call printarMensagem

;Sexta Instrução
call setCursorMenu
mov si, instructionSix
call printarMensagem

;Sétima Instrução
call setCursorMenu
mov si, instructionSeven
call printarMensagem

;Printando limite---------------------------------------------------
printarlimite:

mov cx, 0
mov dx, 0
mov di, linha_limite ;Posição da linha do limite
mov si, tam_horizontal_limite 

printarlimite1:

mov ah, 0Ch
mov al, cor_limite ;COR DO LIMITE
int 10h

mov dx, linha_limite
jmp printarlimite2

printarlimite2:
mov ah, 0Ch
mov al, cor_limite ;COR DO LIMITE
int 10h

inc cx
cmp cx, si
je fimMenu
jmp printarlimite2
;Printando limite---------------------------------------------------

fimMenu:
mov dh, 7 ;numero da linha
inc dh
mov [linha_Ultima_msg], dh

comand:
mov ah, 0
mov bx, 0
int 16h
mov [caracter_lido], al ;Salvando o caracter lido pra ver se precisa ir pra próxima página

;setando o cursor do menu pra printar o caracter digitado
call setCursor

;Voltando para analisar o caracter lido anteriormente
mov al, [caracter_lido]

;Imprimindo o caracter digitado
mov ah, 0xe
mov bh, 0
mov bl, cor_Letras
int 10h

cmp al, '1'
je addCom

cmp al, '2'
je searchCom

cmp al, '3'
je editCom

cmp al, '4'
je delCom

cmp al, '5'
je listCom

cmp al, '6'
je listGroup

cmp al, '7'
je clearCom

cmp al, '8'
je COMANDOOCULTOSALVAVIDA

jmp errorMessage

addCom:
	call checkPage
	call setCursor
	mov si, nome
	call printarMensagem

	mov ax, 0
	mov es, ax
	mov di, [ptr_ultimo_contato]
	call readString

	call checkPage
	call setCursor
	mov si, grupo
	call printarMensagem
	
	mov ax, 0
	mov es, ax
	mov di, [ptr_ultimo_contato]
	add di, 30
	call readString

	call checkPage
	call setCursor
	mov si, email
	call printarMensagem
	
	mov ax, 0
	mov es, ax
	mov di, [ptr_ultimo_contato]
	add di, 45
	call readString

	call checkPage
	call setCursor
	mov si, telefone
	call printarMensagem
	
	mov ax, 0
	mov es, ax
	mov di, [ptr_ultimo_contato]
	add di, 75
	call readString

	mov di, [ptr_ultimo_contato]
	add di, 86
	mov [ptr_ultimo_contato], di
	call checkPage

	mov ax, [MAX_contatos]
	inc ax
	mov [MAX_contatos], ax

jmp comand

searchCom:
	call checkPage
	call setCursor
	mov si, nome
	call printarMensagem

	xor cl, cl
	mov [tam_String_Search], cl

	mov ax, 0
	mov es, ax
	mov di, stringNomeSearch
	call readString

	mov si, reservaContato
	sub si, 86
	mov [ptr_contato_atual], si

	mov cl, [MAX_contatos]
	mov [MAX_contatos_aux], cl

	compararStringMaior:
		mov si, [ptr_contato_atual]
		add si, 86
		mov [ptr_contato_atual], si

		mov cl, [MAX_contatos]
		cmp cl, 0h
		je erro

		mov cl, [MAX_contatos]
		dec cl
		mov [MAX_contatos], cl

		mov cx, [tam_String_Search]
		mov [tam_String_Search_aux], cl

		mov di, [ptr_contato_atual]
		mov si, stringNomeSearch
		xor ax, ax
		mov es, ax
		mov ds, ax
		compararStrings:
			mov cl, [tam_String_Search_aux]
			cmp cl, 0h
			jl sucesso

			mov cl, [tam_String_Search_aux]
			dec cl
			mov [tam_String_Search_aux], cl 

			cmpsb
			jne compararStringMaior
		je compararStrings
	
	sucesso:
	call setCursor
	call checkPage
	mov si, testeList
	call printarMensagem

	mov cl, [MAX_contatos_aux]
	mov [MAX_contatos], cl
jmp comand
	
	erro:
	call setCursor
	call checkPage
	mov si, mensagem_erro
	call printarMensagem

	mov cl, [MAX_contatos_aux]
	mov [MAX_contatos], cl
jmp comand

editCom:
	call checkPage
	call setCursor
	mov si, testeEdit
	call printarMensagem

jmp comand

delCom:
	call checkPage
	call setCursor
	mov si, testeDel
	call printarMensagem

jmp comand

listCom:
	call setCursor
	mov si, testeList
	call printarMensagem
jmp comand

listGroup:
	call checkPage
	call setCursor
	mov si, testeListGroup
	call printarMensagem

jmp comand

clearCom:
	xor dh, dh
	mov [linha_Ultima_msg], dh
	mov [pag_Ultima_msg], dh
jmp start

errorMessage:
	call checkPage
	call setCursor
	mov si, mensagem_erro
	call printarMensagem

jmp comand

COMANDOOCULTOSALVAVIDA:
	mov cl, [MAX_contatos]
	mov [MAX_contatos_aux], cl
	mov si, reservaContato
	mov [ptr_contato_atual], si
	PRINTATUTO:

		call checkPage
		call setCursor
		mov si, [ptr_contato_atual]
		call printarMensagem

		call checkPage
		call setCursor
		mov si, [ptr_contato_atual]
		add si, 30
		call printarMensagem

		call checkPage
		call setCursor
		mov si, [ptr_contato_atual]
		add si, 45
		call printarMensagem

		call checkPage
		call setCursor
		mov si, [ptr_contato_atual]
		add si, 75
		call printarMensagem

		mov si, [ptr_contato_atual]
		add si, 86
		mov [ptr_contato_atual], si

		xor al, al
		mov cl, [MAX_contatos]
		dec cl
		mov [MAX_contatos], cl
		cmp cl, al
	jne PRINTATUTO

	mov cl, [MAX_contatos_aux]
	mov [MAX_contatos], cl
jmp comand

fim:
jmp $