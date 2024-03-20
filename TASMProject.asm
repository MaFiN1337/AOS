.model small    
.stack 100h      

.data
    str1    db  "346",0
    lenStr1 equ ($-str1)
    str2    db  "345",0
    lenStr2 equ ($-str2)

.code
main proc
                mov  ax, @data
                mov  ds, ax
                call Comparing

                mov  ah, 4ch
                int  21h

main endp

Comparing PROC
                mov  ax, lenStr1
                cmp  ax, lenStr2
                jne  notEqual

                mov  cx, lenStr1
                mov  si, offset str1
                mov  di, offset str2
                cld
    compareLoop:
                mov  AL, [SI]
                inc  si
                mov  Bl, [DI]
                inc  di
                cmp  al, bl
                jne  notEqual
                dec  cx
                jnz  compareLoop
                mov  bx, 10
                ret
    notEqual:   
                mov  bx, 6
                ret
Comparing endp
end main