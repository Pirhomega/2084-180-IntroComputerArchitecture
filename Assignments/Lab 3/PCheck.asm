;Corbin Matamoros
;Program will read in two numbers at a time a six-digit pin, multiply each set together and add them. 
;Divide that sum by 3 and compare to 26. 
		.MODEL	small
		.STACK	100h
		.DATA
posMES	DB		" Login successful",13,10,'$' 	;num1*num2 + num3*num4 + num5*num6 = total
												;total/3 = average
												;if average < 26, login successfull
negMES	DB		" Invalid pin number",13,10,'$' ;if average > 26, failed login
		.CODE
Main:	mov		ax,@data
		mov		ds,ax
		
		mov		bx, 0		;moves '0' to the register that will hold the total, dx
		mov		dl, 0		;initialize the loop counter, dl
		mov		cx, 3
		
LUP:	cmp		dl, 3
		jge		AVG			;jump to next section when loop has performed 3 times
		
		mov		ah,1		;these 2 instructions 
		int		21h			;read in a value
		sub		al,30h		;convert to the actual number
		mov		cl,al		;bl will store the first of each two pin numbers read in per loop
		
		mov 	ah,1		;read in the second pin number
		int		21h
		sub		al,30h
		
		mul		cl			;multiply the two pin numbers, al * bl = ax
		add		bx, ax		;add the product to the 'total' register, dx
		add		dl, 1		;increment counter
		
		jmp		LUP
		
AVG:	mov		ax,bx		;move the total from dx to ax for division
		
		div		dl			;get average of 3 set multiplications, dx/cx = al
		
		cmp		al,26		;compare average to 26
		jge		NEGIT		;if the pin is >= 26, jump to return a negative message
		
POSIT:	lea		dx,posMES	;these print posMES to the screen
		mov		ah,9
		int		21h		
		
		jmp		done		;skips NEGIT
		
NEGIT:	lea		dx,negMES	;these 3 instructions print
		mov		ah,9		;the string negMES to the
		int		21h			;screen
		
done:	mov		ah,4ch
		int		21h
		END		Main