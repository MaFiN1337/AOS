.model large 
.stack 200h      

.data
    buffer             dw          ?
    varForAX           DW          ?
    tempo              DW          ?
    binaryString       db          16 dup(?)
    isNegative         DB          0
    readindKey         DB          1
    value              DW          0
    just10             Dw          10
                       KeyValCount STRUC
    keys               DB          16 DUP (?)
    values             DW          ?
    counters           DW          ?
KeyValCount ENDS
                       MY_ARRAY    KeyValCount 10 DUP ({})
    keyValCountSize    dw          20
    tenOr13Happened    DB          0
    counter            DW          16
    counterForCompare  DW          0
    counterForCompare2 DW          0
    numOfKeyRead       DW          0
    tempoForSi         DW          0
    tempoForDi         DW          0
    keyNotUnique       DB          0
    tempoForSI2        DW          0
    tempoForDI2        DW          0
    addressOfSameKey   DW          0

.code
Comparing PROC
                   mov  tempoForSi, si
                   mov  tempoForDi, di
    compareLoop:   
                   mov  AL, [SI]
                   inc  si
                   mov  Bl, [DI]
                   add  di, 2
                   cmp  al, 20h
                   jle  firstDone
                   cmp  bl, 20h
                   jle  notEquals
                   cmp  al, Bl
                   jne  notEquals
                   jmp  compareLoop

    firstDone:     
                   cmp  bl, 20h
                   jle  equal
    notEquals:     
                   mov  si, tempoForSi
                   mov  di, tempoForDi
                   ret
    equal:         
                   mov  keyNotUnique, 1
                   mov  si, tempoForSi
                   mov  di, tempoForDi
                   ret
Comparing endp

main proc
                   mov  ax, @data
                   mov  ds, ax
                   mov  si, offset MY_ARRAY
                   mov  di, offset buffer
    read_next:     
                   mov  ah, 3Fh
                   mov  dx, di
                   mov  bx, 0h
                   mov  cx, 1
                   int  21h
                   cmp  ax, 0
                   je   markForJumps
                   mov  cx, [di]
                   add  di, 2
                   cmp  cx, 0Ah
                   je   markForLineEnd
                   cmp  cx, 0Dh
                   je   markForLineEnd
                   mov  tenOr13Happened, 0
                   cmp  readindKey, 0
                   je   markForJumps3
                   cmp  ch, 20h
                   je   endOfKey
                   cmp  cl, 20h
                   je   endOfKey
                   jmp  read_next
    markForJumps:  
                   jmp  markForJumps2
    markForLineEnd:
                   jmp  endOfLine
    endOfKey:      
                   mov  readindKey, 0
                   mov  tempoForDI2, di
                   mov  tempoForSI2, si
                   mov  di, offset buffer
                   mov  si, offset MY_ARRAY
                   mov  cx, 0
    copy_key:      
                   mov  cx, numOfKeyRead
                   cmp  counterForCompare2, cx
                   je   MarkForSi
                   call Comparing
                   cmp  keyNotUnique, 1
                   je   sameKeys
                   inc  counterForCompare2
                   add  si, 20
                   jmp  copy_key
    sameKeys:      
                   mov  buffer, 0
                   mov  counterForCompare2, 0
                   mov  addressOfSameKey, si
                   mov  si, tempoForSI2
                   jmp  read_next
    markForJumps3: 
                   jmp  readingValue
    MarkForSi:     
                   mov  counterForCompare2, 0
                   mov  si, tempoForSI2
    NewKey:        
                   mov  cx, 0
                   mov  al, [di]
                   cmp  al, 20h
                   je   outLoop
                   MOV  [SI], al
                   inc  si
                   add  di, 2
                   inc  cx
                   dec  counter
                   cmp  cx, 16
                   jne  NewKey
    outLoop:       
                   add  si, counter
                   mov  di, tempoForDI2
                   mov  counter, 16
                   jmp  jumpOnLoop
    markForJumps2: 
                   jmp  ennnnd
    endOfLine:     
                   cmp  tenOr13Happened, 1
                   je   justSkipValue
                   mov  tenOr13Happened, 1
                   mov  readindKey, 1
                   cmp  isNegative, 1
                   jne  notNeg
                   neg  value
    notNeg:        
                   mov  isNegative, 0
                   mov  ax, value
                   cmp  keyNotUnique, 1
                   je   sumOurValues
                   mov  [si], ax
                   mov  value, 0
                   mov  buffer, 0
                   mov  di, offset buffer
                   add  si, 4
                   inc  numOfKeyRead
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
                   jmp  read_next
    valIsNeg:      
                   mov  isNegative, 1
    ennnnd:        cmp  isNegative, 1
                   jne  veryEnd
                   neg  value
                   jmp  veryEnd
    justSkipValue: 
                   mov  tenOr13Happened, 0
                   mov  buffer, 0
                   mov  di, offset buffer
                   jmp  jumpOnLoop
    sumOurValues:  
                   mov  tempoForSi, si
                   mov  si, addressOfSameKey
                   add  si, 16
                   mov  bx, [si]
                   add  ax, bx
                   mov  [si], ax
                   add  si, 2
                   mov  ax, [si]
                   inc  ax
                   mov  [si], ax
                   mov  keyNotUnique, 0
                   mov  value, 0
                   mov  buffer, 0
                   mov  di, offset buffer
                   mov  si, tempoForSi
                   jmp  read_next
    veryEnd:       
                   mov ax, value 
                   cmp  keyNotUnique, 1
                   je   addLastNum
                   mov [si], ax
                   mov  si, offset MY_ARRAY
                   mov  cx, 0
    loopForKeys:   
                   mov  bx, 0
    arrayKeysLoop: 
                   mov  ah, 02h
                   mov  dl, [si]
                   int  21h
                   inc  si
                   inc  bx
                   cmp  bx, 16
                   jne  arrayKeysLoop

                   add  si, 4
                   inc  cx
                   cmp  cx, 10
                   jne  loopForKeys
                   mov  ah, 4Ch
                   int  21h
    jumpOnLoop:    
                   jmp  read_next
    addLastNum:    mov  si, addressOfSameKey
                   add si, 16
                   mov  bx, [si]
                   add  ax, bx
                   mov  [si], ax
                   add  si, 2
                   mov  ax, [si]
                   inc  ax
                   mov [si], ax
                   
                        

