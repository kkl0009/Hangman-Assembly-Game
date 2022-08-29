; Assume cs:code, ds:data, ss:stacko

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                 ;
; This file is used for getting inputs from the   ;
; user and processing them as is appropriate      ;
;                                                 ;
; NOTE: This program was only written to work     ;
; with lower-case letters (convert upper-case to  ;
; lower-case to use this effectively)             ;
;                                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This code can be implemented as we see fit. Let me know if you run into any issues or bugs with it! -Kollin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; data segment

; test_text db "mysecretword$"
; LETTER_PTR equ 10h ; This is the memory location where the program will keep track of letters found

; data ends

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; stacko segment
; dw 100 dup(?)
; stacktop:
; stacko ends

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
begin:

; mov ax, data
; mov ds, ax
; mov ax, stacko
; mov ss, ax
; mov sp, offset stacktop

call inputs
ret
; jmp end_of_file

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

inputs: ; NO INPUT PARAMETERS
    push ax
    push bx
    push cx
    push dx

    mov si, 10h
    mov [si], 00h
    mov [si + 01h], 00h
    mov [si + 02h], 00h
    mov [si + 03h], 00h

    inputs_loop:

    mov ah, 01h
    int 21h

    mov dl, al

    call check_if_used
    call check_in_word
    call print_out_word
    call check_if_win

    jmp inputs_loop

    pop dx
    pop cx
    pop bx
    pop ax

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_if_used: ; INPUT PARAMETERS => (character input -> al)
    push bx
    push cx
    push dx

    mov ah, 00h
    
    mov bl, al
    sub bl, 61h

    call simple_mod

    cmp bh, 00h
    je mem_zero

    cmp bh, 01h
    je mem_one

    cmp bh, 02h
    je mem_two

    cmp bh, 03h
    je mem_three

    jmp end_check

    mem_zero:

        mov cl, [si]
        jmp end_check

    mem_one:

        mov cl, [si + 01h]
        jmp end_check

    mem_two:

        mov cl, [si + 02h]
        jmp end_check

    mem_three:

        mov cl, [si + 03h]

    end_check:

        call two_to_n
        and cl, bl
        cmp cl, 00h
        je not_used
        jmp used

    not_used:

        cmp dl, '-'
        je end_of_method ; kryzstof edit

        cmp bh, 00h
        je used_zero

        cmp bh, 01h
        je used_one

        cmp bh, 02h
        je used_two

        cmp bh, 03h
        je used_three

        jmp end_of_method

        used_zero:
            or [si], bl
            jmp end_of_method

        used_one:
            or [si + 01h], bl
            jmp end_of_method

        used_two:
            or [si + 02h], bl
            jmp end_of_method

        used_three:
            or [si + 03h], bl
            jmp end_of_method

    used:

        mov ah, 11h

    end_of_method:
    
    pop dx
    pop cx
    pop bx

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

two_to_n: ; INPUT PARAMETERS => (power to raise 2 to -> bl) | RETURNS => (value of 2^n -> bl)
    push ax
    push cx
    push dx

    cmp bl, 07h
    je eighty

    cmp bl, 06h
    je fourty

    cmp bl, 05h
    je twenty

    cmp bl, 04h
    je ten

    cmp bl, 03h
    je eight

    cmp bl, 02h
    je four

    cmp bl, 01h
    je two

    cmp bl, 00h
    je one

    jmp end_two_to_n

    eighty:
        mov bl, 01h
        jmp end_two_to_n

    fourty:
        mov bl, 02h
        jmp end_two_to_n

    twenty:
        mov bl, 04h
        jmp end_two_to_n

    ten:
        mov bl, 08h
        jmp end_two_to_n

    eight:
        mov bl, 10h
        jmp end_two_to_n

    four:
        mov bl, 20h
        jmp end_two_to_n

    two:
        mov bl, 40h
        jmp end_two_to_n

    one:
        mov bl, 80h

    end_two_to_n:

    pop dx
    pop cx
    pop ax

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

