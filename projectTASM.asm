.model small
.stack 100h

.data 
    decimalVal DW "555", 0
    lenVal EQU ($ - decimalVal) 
    result DW ?

.code
MAIN PROC
    mov ax, @data
    mov ds, ax

    mov cx, 0
loop1:
    mov al, [decimalVal + cx]
    inc cx
    cmp cx, lenVal
    jne loop1

MAIN ENDP

END MAIN