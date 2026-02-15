IDEAL
MODEL small
STACK 100h

DATASEG
   seconds db ?
   
CODESEG
start:
	mov ax, @data
	mov ds, ax  
	
	;first print
	mov ah, 2Ch
	int 21h
	mov [seconds], dh
	call PrintTime
	
	Printing:
	
		;check for keypress to exit
		mov ah, 01h
		int 16h         	 ; check buffer from keyboard
		jz Nokey      		 ; ZF=1 → no input → continue loop
	
		; key is pressed
		mov ah, 00h
		int 16h         	 ; clear buffer
		jmp exit
		
	Nokey:
		mov ah, 2Ch			;get current time
		int 21h
		cmp [seconds], dh	;if time has not changed, keep waiting
		je Printing
		mov [seconds], dh    ;update only if time changed
		call PrintTime
		jmp Printing
exit:
	mov ax, 4c00h
	int 21h

Proc PrintTime
	;setting up videoram
	mov ax, 0B800h
	mov es, ax
	mov di, 3984			;(24 * 80 + 72) * 2 = 3984 — bottom-right position for HH:MM:SS
	cld

	;getting current time. 
	mov ah, 2Ch
	int 21h

	;printing hours
	xor ax, ax
	mov al, ch				;hours	
	mov bl, 10				
	div bl					;Quotient is in al, remainder is in ah
	
	add al, '0'				;ASCII of the first num
	add ah, '0'				;ASCII of the second num
	;printing numbers
	mov bh, ah
	mov ah, 72h
	stosw
	mov al, bh
	mov ah, 72h
	stosw
	
	;double dot printing
	mov al, ':'
	mov ah, 70h
	stosw
	
	;printing minutes
	xor ax, ax
	mov al, cl				;minutes	
	mov bl, 10				
	div bl					;Quotient is in al, remainder is in ah
	
	add al, '0'				;ASCII of the first num
	add ah, '0'				;ASCII of the second num
	;printing numbers
	mov bh, ah
	mov ah, 71h
	stosw
	mov al, bh
	mov ah, 71h
	stosw
	
	;double dot printing
	mov al, ':'
	mov ah, 70h
	stosw
	
	;printing seconds
	xor ax, ax
	mov al, dh				;seconds	
	mov bl, 10				
	div bl					;Quotient is in al, remainder is in ah
	
	add al, '0'				;ASCII of the first num
	add ah, '0'				;ASCII of the second num
	;printing numbers
	mov bh, ah
	mov ah, 74h
	stosw
	mov al, bh
	mov ah, 74h
	stosw
	ret
endp
END start