;Corbin Matamoros
;Program will read in - two characters in HEX at a time - a six-character pin, 
;select the middle 4 bits of each character, multiply the number represented by those 4 bits together, 
;take the average of the three products, and compare to 26. 
;This program, however, will use functions to read, do the multiplication, and the division.
		.MODEL	small
		.STACK	100h
		.DATA
posMES	DB		" Login successful",13,10,'$' 	;num1*num2 + num3*num4 + num5*num6 = total
												;total/3 = average
												;if average < 26, login successfull
negMES	DB		" Invalid pin number",13,10,'$' ;if average > 26, failed login
		.CODE
rmPIN	proc	near		;create a new function/procedure		
		mov		ah,1		;these 2 instructions 
		int		21h			;read in a character
		
		shl		al,2		;shifts bits to left by two
		shr		al,4		;shifts bits to right by 4
							;those two instructions above isolate the middle 4 bits that'll be used for the pin number
							
		mov		ch,al		;bl will store the first of each two pin characters read in per loop
		
		mov 	ah,1		;read in the second pin character
		int		21h
		
		shl		al,2
		shr		al,4
		
		mul		ch			;multiply the two pin numbers, al * ch = ax
		
		ret
rmPIN	endp

divPIN	proc	near		;create a new function/procedure
		
		push	ax			;these four commands save the currect values in these registers
		push	bx			;to the stack. That way this fuction can save its values to 
		push	cx			;them without deleting the values MAIN created!
		push	dx			;yeet!
		
		mov		bp,sp		;move the base pointer to the same location as program counter
		mov		bx,[bp+10]	;add to bp the number of bytes to reach the 3 stored at bottom of stack
		mov		ax,[bp+12]	;add to bp the number of bytes to reach the sum value stored at bottom of stack
		
		div		bl			;ax/bl = al, remainder ah
		
		mov		[bp+12],ax	;technically stores whatever is in al into the stack 12 addresses away from BP
		pop		dx
		pop		cx
		pop		bx
		pop		ax
		
		ret
divPIN	endp

priDig	proc	near
		
		push	ax
		push	bx
		push	cx
		push	dx
		
		mov		bp,sp
		mov		ax,[bp+10]	;move whatever value is 12 bits away from BP into ax
		mov		bl,0		;bl will store the counter
		
		mov		bh,10		;store the number 10 for the division
		
		mov 	dh,8		;this will be used to eventually print a 0 if the average was 0
							;in the first place. Without it, nothing would print at all

whil:	cmp		al,0		;check if al = 0
		je		whill
		mov		dh,0		;at this point, the loop ran, so the check digit is set to 0
		div		bh			;divide average by 10, result is stored in al with the remainder stored in ah
		push	ax			;push the remainder and division result to the stack
		add		bl,1		;increment counter to track number of digits in average
		mov		ah,0
		jmp		whil
		
whill:	cmp		bl,0
		je		fin
		pop		cx
		mov		dl,ch
		
		add		dl,30h		;adds to dl 30-hex to convert integer stored in dl to the character
		mov		ah,2		;this and next instruction will print
		int		21h
		
		sub		bl,1		;decrement counter by 1
		jmp		whill

fin:	cmp		dh,8		;this check digit will be reset if the average != 0
		je		spec		;however, if this instruction runs, the average was 0
		pop		dx
		pop		cx
		pop		bx
		pop		ax
		jmp		finn

spec:	mov		dl,0		;this will print a 0 when the average was equal to 0
		add		dl,30h		
		mov		ah,2		
		int		21h
		pop		dx
		pop		cx
		pop		bx
		pop		ax
finn:	ret
priDig	endp


Main:	mov		ax,@data
		mov		ds,ax
		
		mov		bx, 0		;moves '0' to the register that will hold the total, bx
		mov		dl, 0		;initialize the loop counter, dl
		mov		cx, 3
		
LUP:	cmp		dl, 3
		je		AVG
		call	rmPIN		;call the function "rmPIN"
		add		bx, ax		;add the product to the 'total' register, dx
		add		dl, 1		;increment counter
		jmp		LUP
		
AVG:	mov		ax,bx		;move the total from bx to ax for division
		push	ax			;push sum (value of ax) to stack
		push	cx			;push 3 to the stack
		call	divPIN		;call function "divPIN"
		pop		cx
		
		call	priDig		;call function to print out average
		pop		ax
		cmp		al,26		;compare average to 26
		jae		NEGIT		;if the pin is >= 26, jump to return a negative message	
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