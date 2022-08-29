;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Hangman Game in x86 Assembly              ;;
;;                                            ;;
;;  mainmenu.asm file                         ;;
;;                                            ;;
;;  Display the main menu and allow user to   ;;
;;  choose options                            ;;
;;                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_main_menu:
    ;backup registers
    push ax
    push bx
    push cx
    push dx

    ;changes color of screen
    push dx
    mov ah, 06h
    xor al, al
    xor cx, cx
    mov dx, 184fh
    mov bh, 0eh ;; yellow text on black
    int 10h
    pop dx

    ; print main menu header
    mov X_COR, (COLS - menu_len) / 2
    mov Y_COR, 0

    mov ah, 09h
    lea dx, menu_header  ; "lea" = load effective address

    print_menu_header:   ; draw loop start
        call move_cursor ; set the cursor to point (X_COR, Y_COR)
        int 21h          ; interupt 21 function 09, prints the string pointed to by DS:DX (the first line of the main menu header)  
        inc Y_COR        ; increment the y cooridinate (drop a line)
        add dx, menu_len ; change where dx is pointing (we need to progress to the next string to print)
        cmp Y_COR, menu_height ; check and see if we have reached the end
        jne print_menu_header  ; if we aren't to the end yet, jump back to the start of the loop

    ; print menu options
    mov Y_COR, (ROWS / 2) ; this appears to set the y coordinate to the middle of the screen on the y axis
    call move_cursor ; move the cursor there
    lea dx, option1 ; load the effective address of option 1
    int 21h         ; output option 1

    inc Y_COR ; basically the same shit except we drop 2 lines below & output option 2
    inc Y_COR
    call move_cursor
    lea dx, option2
    int 21h

    ; wait for user input
    option_select:
        mov ah, 07h ;character input no echo 
        int 21h
        cmp al, '2'
        je option_exit
        cmp al, '1'
        je option_game
        jmp option_select

    option_exit:
        ; call exit_sound
        ;return registers
        pop dx
        pop cx
        pop bx
        pop ax
        call exit

    option_game: ; this is the secondary screen with difficulty options
         call clear_screen
         mov X_COR, (COLS - menu_len) / 2
         mov Y_COR, 0

         mov ah, 09h
         lea dx, menu_header

        print_menu_header2: ; outputs all the secondary menu junk basically the same way it's done everywhere above
            call move_cursor
            int 21h
            inc Y_COR
            add dx, menu_len
            cmp Y_COR, menu_height
            jne print_menu_header2

            mov Y_COR, (ROWS / 2)
            call move_cursor
            lea dx, diff1
            int 21h

            inc Y_COR
            inc Y_COR
            call move_cursor
            lea dx, diff2
            int 21h

            inc Y_COR
            inc Y_COR
            call move_cursor
            lea dx, diff3
            int 21h
        
        diff_select: ; reads user input for difficulty
            mov ah, 07h ;character input no echo 
            int 21h
            cmp al, '1'
            je easy_game
            cmp al, '2'
            je med_game
            cmp al, '3'
            je hard_game
            jmp diff_select
        
        ;; Need a way to store the difficulty selected into the DIFF variable?
        ; i think the problem is that "equ" effectively makes DIFF a constant (line 17 main)
        ; maybe try initializing it the same way you did with X_COR and Y_COR
        easy_game:
            ; mov bl, al
            ; mov DIFF, bl
            mov CURR_LIVES, 10
            jmp end_menu
        med_game:
            ; mov bl, al
            ; mov DIFF, bl
            mov CURR_LIVES, 7
            jmp end_menu
        hard_game:
            ; mov bl, al
            ; mov DIFF, bl
            mov CURR_LIVES, 5
            jmp end_menu

        end_menu:
            ;return registers
            pop dx
            pop cx
            pop bx
            pop ax
            call main_game

    ret