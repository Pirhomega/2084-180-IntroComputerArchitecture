;Corbin Matamoros
;This program will allow the user to control the cursor and print a 
;black box wherever on the screen. They could draw something, technically.

			.model	small
			.stack	100h
			.data
			.code
		
main:		mov		ax,@data
			mov		ds,ax
			
			mov		ax,0600h		;these five clear the screen completely
			mov		bh,7			;
			mov		cx,0			;
			mov		dx,184fh		;
			int		10h				;
			
			mov		ax,0			;these four initialize all registers to zero
			mov		bx,0			;
			mov		cx,0			;
			mov		dx,0			;
			
			mov		ah,2			;these four initialize the cursor position to (1,1)
			mov		dh,1			;
			mov		dl,1			;
			int		10h				;
		
read:		mov		ah,2
			int		10h

			mov		ah,7			;read in a character but not display on screen
			int		21h				;
			
			cmp		al,'w'			;compare al to 'w' and jump if equal
			je		moveUp			;
			
			cmp		al,'s'			;compare al to 's' and jump if equal
			je		moveDn			;
			
			cmp		al,'a'			;compare al to 'a' and jump if equal
			je		moveLft			;
			
			cmp		al,'d'			;compare al to 'd' and jump if equal
			je		moveRgt			;
			
			cmp		al,'W'			;compare al to 'W' and jump if equal
			je		moveUpB			;
			
			cmp		al,'S'			;compare al to 'S' and jump if equal
			je		moveDnB			;
			
			cmp		al,'A'			;compare al to 'A' and jump if equal
			je		moveLftB		;
			
			cmp		al,'D'			;compare al to 'D' and jump if equal
			je		moveRgtB		;
			
			cmp		al,13			;compare al to the decimal value of the "ENTER" key and jump if equal
			je		quit			;

			je		broke			;if character entered is completely incorrectly, jump to task broke
		
moveUp:		sub		dh,1			;this moves the cursor straight up one row
			jmp		read

moveDn:		add		dh,1			;this moves the cursor straight down one row
			jmp		read

moveLft:	sub		dl,1			;this moves the cursor to the left one column
			jmp		read

moveRgt:	add		dl,1			;this moves the cursor to the right one column
			jmp		read

moveUpB:	push	dx				;saves the contents of the registers holding the cursor's position
			
			mov		ah,2			;these three print a black box where the cursor currently is
			mov		dl,219			;
			int		21h				;
			
			pop		dx				;reload the cursor coordinates
			
			sub		dh,1			;moves the cursor one row up
			jmp		read

moveDnB:	push	dx				;saves the contents of the registers holding the cursor's position
			
			mov		ah,2			;these three print a black box where the cursor currently is
			mov		dl,219			;
			int		21h				;
			
			pop		dx				;reload the cursor coordinates
			
			add		dh,1			;moves the cursor one row down
			jmp		read

moveLftB:	push	dx				;saves the contents of the registers holding the cursor's position
			
			mov		ah,2			;these three print a black box where the cursor currently is
			mov		dl,219			;
			int		21h				;
			
			pop		dx				;reload the cursor coordinates
			
			sub		dl,1			;moves the cursor one column left
			jmp		read

moveRgtB:	push	dx				;saves the contents of the registers holding the cursor's position
			
			mov		ah,2			;these three print a black box where the cursor currently is
			mov		dl,219			;
			int		21h				;
			
			pop		dx				;reload the cursor coordinates
			
			add		dl,1			;moves the cursor one column right
			jmp		read

broke:		jmp		read			;just in case a user types in a wrong character		
		
quit:		mov		ah,4ch
			int		21h
			end		main