simple_mod: ; INPUT PARAMETERS => (number to modulo -> bl) | RETURNS => (result of the modulo -> bl, address for register -> bh)
    push ax
    push cx
    push dx

    cmp bl, 08h
    je mod_zero

    cmp bl, 09h
    je mod_one

    cmp bl, 0ah
    je mod_two

    cmp bl, 0bh
    je mod_three

    cmp bl, 0ch
    je mod_four

    cmp bl, 0dh
    je mod_five

    cmp bl, 0eh
    je mod_six

    cmp bl, 0fh
    je mod_seven

    cmp bl, 10h
    je mod_eight

    cmp bl, 11h
    je mod_nine

    cmp bl, 12h
    je mod_ten

    cmp bl, 13h
    je mod_eleven

    cmp bl, 14h
    je mod_twelve

    cmp bl, 15h
    je mod_thirteen

    cmp bl, 16h
    je mod_fourteen

    cmp bl, 17h
    je mod_fifteen

    cmp bl, 18h
    je mod_sixteen

    cmp bl, 19h
    je mod_seventeen

    mov bh, 00h
    
    jmp end_of_modulo

    mod_zero:
        mov bl, 00h
        mov bh, 01h
        jmp end_of_modulo    

    mod_one:
        mov bl, 01h
        mov bh, 01h
        jmp end_of_modulo

    mod_two:
        mov bl, 02h
        mov bh, 01h
        jmp end_of_modulo

    mod_three:
        mov bl, 03h
        mov bh, 01h
        jmp end_of_modulo

    mod_four:
        mov bl, 04h
        mov bh, 01h
        jmp end_of_modulo

    mod_five:
        mov bl, 05h
        mov bh, 01h
        jmp end_of_modulo

    mod_six:
        mov bl, 06h
        mov bh, 01h
        jmp end_of_modulo

    mod_seven:
        mov bl, 07h
        mov bh, 01h
        jmp end_of_modulo

    mod_eight:
        mov bl, 00h
        mov bh, 02h
        jmp end_of_modulo    

    mod_nine:
        mov bl, 01h
        mov bh, 02h
        jmp end_of_modulo

    mod_ten:
        mov bl, 02h
        mov bh, 02h
        jmp end_of_modulo

    mod_eleven:
        mov bl, 03h
        mov bh, 02h
        jmp end_of_modulo

    mod_twelve:
        mov bl, 04h
        mov bh, 02h
        jmp end_of_modulo

    mod_thirteen:
        mov bl, 05h
        mov bh, 02h
        jmp end_of_modulo

    mod_fourteen:
        mov bl, 06h
        mov bh, 02h
        jmp end_of_modulo

    mod_fifteen:
        mov bl, 07h
        mov bh, 02h
        jmp end_of_modulo

    mod_sixteen:
        mov bl, 00h
        mov bh, 03h
        jmp end_of_modulo    

    mod_seventeen:
        mov bl, 01h
        mov bh, 03h
        jmp end_of_modulo

    end_of_modulo:

    pop dx
    pop cx
    pop ax
    
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_in_word: ; INPUT PARAMETERS => (character input -> al)

    push bx
    push cx
    push dx

    mov di, offset readWord

    mov ah, 00h

    loop_in_word:
    
        mov cl, [di]
        cmp cl, "$"
        je exit_word_loop

        cmp cl, al
        je loop_positive
        jmp increment_di

        loop_positive:
        
            mov cl, [di]
            sub cl, 20h
            mov [di], cl
            mov ah, 11h

            ; mov dl, [di]
            ; mov ah, 02h
            ; int 21h

        increment_di:

            ; mov dl, [di]
            ; mov ah, 02h
            ; int 21h

            inc di

    jmp loop_in_word

    exit_word_loop:

    pop dx
    pop cx
    pop bx

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_out_word:

    push ax
    push bx
    push cx
    push dx

    mov di, offset readWord

    mov X_COR, COLS/6 -1
    mov Y_COR, ROWS/2 -2
    call move_cursor

    print_loop:

        mov ah, 02h
        mov dl, 32 ; spacing to make her look pretty
        int 21h

        mov cl, [di]
        cmp cl, "$"
        je exit_print_loop

        cmp cl, "Z"
        jbe print_character
        jmp print_underscore

        print_character:
            mov ah, 02h
            mov dl, cl
            add dl, 20h
            int 21h
            jmp print_increment

        print_underscore:
            mov ah, 02h
            mov dl, "_"
            int 21h

        print_increment:
            inc di

    jmp print_loop

    exit_print_loop:

    mov ah, 02h
    mov dl, 0Ah
    int 21h

    pop dx
    pop cx
    pop bx
    pop ax

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_if_win:

    push bx
    push cx
    push dx

    mov di, offset readWord
    mov ah, 00h

    check_loop:

        mov cl, [di]
        cmp cl, "$"
        je check_win

        cmp cl, "Z"
        ja exit_check_loop

        inc di

    jmp check_loop

    check_win:

        mov ah, 11h

        ; mov ah, 02h
        ; mov dl, 0Ah
        ; int 21h

        ; mov dl, "W"
        ; int 21h

    exit_check_loop:

    pop dx
    pop cx
    pop bx

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

end_of_file:




; code ends
; end begin