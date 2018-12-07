;Corbin Matamoros
	.MODEL	small
	.STACK	100h
	.DATA	
VAR	DB		"This is Corbin PC dividing two numbers: 150/3 = ",13,10,'$'; string
	.CODE
Main: 	mov		ax,@data		;these two instructions will be always in the beginning of the program
		mov		ds,ax
		
		mov		ah,9			;these 3 instruction print the string Var to the screen
		lea		dx, Var
		int		21h
		
		mov		ax,150			;these two instructions show how to initialize registers
		mov		bl,3
		div		bl				;this one shows how to divide
		
		mov 	dl,al			
		mov 	ah,2			;the following two instructions print whatever is in DL
		int		21h	
		
		mov		ah,4ch
		int		21h				;these two instructions end the program execution
		END		Main