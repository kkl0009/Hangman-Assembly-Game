;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Hangman Game in x86 Assembly              ;;
;;                                            ;;
;;  funcs.asm file                            ;;
;;                                            ;;
;;  Contain main functions used throughout    ;;
;;                                            ;;
;;                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; generate a tone with frequency specified in ax
; tone will last for CX:DX microseconds
; CX = 0 and DX = F4240h will result in one full second
tone:
    push ax
    push bx
    push cx
    push dx
    
    mov bx, ax
    mov al, 182
    out 43h, al
    mov ax, bx
    out 42h, al
    mov al, ah
    out 42h, al
    in al, 61h
    or al, 03h
    out 61h, al
    mov ah, 86h
    int 15h
    in al, 61h
    and al, 0FCh
    out 61h, al

    pop dx
    pop cx
    pop bx
    pop ax
    ret

startup_sound:
    push ax
    push bx
    push cx
    push dx

    mov ax, 2660
    mov cx, 1h
    mov dx, 46A0h
    call tone
    call tone
    call tone
    mov ax, 2810
    mov cx, 1h
    mov dx, 46A0h
    call tone
    call tone
    call tone
    mov ax, 2660
    mov cx, 1h
    mov dx, 46A0h
    call tone
    call tone
    call tone
    mov ax, 2360
    mov cx, 1h
    mov dx, 46A0h
    call tone
    call tone
    call tone
    mov ax, 2100
    mov cx, 1h
    mov dx, 46A0h
    call tone
    call tone
    call tone
    call tone
    call tone
    call tone
    call tone
    call tone
    call tone

    pop dx
    pop cx
    pop bx
    pop ax
    ret

exit_sound:
    push ax
    push bx
    push cx
    push dx

    mov ax, 2660
    mov cx, 1h
    mov dx, 46A0h
    call tone
    call tone
    call tone
    mov ax, 2810
    mov cx, 1h
    mov dx, 46A0h
    call tone
    call tone
    call tone
    mov ax, 2010
    mov cx, 1h
    mov dx, 46A0h
    call tone
    call tone
    call tone
    mov ax, 2810
    mov cx, 1h
    mov dx, 46A0h
    call tone
    call tone
    call tone
    mov ax, 2660
    mov cx, 1h
    mov dx, 46A0h
    call tone
    call tone
    call tone
    call tone
    call tone
    call tone
    call tone
    call tone
    call tone

    pop dx
    pop cx
    pop bx
    pop ax

    ret

bad_guess_sound:
    push ax
    push bx
    push cx
    push dx

    mov ax, 5000
    mov cx, 1h
    mov dx, 86A0h
    call tone

    pop dx
    pop cx
    pop bx
    pop ax
    ret



;causes system to wait for a specified amount of time
;time in microseconds CX:DX, pass BX as a parameter
wait1:
     ;backup registers
    push ax
    push bx
    push cx
    push dx

    mov ax, 0
    mov bx, 0
    
    delay:
        nop
        inc ax
        cmp ax, 65535
        jne delay

        mov ax, 0
        inc bx
        cmp bx, 12
        jne delay


    
    ;return registers
    pop dx
    pop cx
    pop bx
    pop ax

    ret

 X_COR db 0 ; x coordinate
 Y_COR db 0 ; y coordinate
 CURR_LIVES db 10 ; current amount of lives
 
move_cursor:
    ;backup registers
    push ax
    push bx
    push cx
    push dx

    ;resets cursor position to x and y coordinates
    mov ah, 02h
    mov dh, Y_COR
    mov dl, X_COR
    mov bh, 0
    int 10h

    ;return registers
    pop dx
    pop cx
    pop bx
    pop ax

    ret

clear_screen:
    ;backup registers
    push ax
    push bx
    push cx
    push dx

    mov ah, 07h
    xor al, al
    xor cx, cx
    mov dh, ROWS
    mov dl, COLS
    mov bh, 0fh
    int 10h

    mov X_COR, 0
    mov Y_COR, 0
    call move_cursor

    ;return registers
    pop dx
    pop cx
    pop bx
    pop ax

    ret

