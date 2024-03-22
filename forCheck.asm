.model small    
.stack 100h      

.data
    str1           DB  "3466", 0
    lenStr1        equ ($-str1)
    str2           db  "3466", 0
    lenStr2        equ ($-str2)
    oneChar        db  ?
    filename       DB  "test.in", 0
    varForAX       DW  ?
    binaryString   db  16 dup(?)
    firstIsBigger  DB  "First is bigger", "$"
    secondIsBigger DB  "Second is bigger", "$"
    equal          DB  "Strings are equal", "$"

.code
main proc
                   mov  ax, @data
                   mov  ds, ax
    ;mov  di, 0
    ;read_next:
    ; inc  di
    ; mov  ah, 3Fh
    ; mov  bx, 0h                                   ; stdin handle
    ; mov  cx, 2                                    ; 1 byte to read
    ;mov  dx, offset oneChar                       ; read to ds:dx
    ; int  21h                                      ;  ax = number of bytes read
    ;or   ax,ax
    ;jnz  read_next
    ;lea  si, oneChar
            
    ; write_to_console:
    ;            mov ah, 02h
    ;            mov dl, [si]
    ;            int 21h
    ;            inc si
    ;            dec di
    ;            cmp di, 0
    ;            jne write_to_console
    ;call Converting                  ; result in BX
    ;call bxToBinary
                   call Comparing
                   mov  ah, 4Ch
                   int  21h

main endp

Converting PROC
                   mov  si, offset str1
                   mov  cx, lenStr1
                   dec  cx
                   xor  bx, bx
                   xor  dx, dx
    loop1:         
                   xor  ah, ah
                   mov  al, [si]
                   cmp  al, 0
                   je   endLoop
                   sub  al, 48
                   cbw
                   mov  varForAX, ax
                   call Exponentiation
                   mov  ax, varForAX
                   mul  di
                   add  bx, ax
                   inc  si
                   dec  cx
                   cmp  cx, 0
                   jge  loop1
    endLoop:       
                   ret
Converting endp

Exponentiation PROC
                   cmp  cx, 0
                   je   end1
                   xor  ax, ax
                   mov  ax, 1
                   mov  di, 10
                   mov  es, cx
    expLoop:       
                   mul  di
                   dec  cx
                   cmp  cx, 0
                   jne  expLoop
                   jmp  end2
    end1:          
                   mov  di, 1
                   ret
    end2:          
                   mov  cx, es
                   mov  di, ax
                   ret
Exponentiation endp

bxToBinary PROC
                   neg  bx
                   mov  cx, 16
                   lea  di, binaryString

    nextBitLoop:   
                   shl  bx, 1
                   jnc  zeroBit
                   mov  byte ptr [di], '1'
                   jmp  nextBit
    zeroBit:       
                   mov  byte ptr [di], '0'
                   and  byte ptr [di], 11111110b
    nextBit:       
                   inc  di
                   loop nextBitLoop
                   mov  byte ptr [di], '$'
                   mov  ah, 9
                   int  21h
                   ret
bxToBinary endp




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
                   jne  lensDiffer
                   dec  cx
                   jnz  compareLoop
                   mov  dx, offset equal
                   mov  ah, 9
                   int  21h
                   ret
    notEqual:      
                   cmp  al, bl
                   jg   FirstBigger
                   jmp  SecondBigger

    FirstBigger: 
                   mov  dx, offset firstIsBigger
                   mov  ah, 9
                   int  21h
                   ret
    SecondBigger:
                   mov  dx, offset secondIsBigger
                   mov  ah, 9
                   int  21h
                   ret
    lensDiffer:    
                   cmp  ax, lenStr2
                   jg   firstBigger
                   jmp  secondBigger
Comparing endp
end main
