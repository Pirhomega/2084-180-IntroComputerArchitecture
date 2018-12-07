;Corbin Matamoros
;Program will read in - two characters in HEX at a time - a six-character pin, 
;select the middle 4 bits of each character, multiply the number represented by those 4 bits together, 
;take the average of the three products, and compare to 26. 
;This program, however, will use functions to read, do the multiplication, and the division.
		.MODEL	small
		.STACK	100h
		.DATA
prodMES	DB		" Which product do you want to see (1, 2, or 3)?",13,10,'$'
PRODUCT	DB		0,0,0		;declares an array of three bytes all initialized to zero
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
		mov		ah,0		;all products will fit into al, so resetting ah just in case
		ret
rmPIN	endp

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

	whil:	mov		ah,0
			cmp		al,0		;check if al = 0
			je		whill
			mov		dh,0		;at this point, the loop ran, so the check digit is set to 0
			div		bh			;divide average by 10, result is stored in al with the remainder stored in ah
			push	ax			;push the remainder and division result to the stack
			add		bl,1		;increment counter to track number of digits in average
			jmp		whil
			
	whill:	cmp		bl,0
			je		fin
			pop		cx
			mov		dl,ch
			
			add		dl,30h
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
		
		mov		ax,0		;initialize all registers
		mov		bx,0
		mov		cx,0
		mov		dx,0
		lea		bx,PRODUCT	;moves the address of the first element of the "PRODUCT" array
		
LUP:	cmp		cl, 3
		je		DONE
		call	rmPIN		;call the function "rmPIN"
		mov		[bx],ax		;sets element to which bx points to whatever is in ax
		add		bx,1		;increment bx to point to next element
		add		cl, 1		;increment counter
		jmp		LUP
				
DONE:	lea		dx,prodMES		;these print prodMES to the screen
		mov		ah,9			;
		int		21h				;
		
		mov		ax,0		;reset ax,cx,dx to zero
		lea		bx,PRODUCT	;have bx point to first element of PRODUCT array
		mov		cx,0
		mov		dx,0
		
		mov 	ah,1		;these 2 instructions read in a character
		int		21h			;
		sub		al,30h		;value read into register al subtracted to convert to integer
		
		sub		al,1		;first element is element [0], 2nd is element [1], etc.
		mov 	ah,0		;reset ah from the character read in instruction above
		
		add		bx,ax
		mov		ax,[bx]
		
		push	ax
		call	priDIG
		pop		ax
		
		mov		ah,4ch
		int		21h
		END		Main