.model small
.stack 100h

.data
    char DB "character$"

.code
MAIN PROC
    mov ax, @data
    mov ds, ax
    
    mov ah, 02h
    mov dl, char
    int 21h

MAIN ENDP

END MAIN