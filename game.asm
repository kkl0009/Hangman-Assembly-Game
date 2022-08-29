;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Hangman Game in x86 Assembly              ;;
;;                                            ;;
;;  game.asm file                             ;;
;;                                            ;;
;;  Contains the main game loop               ;;
;;                                            ;;
;;                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include charin.asm

main_game:
    push ax
    push bx
    push cx
    push dx

    ; clear screen from main menu
    call clear_screen

    ; load a word in from file
    ; get system time and store in cx:dx (for randomness)
    mov ax, 0000h
    int 1Ah
    modulo:
        sub dx, 100 ; 10 is the number of words in the file
        cmp dx, 100
    jae modulo
    CALL read

    ; Set up the location in memory for in which word information will be store
    mov si, 100h
    mov [si], 00h
    mov [si + 01h], 00h
    mov [si + 02h], 00h
    mov [si + 03h], 00h

    mov ax, stacko
    mov ss, ax
    mov sp, offset stacktop

    game_loop:

        ; "press 0 to exit to menu"
        mov X_COR, 0
        mov Y_COR, 0
        call move_cursor
    	mov ah, 09h
    	lea dx, sample_text
    	int 21h

        ; draw the hangman
    	CALL keyboard_draw
        CALL hangman_draw

        mov X_COR, 10 ; Move the cursor for where the word should be printed
        mov Y_COR, 10
        call move_cursor

        cmp CURR_LIVES, 0 ; Exit the game if the player has lost
        je loser

        call print_out_word

        ; Read in the input character from the user
        mov ah, 07h
    	int 21h

    	mov dl, al

        mov X_COR, COLS/6 -1
        mov Y_COR, ROWS/2 -6
        call move_cursor

        ; Exit the game if the input character is 0
        cmp dl, '0'
        je end_game

        ; Check if the letter has already been guessed (dl contains letter)
    	call check_if_used
        cmp ah, 11h
        je letter_used

        ; Check whether the guessed letter is in the word
    	call check_in_word
        cmp ah, 00h
        je not_in_word

        ; Check if the player has won the game or not
    	call check_if_win
        cmp ah, 11h
        je winner

        mov ah, 09h
        lea dx, success_guess
        int 21h

        jmp end_letter_condition

        letter_used: ; The letter has been guessed already (no penalty)
            mov ah, 09h
            lea dx, repeat_letter
            int 21h
            jmp end_letter_condition

        not_in_word: ; The letter is not in the secret word (lose a life)
            ;call bad_guess_sound
            sub CURR_LIVES, 1
            mov ah, 09h
            lea dx, failed_guess
            int 21h
            jmp end_letter_condition

        loser: ; The player has lost the game (return to main menu)
            mov X_COR, COLS/6 -1
            mov Y_COR, ROWS/2 -6
            call move_cursor
            mov ah, 09h
            lea dx, loser_message
            int 21h
            lea dx, readWord
            int 21h
            jmp next
        winner: ; The player has won the game (return to main menu)
            mov ah, 09h
            lea dx, win_message
            int 21h
        next:
            call print_out_word
            mov ah, 07h
            int 21h
            jmp end_game

        end_letter_condition:
            call print_out_word

    jmp game_loop ; Return to the beginning of the file and start over


    end_game:
    pop dx
    pop cx
    pop bx
    pop ax
    CALL clear_screen
    CALL _main_menu

    RET