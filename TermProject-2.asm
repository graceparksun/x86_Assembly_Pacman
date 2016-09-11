; Stanley Chen and Grace Park 
; CS 66 Term Project

; Pacman


INCLUDE Irvine32.inc

EXTERN GAMEMENU@0:PROC

GAMEMENU EQU GAMEMENU@0

ms_delay = 200; time delay set at ... seconds

.data
	filename1 BYTE "Map1.txt",0
	filename2 BYTE "Map2.txt",0
	BUFFER_SIZE = 5000
	buffer BYTE BUFFER_SIZE DUP(?)
	bytesRead DWORD ?
	
	menu BYTE "1. Start new game (S)", 0,
			"2. Print Map (P)     ", 0, 
			"3. End Game (E)      ", 0,
			"4. Move Up (U)       ", 0,
			"5. Move Down (J)     ", 0, 
			"6. Move Left (H)     ", 0,
			"7. Move Right (K)    ", 0,
			"8. DEMO MODE (D)     ", 0

	Pacman BYTE "  <PACMAN>  ", 0
	DEMO BYTE "...DEMO MODE..."

	moveUP BYTE "MOVING UP! ",0
	moveDOWN BYTE "MOVING DOWN! ",0
	moveLEFT BYTE "MOVING LEFT! ",0
	moveRIGHT BYTE "MOVING RIGHT! ",0
	blocked BYTE "BLOCKED! ",0
	beenHere BYTE "BEEN HERE! ",0
	eatGhost BYTE "FOUND A GHOST! " ,0
	retreat BYTE "DEADEND! RETREAT! " ,0
	point BYTE "SCORE: ",0

	posPacman BYTE "Position of the Pacman (@) is: (", 0
	posGhost BYTE "Position of the Ghost ($) is: ", 0
	getInput BYTE "INPUT: ", 0
	error BYTE "Wrong move. Please try again.", 0
	finish BYTE "No ghosts left.", 0
	choosemap BYTE "Input 1 for MAP1 and 2 for MAP2.", 0

	demoScore DWORD 0

	userInput BYTE ?
	row DWORD 1
	col DWORD 0
	ghost DWORD 0
	pos SDWORD 0
	found DWORD 0
	fileinfo DWORD 0
	cont DWORD 0


.code
main PROC

	mov al, '1'
	call LOADMAP

	GAME:
		call PRINTMAP
		call POSITION

		push OFFSET menu
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
		.ELSEIF al == 'd' ; demo mode
			mov esi, OFFSET buffer	; Load the map
			mov ecx, bytesRead		; Store map's length
			findGhost1:
				mov al, [esi]
				cmp al, '$'
				je FOUNDGHOST
				add esi, 1
				loop findGhost1
			cmp ecx, 0
			je OVER

			FOUNDGHOST:
				mov esi, OFFSET buffer		; Load the map
				mov ecx, bytesRead			; Store map's length
				mov ebx, 0					
			findPacman1:				
				mov al, [esi]			
				cmp al, '@'
				je FOUND3
				add esi, 1
				inc ecx
				loop findPacman1
			FOUND3:
				mov edi, esi			; Point edi to position of pacman 
				push edi				; Pass edi to function
				push esi				; Pass esi to function
				call clrscr		; Clear the screen for next output
				call PRINTMAP	; Print the current map layout
				call DEMOMODE

				call clrscr		; Clear the screen for next output
				mov edx, OFFSET point;
				call WriteString
				mov eax, demoScore
				call WriteDec
				call crlf

				jmp GAME
		.ELSEIF al == 'e' ; end game
			exit
			jmp GAME
		.ELSEIF al == 'u' ; move up
			mov pos, -14d
			call MOVEPACMAN
			call Clrscr
			jmp GAME
		.ELSEIF al == 'j' ; move down
			mov pos, 14d
			call MOVEPACMAN
			call Clrscr
			jmp GAME
		.ELSEIF al == 'h' ; move left
			mov pos, -1d
			call MOVEPACMAN
			call Clrscr
			jmp GAME
		.ELSEIF al == 'k' ; move right
			mov pos, 1d
			call MOVEPACMAN
			call Clrscr
			jmp GAME
		.ELSE
			mov edx, OFFSET error
			call WriteString
			mov eax, 1000
			call Delay
			jmp GAME
		.ENDIF
	exit
main ENDP


;----------------------------
LOADMAP proc

;load the game map text file into memory
;----------------------------
	
	mov demoscore, 0
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


;----------------------------
DEMOMODE proc

