; this file is an example of how to connect rw.asm to the rest of the project
; additionally, it can be used to add a bunch of words to the file

.model small
.data
  filename  db "words.txt", 0 ; storing the name of the file containing words
  writeWord db "test$           " ; this is the word to be written
  readWord  db "$               " ; this is the word to be read from file
  prompt    db "Enter a word to write to file: $" ; prompt
.code

; include files
include rw.asm

main proc
  mov   ax, @DATA 
  mov   ds, ax

  ; READ demo
  ;mov   dx, 0 ; dx is a parameter specifying the index to go to in the file
  ;CALL  read

  ;mov   dx, offset readWord
  ;mov   ax, 0900h
  ;int   21h



  ; WRITE demo

  ; prompt for word
  mov dx, offset prompt
  mov ax, 0900h
  int 21h

  mov bx, offset writeWord
  mov di, 0000h

  ; get keyboard input
  ; characters only, no capitalization. any non key will break it
  mov ax, 0600h
  getInput:
    mov dl, 0ffh
    int 21h
    jz getInput

    cmp al, 9
    jz exitGet

    mov [bx+di], al
    inc di

    cmp di, 15
    jz exitGet

    jmp getInput
  exitGet:
  mov [bx+di], "$"

  ; output what was input
  mov dx, offset writeWord
  mov ax, 0900h
  int 21h

  CALL write

  mov   ah,4ch
  int   21h
main endp
end main
