.model large 
.stack 200h      

.data
    str1            DB          "3466", "$"
    lenStr1         equ         ($-str1)
    str2            db          "3466", 0
    lenStr2         equ         ($-str2)
    buffer          dw          ?
    varForAX        DW          ?
    tempo           DW          ?
    binaryString    db          16 dup(?)
    firstIsBigger   DB          "First is bigger", "$"
    secondIsBigger  DB          "Second is bigger", "$"
    equal           DB          "Strings are equal", "$"
    isNegative      DB          0
    readindKey      DB          1
    value           DW          0
    just10          Dw          10
                    KeyValCount STRUC
    keys            DB          16 DUP (?)
    values          DW          ?
    counters        DW          ?
KeyValCount ENDS
                    MY_ARRAY    KeyValCount 10 DUP ({})
    keyValCountSize dw          20
                    KeyAverage  STRUC
    keys2           DW          ?
    average         DW          ?
KeyAverage ENDS

.code
main proc
                   mov  ax, @data
                   mov  ds, ax
                   mov  di, offset buffer
                   dec  di
                   mov si, offset KeyValCount
    read_next:     
                   mov  ah, 3Fh
                   inc  di
                   mov  dx, di
                   mov  bx, 0h
                   mov  cx, 1
                   int  21h
                   cmp  ax, 0
                   je   markForJumps
                   mov  cx, [di]
                   cmp  cx, 0Ah
                   je   endOfLine
                   cmp  cx, 0Dh
                   je   endOfLine
                   cmp  readindKey, 0
                   je   readingValue
                   mov  cx, [di]
                   cmp  ch, 20h
                   je   endOfKey
                   cmp  cl, 20h
                   je   endOfKey
                   jmp  jumpOnLoop
    endOfKey:      
                   mov  readindKey, 0
                   mov  bx, di
                   mov  di, offset buffer
                   mov  cx, 0
    copy_key:      
                   mov  al, [di]
                   MOV  [SI], al
                   inc  si
                   inc di
                   inc  cx
                   cmp  cx, 16
                   jne  copy_key
                   mov  di, bx
                   add si, 4
                   add  si, keyValCountSize
                   jmp  jumpOnLoop
    markForJumps:  
                   jmp  ennnnd
    endOfLine:     
                   mov  readindKey, 1
                   cmp  isNegative, 1
                   jne  notNeg
                   neg  value
    notNeg:        
                   mov  isNegative, 0
                   mov  value, 0
                   mov  buffer, 0
                   mov  di, offset buffer
                   dec  di
                   jmp  jumpOnLoop
    readingValue:  
                   cmp  cx, 2Dh
                   je   valIsNeg
                   mov  buffer, 0
                   sub  cx, 48
                   mov  ax, value
                   mul  just10
                   mov  value, ax
                   add  value, cx
                   mov  di, offset buffer
                   dec  di
                   jmp  jumpOnLoop
    ennnnd:        cmp  isNegative, 1
                   jne  veryEnd
    veryEnd:       
                   mov  si, offset KeyValCount
                   mov  cx, 0
    loopForKeys:   
                   mov  bx, 0
    arrayKeysLoop: 
                   mov  ah, 02h
                   mov  dl, [si]
                   int  21h
                   inc si
                   inc  bx
                   cmp  bx, 20
                   jne  arrayKeysLoop
                   add  si, keyValCountSize
                   inc  cx
                   cmp  cx, 10
                   jne  loopForKeys
                   mov  ah, 4Ch
                   int  21h

    valIsNeg:      
                   mov  isNegative, 1
    jumpOnLoop:    
                   jmp  read_next

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
    ;call Exponentiation
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
    ;mov  dx, offset equal
                   mov  ah, 9
                   int  21h
                   ret
    notEqual:      
                   cmp  al, bl
                   jg   FirstBigger
                   jmp  SecondBigger

    FirstBigger:   
    ;mov  dx, offset firstIsBigger
                   mov  ah, 9
                   int  21h
                   ret
    SecondBigger:  
    ; mov  dx, offset secondIsBigger
                   mov  ah, 9
                   int  21h
                   ret
    lensDiffer:    
                   cmp  ax, lenStr2
                   jg   firstBigger
                   jmp  secondBigger
Comparing endp
end main
