; Multimodule

INCLUDE Irvine32.inc

.code
;----------------------------
GAMEMENU proc

; game menu for Pacman which should contain certain options
;----------------------------
	
	menuoffset EQU [ebp+8]
	
	enter 0,0
	pushad
	
	mov edx, menuoffset
	mov ecx, 8
	L1:
		call WriteString
		call crlf
		cmp ecx, 1
		je L2
		add edx, 22
		loop L1

		L2:
		call crlf
	popad
	leave
	ret 4

GAMEMENU ENDP
END

 