main endp

    ; Converting PROC
    ;                    mov  si, offset str1
    ;                    mov  cx, lenStr1
    ;                    dec  cx
    ;                    xor  bx, bx
    ;                    xor  dx, dx
    ;     loop1:
    ;                    xor  ah, ah
    ;                    mov  al, [si]
    ;                    cmp  al, 0
    ;                    je   endLoop
    ;                    sub  al, 48
    ;                    cbw
    ;                    mov  varForAX, ax
    ;     ;call Exponentiation
    ;                    mov  ax, varForAX
    ;                    mul  di
    ;                    add  bx, ax
    ;                    inc  si
    ;                    dec  cx
    ;                    cmp  cx, 0
    ;                    jge  loop1
    ;     endLoop:
    ;                    ret
    ; Converting endp

    ; Exponentiation PROC
    ;                    cmp  cx, 0
    ;                    je   end1
    ;                    xor  ax, ax
    ;                    mov  ax, 1
    ;                    mov  di, 10
    ;                    mov  es, cx
    ;     expLoop:
    ;                    mul  di
    ;                    dec  cx
    ;                    cmp  cx, 0
    ;                    jne  expLoop
    ;                    jmp  end2
    ;     end1:
    ;                    mov  di, 1
    ;                    ret
    ;     end2:
    ;                    mov  cx, es
    ;                    mov  di, ax
    ;                    ret
    ; Exponentiation endp

    ; bxToBinary PROC
    ;                    neg  bx
    ;                    mov  cx, 16
    ;                    lea  di, binaryString

    ;     nextBitLoop:
    ;                    shl  bx, 1
    ;                    jnc  zeroBit
    ;                    mov  byte ptr [di], '1'
    ;                    jmp  nextBit
    ;     zeroBit:
    ;                    mov  byte ptr [di], '0'
    ;                    and  byte ptr [di], 11111110b
    ;     nextBit:
    ;                    inc  di
    ;                    loop nextBitLoop
    ;                    mov  byte ptr [di], '$'
    ;                    mov  ah, 9
    ;                    int  21h
    ;                    ret
    ; bxToBinary endp

end main
