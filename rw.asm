; read/write.asm

; write to a file
; set [REGISTER] to the index to read



; A NOTE ON THE INTERRUPTS FOR THESE METHODS:
;   when this file is compiled, it will NOT work properly in the terminal unless the terminal is closed and restarted
;   as soon as I find out why, this will be fixed but idk bro


; writes a word stored in the writeWord variable to the end of a file
; all registers preserved
write:
	push  ds
	push  ax
	push  dx
	push  cx

	mov   ax, @DATA 
	mov   ds, ax
	mov   dx, offset filename

	; open file and prepare for write
	mov   ax, 3D01h ; open file as write only (int 21h)
	int   21h
	mov   bx, ax ; move the file handle into bx (file handles are the way we can interface with a file)

	; move file pointer to write at end of file
	mov   ax, 4202h ; moves the file pointer to end of file
	mov   cx, 0000h ; cx:dx is the offset value from where the pointer is that we want to move
	mov   dx, 0000h
	int   21h

	; write to the f-ing file finally
	mov   ax, 4000h ; write mode
	mov   cx, 16 ; number of bytes to write
	mov   dx, offset writeWord ; it writes the bytes pointed to by ds:dx
	int   21h

	; close the file
	mov   ax, 3E00h
	int   21h

	pop   cx
	pop   dx
	pop   ax
	pop   ds
	RET


; reads the word at index provided by register dx and stores it in variable readWord
; all registers preserved
read:
	push  ds
	push  ax
	push  dx
	push  cx

	mov   ax, @DATA 
	mov   ds, ax
	mov   dx, offset filename

	; open file and prepare for read
	mov   ax, 3D00h ; open file as read only (int 21h)
	int   21h
	mov   bx, ax ; move the file handle into bx (file handles are the way we can interface with a file)

	pop   cx ; cx contains the segment to read from
	pop   dx ; dx contains the index to read from 
	push  dx
	push  cx

	;  ***NOTE*** come back later & figure out how to use segment (CX), CX:DX is offset
	; depending how many words we are storing, CX will get real necessary real quick
	shl   dx, 1 ; multiply dx by 16 (2^4), dx is the offset val 
	shl   dx, 1 ; for some reason shl dx, 5 was causing a compiler error??
	shl   dx, 1 
	shl   dx, 1 

	; move file pointer to read the given word in the file
	mov   ax, 4200h ; moves the file pointer to end of file
	mov   cx, 0000h ; cx:dx is the offset value from where the pointer is that we want to move
	int   21h

	; read from the file 
	mov   ax, 3F00h ; read mode
	mov   cx, 16 ; number of bytes to read
	mov   dx, offset readWord ; it reads into the bytes pointed to by ds:dx
	int   21h

	; close the file
	mov   ax, 3E00h
	int   21h

	pop   cx
	pop   dx
	pop   ax
	pop   ds
	RET



