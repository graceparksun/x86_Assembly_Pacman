; Stanley Chen and Grace Park 
; CS 66 Term Project

; Pacman


INCLUDE Irvine32.inc

.data
	filename1 BYTE "Map1.txt",0
	filename2 BYTE "Map2.txt",0
	BUFFER_SIZE = 5000
	buffer BYTE BUFFER_SIZE DUP(?)
	bytesRead DWORD ?

	Pacman BYTE "<PACMAN>", 0
	menu BYTE "1. Start new game (S)", 0,
			"2. Print Map (P)     ", 0, 
			"3. End Game (E)      ", 0,
			"4. Move Up (U)       ", 0,
			"5. Move Down (J)     ", 0, 
			"6. Move Left (H)     ", 0,
			"7. Move Right (K)    ", 0,

	posPacman BYTE "Position of the Pacman (@) is: (", 0
	posGhost BYTE "Position of the Ghost ($) is: ", 0
	getInput BYTE "INPUT: ", 0
	error BYTE "Wrong move. Please try again.", 0
	finish BYTE "You have consumed all the Ghost. Good Job.", 0
	choosemap BYTE "Input 1 for the same map and 2 for a new map.", 0

	userInput BYTE ?
	row DWORD 1
	col DWORD 0
	ghost DWORD 0
	pos SDWORD 0
	found DWORD 0
	fileinfo DWORD 0


.code
main PROC

	mov al, 1
	call LOADMAP

	GAME:
		call PRINTMAP
		call POSITION
		call GAMEMENU
		GO::
		call INPUT

		.IF al == 's' ; start new game
			mov edx, OFFSET choosemap
			call WriteString
			call Crlf

			call INPUT
			call LOADMAP
			jmp GAME
		.ELSEIF al == 'p' ; print map
			jmp GAME
		.ELSEIF al == 'e' ; end game
			exit
			jmp GAME
		.ENDIF

		.IF al == 'u' ; move up
			mov pos, -14d
		.ELSEIF al == 'j' ; move down
			mov pos, 14d
		.ELSEIF al == 'h' ; move left
			mov pos, -1d
		.ELSEIF al == 'k' ; move right
			mov pos, 1d
		.ELSE
			mov edx, OFFSET error
			call WriteString
			mov eax, 1000
			call Delay
			jmp GAME
		.ENDIF
		call MOVEPACMAN

		call Clrscr
		jmp GAME


	exit
main ENDP


;----------------------------
GAMEMENU proc

; game menu for Pacman which should contain certain options
;----------------------------
	
	mov edx, OFFSET menu
	mov ecx, 7
	L1:
		call WriteString
		call crlf
		cmp ecx, 1
		je L2
		add edx, 22
		loop L1

		L2:
		call crlf
	ret

GAMEMENU ENDP

;----------------------------
LOADMAP proc

;load the game map text file into memory
;----------------------------
	
	.IF al == '1'
		mov edx, OFFSET filename1
	.ELSE
		mov edx, OFFSET filename2
	.ENDIF
	call OpenInputFile
	mov fileinfo, eax
	mov edx,OFFSET buffer 
	mov ecx,BUFFER_SIZE 
	call ReadFromFile
	mov bytesRead, eax
	mov eax, fileinfo
	call CloseFile
	ret

LOADMAP ENDP


;----------------------------
PRINTMAP proc

;print the game map on the system consol
;----------------------------

	mov edx, OFFSET Pacman
	call WriteString
	call crlf
	mov edx, OFFSET buffer
	call WriteString
	call crlf
	call crlf

	ret

PRINTMAP ENDP


;----------------------------
POSITION proc

; list out the position (address) of @ and positions of $ based on the map.
;----------------------------
	
	mov col, 0
	mov row, 1

	mov esi, OFFSET buffer
	mov ecx, bytesRead

	findPacman:
		inc col
		mov al, [esi]
		cmp al, '@'
		je FOUND1

		cmp col, 14d
		jne CONTINUE
		inc row
		mov col, 0

		CONTINUE:
		add esi, 1

		loop findPacman

	FOUND1:
		mov edx, OFFSET posPacman
		call WriteString

		mov eax, row
		call WriteDec
		mov al, ','
		call WriteChar
		mov eax, col
		call WriteDec
		mov al, ')'
		call WriteChar
		call crlf
		
	mov col, 0
	mov row, 1
	mov found, 0

	mov esi, OFFSET buffer
	mov ecx, bytesRead

	mov edx, OFFSET posGhost
	call WriteString

	findGhost:
		inc col
		mov al, [esi]
		cmp al, '$'
		jne NOTFOUND
		
		inc found
		mov al, '('
		call WriteChar
		mov eax, row
		call WriteDec
		mov al, ','
		call WriteChar
		mov eax, col
		call WriteDec
		mov al, ')'
		call WriteChar

		NOTFOUND:
			cmp col, 14d
			jne CONTINUE2
			inc row
			mov col, 0

		CONTINUE2:
			add esi, 1
		
		loop findGhost
	
	mov ebx, found
	.IF ebx == 0
		mov edx, OFFSET finish
		call WriteString
		call crlf
		call OVER
	.ENDIF
		call crlf
		call crlf
	ret

POSITION ENDP


;----------------------------
INPUT proc

; game menu for Pacman which should contain certain options
;----------------------------

	
	mov edx, OFFSET getInput
	call WriteString
	
	LookForKey:
		mov  eax,50          ; sleep, to allow OS to time slice
		call Delay           ; (otherwise, some key presses are lost)

		call ReadKey         ; look for keyboard input
		jz   LookForKey      ; no key pressed yet
		
		call WriteChar	
		call crlf
		
		ret

INPUT ENDP


;----------------------------
MOVEPACMAN proc

; move pacman UP, DOWN, LEFT, RIGHT
;----------------------------

	mov esi, OFFSET buffer
	mov ecx, bytesRead
	findPacman:
		mov al, [esi]
		cmp al, '@'
		je FOUNDPACMAN
		add esi, 1
		loop findPacman

	FOUNDPACMAN:
		mov edi, esi
		add  edi, pos
		mov al, [edi]
		.IF al == '*'
			mov edx, OFFSET error
			call WriteString
			call crlf
			mov  eax,1000 
			call Delay 
		.ELSE 
			mov bl, '@'
			mov [edi], bl
			call CHECKGHOST
		.ENDIF
			
	ret

MOVEPACMAN ENDP


;----------------------------
CHECKGHOST proc

;  ghost converts into '#' once touched by pacman
;----------------------------
	
	.IF ghost == 1
		mov bl, '#'
		mov [esi], bl
		mov ghost, 0
	.ELSE
		mov bl, ' '
		mov [esi], bl
	.ENDIF
	
	.IF al == '$' || al == '#'
		mov ghost, 1
	.ELSE
		mov ghost, 0
	.ENDIF

	ret
CHECKGHOST ENDP


;----------------------------
OVER proc

; Once user has consumed all the ghost symbol, the game session considered over 
; and the only option that user can do on the menu should be {S, P, E} 
;----------------------------
	
	mov edx, OFFSET menu
	mov ecx, 3
	L1:
		call WriteString
		call crlf
		cmp ecx, 1
		je L2
		add edx, 22
		loop L1

		L2:
		call crlf
		call GO
	ret
	
OVER ENDP

end main 