; detect initial position of Pacman and start navigating available path to consume all the $ points
; mark the path of Pacman with ! to visualize the visited path.
; $ should be replaced with #, which should be avoided or game points will be deducted.
; Try to avoid the same path except backing up from the dead end.
;----------------------------
	push ebp
	mov ebp, esp
	
	mov edi, [ebp+12]		; b4 pos
	mov esi, [ebp+8]		; to pos
	mov al, BYTE PTR [esi]	; move element at location to move pacman to into al register

	.IF al == '*'
		mov edx, OFFSET blocked
		call WriteString	
		mov eax, ms_delay
		call Delay	
		jmp ReFalse
	.ELSEIF al == '#' || al == '!'
		mov edx, OFFSET beenHere
		call WriteString	
		mov eax, ms_delay
		call Delay	
		jmp ReFalse ; try to avoid
	.ELSEIF al == '$' 
		add demoScore, 1
		mov edx, OFFSET eatGhost
		call WriteString
		mov eax, ms_delay
		call Delay

		mov bl, '!'
		mov BYTE PTR [edi], bl
		mov bl, '@'
		mov BYTE PTR [esi], bl

		call clrscr		; Clear the screen for next output
		call PRINTMAP	; Print the current map layout
		mov edx, OFFSET point;
		call WriteString
		mov eax, demoScore
		call WriteDec
		call crlf

		mov bl, '@'
		mov BYTE PTR [edi], bl
		mov bl, '#'
		mov BYTE PTR [esi], bl

		mov esi, OFFSET buffer	; Load the map
		mov ecx, bytesRead		; Store map's length
		findGhost1:
			mov al, [esi]
			cmp al, '$'
			je FOUNDGHOST
			add esi, 1
			loop findGhost1
		cmp ecx, 0
		je ReTrue

		FOUNDGHOST:
			mov esi, [ebp+8]
			push edi
			push esi
			call DEMOMODE
			cmp cont, 1
			je ReTrue

		
	.ELSE
		mov bl, '!'
		mov BYTE PTR [edi], bl ; change previous pos to '!'
		mov bl, '@'
		mov BYTE PTR [esi], bl ; change current pos to '@'
		mov edi, esi			; successful move, change b4 pos

		call clrscr		; Clear the screen for next output
		call PRINTMAP	; Print the current map layout
		mov edx, OFFSET point;
		call WriteString
		mov eax, demoScore
		call WriteDec
		call crlf

		mov edx, OFFSET moveUP
		call WriteString
		mov eax, ms_delay
		call Delay
		mov esi, [ebp+8]			; go up
			push edi				; push b4 pos
			add esi, -14d
			push esi				; push pos to move to
			call DEMOMODE			; with current pos and pos to move to as args
			cmp cont, 1
			je ReTrue

		call clrscr		; Clear the screen for next output
		call PRINTMAP	; Print the current map layout
		mov edx, OFFSET point;
		call WriteString
		mov eax, demoScore
		call WriteDec
		call crlf

		mov edx, OFFSET moveLEFT
		call WriteString
		mov eax, ms_delay
		call Delay
		mov esi, [ebp+8]; go left
			push edi
			add esi, -1d
			push esi
			call DEMOMODE
			cmp cont, 1
			je ReTrue

		call clrscr		; Clear the screen for next output
		call PRINTMAP	; Print the current map layout
		mov edx, OFFSET point;
		call WriteString
		mov eax, demoScore
		call WriteDec
		call crlf

		mov edx, OFFSET moveDOWN
		call WriteString
		mov eax, ms_delay
		call Delay
		mov esi, [ebp+8]			; go down
			push edi
			add esi, 14d
			push esi
			call DEMOMODE
			cmp cont, 1
			je ReTrue

		call clrscr		; Clear the screen for next output
		call PRINTMAP	; Print the current map layout
		mov edx, OFFSET point;
		call WriteString
		mov eax, demoScore
		call WriteDec
		call crlf

		mov edx, OFFSET moveRIGHT
		call WriteString
		mov eax, ms_delay
		call Delay
		mov esi, [ebp+8]; go right
			push edi
			add esi, 1d
			push esi
			call DEMOMODE
			cmp cont, 1
			je ReTrue

		mov edx, OFFSET retreat
		call WriteString
		mov eax, ms_delay
		call Delay

		call clrscr		; Clear the screen for next output
		call PRINTMAP	; Print the current map layout
		mov edx, OFFSET point;
		call WriteString
		mov eax, demoScore
		call WriteDec
		call crlf

		mov bl, '!'
		mov BYTE PTR [edi], bl ; change previous pos to '!'
		mov bl, '@'
		mov edi, [ebp+12]
		mov BYTE PTR [edi], bl ; change previous pos to '!'

		call clrscr		; Clear the screen for next output
		call PRINTMAP	; Print the current map layout
		mov edx, OFFSET point;
		call WriteString
		mov eax, demoScore
		call WriteDec
		call crlf

		jmp ReFalse
	.ENDIF

	ReFalse:
		mov cont, 0
		pop ebp
		ret 8
	ReTrue:
		mov cont, 1
		pop ebp
		ret 8
DEMOMODE ENDP

end main  