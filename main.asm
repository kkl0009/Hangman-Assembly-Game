;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Hangman Game in x86 Assembly              ;;
;;                                            ;;
;;  main.asm file                             ;;
;;                                            ;;
;;  Runs the main functions to start          ;;
;;  and end the game.                         ;;
;;                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

stacko segment
dw 100 dup(?)
stacktop:
stacko ends

ORG 0100H
.model large
.data
  COLS equ 80 ; width
  ROWS equ 25 ; height
  DIFF equ 0 ; Difficulty (1 - easy, 2 - Medium, 3 - Hard)
  option1 db "1 - Start New Game$"
  option2 db "2 - Quit$"
  diff1 db "1 - Easy$"
  diff2 db "2 - Medium$"
  diff3 db "3 - Hard$"
  sample_text db "Press '0' to exit to main menu$"
  repeat_letter db " You already guessed that...$"
  failed_guess db  " Nope, try again!           $"
  success_guess db " Nice guess!                $"
  win_message db   " Congrats, you win!         $"
  loser_message db " You lose! The word was: $"
  filename  db "words.txt", 0 ; storing the name of the file containing words
  writeWord db "$               " ; this is the word to be written
  readWord  db "mysecretword$   " ; this is the word to be read from file
  include ascii.res

.code

; include files
include funcs.asm
include game.asm
include mainmenu.asm
include startup.asm
include rw.asm


main proc
    
    mov ax, @DATA
    mov ds, ax

    ; set video mode of the game
    mov ah, 0h
    mov al, 3h
    int 10h
    
    ; hide cursor from blinking
    mov ah, 1h
    mov ch, 32h
    int 10h
    
    ; start the game up
    call _startup_screen

    ; main menu screen
    call _main_menu

    ; exit game
    exit:
      call clear_screen
      mov ah, 4ch
      int 21h

main endp
end main
