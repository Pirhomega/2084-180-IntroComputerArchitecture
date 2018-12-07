;This program will move a number chosen by the user into the register AX from the memory location 0106. 
;Then it will add 346 to AX, move 3 to BL, then divide AX by BL. 

;Machine code:

;E9
;05
;00
;90
;90
;90
;02
;00
;8B
;06
;06
;01
;81
;C0
;5A
;01
;C6
;C3
;03
;F6
;F3

;Intel instructions:

JMP		            ;(E9 05 00)
NOP               ;(90)
NOP               ;(90)
NOP               ;(90)

;put N = 2 into memory at address 106 (02)

MOV	AX, [106]     ;(8B 06 06 01)
ADD     AX, 346   ;(81 C0 5A 01)
MOV    	BL, 3     ;(C6 C3 03)
DIV     BL        ;(F6 F3)
