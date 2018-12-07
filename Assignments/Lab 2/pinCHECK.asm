;Corbin Matamoros
		.MODEL	small
		.STACK	100h
		.DATA
posMES	DB		" Login successful",13,10,'$' 	;string if two numbers' sum < 9
negMES	DB		" Invalid pin number",13,10,'$' ;string if two numbers' sum >= 9
		.CODE
Main:	mov		ax,@data
		mov		ds,ax
		
		mov		ah,1		;these 2 instructions 
		int		21h			;read in a value
		sub		al,30h		;convert to the actual number
		mov		bl,al		;move to another register so we can read in the second pin number
		
		mov 	ah,1		;read in the next pin number
		int		21h
		sub		al,30h
		
		add		bl,al		;add the two pin numbers
		cmp		bl,9		;compares the sum of the pin numbers to 9
		jge		NEGIT		;if the sum is greater than or equal to 9, go to pos instruction block
		
POSIT:	lea		dx,posMES	;these print posMES to the screen
		mov		ah,9
		int		21h		
		
		jmp		done		;skips POSIT
		
NEGIT:	lea		dx,negMES	;these 3 instructions print
		mov		ah,9		;the string negMES to the
		int		21h			;screen
		
done:	mov		ah,4ch
		int		21h
		END		Main