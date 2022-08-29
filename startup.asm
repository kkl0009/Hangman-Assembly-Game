;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Hangman Game in x86 Assembly              ;;
;;                                            ;;
;;  startup.asm file                          ;;
;;                                            ;;
;;  Prints the startup screen of the game     ;;
;;                                            ;;
;;                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


_startup_screen:
    ;backup registers
    push ax
    push bx
    push cx
    push dx

    ;sets screen to blue color
    push dx
    mov ah, 06h
    xor al, al
    xor cx, cx
    mov dx, 184fh
    mov bh, 1eh 
    int 10h
    pop dx
  
    ;display startup header
    mov X_COR, (COLS - header_len) / 2
    mov Y_COR, 0

    mov ah, 09h
    lea dx, header

    print_header:
        call move_cursor
        int 21h
        inc Y_COR
        add dx, header_len
        cmp Y_COR, header_height
        jne print_header


    ; play startup sound
    call startup_sound
    

    ; waits seconds
    call wait1 ; Kollin edit
     
    ;return registers
    pop dx
    pop cx
    pop bx
    pop ax

    ret