; drawing the keyboard
; as soon as we have a way to track what letters have been inputted already, 
;   I will update this to either draw used letters as red or not draw them at all
; - kryzstof
keyboard_draw:
    mov X_COR, COLS/6
    mov Y_COR, ROWS/2 +3
    call move_cursor

    mov ah, 02h
    mov cx, 0
    mov dl, 'a'
    kb_draw_loop:
        mov al, dl
        mov dl, '-'
        CALL check_if_used
        cmp ah, 11h
        je omg_it_got_used

        mov dl, al
        mov ax, 0200h
        int 21h ; output the letter
        jmp cont

        omg_it_got_used:
        mov dl, al
        mov ax, 0200h
        push dx
        mov dx, '-'
        int 21h
        pop dx

        cont:
        inc dl
        inc cx

        ; append spacing
        push dx
        mov dl, 32
        int 21h
        int 21h
        pop dx

        ; drop a line every 9 letters
        cmp cx, 9
        jnz skip
        mov cx, 0
        add Y_COR, 2
        mov X_COR, COLS/6
        call move_cursor
        skip:

        ; increment to next letter
        cmp dl, 'z' + 1
        jne kb_draw_loop
    
    RET

hangman_draw:
    ; draw a hangman based on a counter variable CURR_LIVES
    mov ah, 09h

    ;check CURR_LIVES and go to the matching label
    cmp CURR_LIVES, 0       ;0 lives
        je draw_hangman_0
    cmp CURR_LIVES, 1       ;1 life
        je draw_hangman_1
    cmp CURR_LIVES, 2       ;2 lives
        je draw_hangman_2
    cmp CURR_LIVES, 3       ;3 lives
        je draw_hangman_3
    cmp CURR_LIVES, 4       ;4 lives
        je draw_hangman_4
    cmp CURR_LIVES, 5       ;5 lives
        je draw_hangman_5
    cmp CURR_LIVES, 6       ;6 lives
        je draw_hangman_6
    cmp CURR_LIVES, 7       ;7 lives
        je draw_hangman_7
    cmp CURR_LIVES, 8       ;8 lives
        je draw_hangman_8
    cmp CURR_LIVES, 9       ;9 lives
        je draw_hangman_9
    cmp CURR_LIVES, 10      ;10 lives
        je draw_hangman_10
    jmp draw_hangman_0     ; else go to 0 lives as default

    ; loads the matching effective address, "lea" = load effective address
    draw_hangman_0:
        lea dx, HANGMAN_LIVES_00 
        jmp end_lives_cond
    draw_hangman_1:
        lea dx, HANGMAN_LIVES_01 
        jmp end_lives_cond
    draw_hangman_2:
        lea dx, HANGMAN_LIVES_02
        jmp end_lives_cond
    draw_hangman_3:
        lea dx, HANGMAN_LIVES_03
        jmp end_lives_cond
    draw_hangman_4:
        lea dx, HANGMAN_LIVES_04
        jmp end_lives_cond
    draw_hangman_5:
        lea dx, HANGMAN_LIVES_05
        jmp end_lives_cond
    draw_hangman_6:
        lea dx, HANGMAN_LIVES_06
        jmp end_lives_cond
    draw_hangman_7:
        lea dx, HANGMAN_LIVES_07
        jmp end_lives_cond
    draw_hangman_8:
        lea dx, HANGMAN_LIVES_08
        jmp end_lives_cond
    draw_hangman_9:
        lea dx, HANGMAN_LIVES_09
        jmp end_lives_cond
    draw_hangman_10:
        lea dx, HANGMAN_LIVES_10
        jmp end_lives_cond

    end_lives_cond:

    mov X_COR, 3*COLS/4
    mov Y_COR, ROWS/4

    print_man:           ; draw loop start
        call move_cursor ; set the cursor to point (X_COR, Y_COR)
        int 21h          ; interupt 21 function 09, prints the string pointed to by DS:DX (the first line of the main menu header)  
        inc Y_COR        ; increment the y cooridinate (drop a line)
        add dx, HANGMAN_WIDTH ; change where dx is pointing (we need to progress to the next string to print)
        cmp Y_COR, HANGMAN_HEIGHT + ROWS/4 ; check and see if we have reached the end
        jne print_man  ; if we aren't to the end yet, jump back to the start of the loop

    RET