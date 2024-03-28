.model large 
.stack 300h      

.data
    isNegative         DB          0
    readindKey         DB          1
    value              DW          ?
    tenOr13Happened    DB          0
    counter            DW          16
    counterForCompare  DW          0
    counterForCompare2 DW          0
    numOfKeyRead       DW          0
    tempoForSi         DW          0
    tempoForDi         DW          0
    tempoForSi2        DW          0
    keyNotUnique       DB          0
    addressOfSameKey   DW          0
                       KeyValCount STRUC
    keys               DB          16 DUP (?)
    values             DW          ?
    counters           DW          ?
KeyValCount ENDS
                       MY_ARRAY    KeyValCount 100 DUP ({})
    buffer             dw          ?

.code
ChangeKeys PROC
                     mov   tempoForSi, si
                     mov   counterForCompare, 0
                     mov   di, offset buffer
                     sub   si, 16
    fillBuffer:                                      ; fill buffer with key-value of first
                     cmp   counterForCompare, 20
                     je    endOfFill
                     mov   al, [si]
                     mov   [di], al
                     inc   counterForCompare
                     inc   di
                     inc   si
                     jmp   fillBuffer
    endOfFill:       
                     mov   di, offset buffer
                     mov   counterForCompare, 0
    fillSecond:                                      ; fill second with buffer while filling buffer with key-value of second
                     cmp   counterForCompare, 20
                     je    endOfFill2
                     inc   counterForCompare
                     mov   al, [si]
                     mov   bl, [di]
                     mov   [si], bl
                     mov   [di], al
                     inc   si
                     inc   di
                     jmp   fillSecond
    endOfFill2:      
                     sub   si, 40
                     mov   di, offset buffer
                     mov   counterForCompare, 0
    fillFirst:       
                     cmp   counterForCompare, 20
                     je    endOfFill3
                     inc   counterForCompare
                     mov   al, [di]
                     mov   [si], al
                     inc   si
                     inc   di
                     jmp   fillFirst
    endOfFill3:      
                     mov   si, tempoForSi
                     ret
ChangeKeys ENDP

BubbleSort PROC
                     mov   counter, 0
                     mov   si, offset MY_ARRAY
    OuterLoop:       
                     inc   counter
                     mov   ax, counter
                     cmp   ax, numOfKeyRead
                     je    endOfSorting
                     mov   cx, counter               ; like a tempo
                     mov   counter, 0
                     mov   si, offset MY_ARRAY
    InnerLoop:       
                     add   si, 16
                     mov   bx, 20                    ; length between values
                     mov   ax, [si]
                     mov   dx, [si + bx]
                     cmp   ax, dx
                     jl    toCallChangeKey
    changedKeys:     
                     inc   counter
                     mov   ax, counter
                     add   si, 4
                     cmp   ax, numOfKeyRead
                     jne   InnerLoop
                     mov   counter, cx
                     jmp   OuterLoop
    toCallChangeKey: 
                     call  ChangeKeys
                     jmp   changedKeys
    endOfSorting:    
                     ret
BubbleSort ENDP

Comparing PROC
                     mov   tempoForSi, si
                     mov   tempoForDi, di
    compareLoop:     
                     mov   AL, [SI]
                     inc   si
                     mov   Bl, [DI]
                     add   di, 2
                     cmp   al, 20h
                     jle   firstDone
                     cmp   bl, 20h
                     jle   notEquals
                     cmp   al, Bl
                     jne   notEquals
                     jmp   compareLoop

    firstDone:       
                     cmp   bl, 20h
                     jle   equal
    notEquals:       
                     mov   si, tempoForSi
                     mov   di, tempoForDi
                     ret
    equal:           
                     mov   keyNotUnique, 1
                     mov   si, tempoForSi
                     mov   di, tempoForDi
                     ret
Comparing endp

FindAverage PROC
                     mov   si, offset MY_ARRAY
                     mov   cx, 0                     ; counter
    MainLoop:        
                     xor   dx, dx
                     cmp   si, 0
                     je    endOfThisLoop
                     mov   tempoForSi, si
                     add   si, 18
                     mov   bx, [si]
                     cmp   bx, 0
                     je    nextStep
                     inc   bx
                     sub   si, 2
                     mov   ax, [si]
                     div   bx
                     mov   [si], ax

    nextStep:        
                     mov   si, tempoForSi
                     add   si, 20
                     mov   dl, [si]
                     cmp   dl, 0
                     jne   MainLoop
    endOfThisLoop:   
                     ret
FindAverage ENDP

main proc
                     mov   ax, @data
                     mov   ds, ax
                     mov   si, offset MY_ARRAY
                     mov   di, offset buffer
                     mov   value, 0
    read_next:       
                     mov   ah, 3Fh
                     mov   dx, di
                     mov   bx, 0h                    ; stdin
                     mov   cx, 1
                     int   21h
                     cmp   ax, 0
                     je    markForJumps              ; EOF
                     mov   cx, [di]
                     add   di, 2
                     cmp   cx, 0Ah
                     je    markForLineEnd            ; 0Ah meet
                     cmp   cx, 0Dh
                     je    markForLineEnd            ; ODh meet
                     mov   tenOr13Happened, 0        ; For double 0Dh, 0Ah
                     cmp   readindKey, 0
                     je    markForJumps3
                     cmp   ch, 20h
                     je    endOfKey
                     cmp   cl, 20h
                     je    endOfKey
                     jmp   read_next
    markForJumps:    
                     jmp   markForJumps2
    markForLineEnd:  
                     jmp   endOfLine
    endOfKey:        
                     mov   readindKey, 0
                     mov   tempoForDI, di
                     mov   tempoForSI2, si
                     mov   di, offset buffer
                     mov   si, offset MY_ARRAY
                     mov   cx, 0
    copy_key:        
                     mov   cx, numOfKeyRead
                     cmp   counterForCompare2, cx
                     je    MarkForSi
                     call  Comparing
                     cmp   keyNotUnique, 1
                     je    sameKeys
                     inc   counterForCompare2
                     add   si, 20
                     jmp   copy_key
    sameKeys:        
                     mov   ax, 0
                     mov   di, offset buffer
                     mov   cx, 50
    movLoop2:        
                     stosb
                     loop  movLoop2
                     mov   counterForCompare2, 0
                     mov   addressOfSameKey, si
                     mov   si, tempoForSI2
                     mov   di, offset buffer
                     jmp   read_next
    markForJumps3:   
                     jmp   readingValue
    MarkForSi:       
                     mov   counterForCompare2, 0
                     mov   si, tempoForSI2
                     mov   cx, 0
                     inc   numOfKeyRead
    NewKey:          
                     mov   al, [di]
                     cmp   al, 20h
                     je    outLoop
                     MOV   [SI], al
                     inc   si
                     add   di, 2
                     inc   cx
                     dec   counter
                     cmp   cx, 16
                     jne   NewKey
    outLoop:         
                     add   si, counter
                     mov   di, offset buffer
                     mov   counter, 16
                     jmp   jumpOnLoop
    markForJumps2:   
                     jmp   ennnnd
    endOfLine:       
                     cmp   tenOr13Happened, 1
                     je    justSkipValue
                     mov   tenOr13Happened, 1
                     mov   readindKey, 1
                     cmp   isNegative, 1
                     jne   notNeg
                     neg   value
    notNeg:          
                     mov   isNegative, 0
                     mov   ax, value
                     cmp   keyNotUnique, 1
                     je    sumOurValues
                     mov   [si], ax
                     mov   value, 0
                     mov   ax, 0
                     mov   di, offset buffer
                     mov   cx, 50
    movLoop:         
                     stosb
                     loop  movLoop
                     mov   di, offset buffer
                     add   si, 4
                     jmp   jumpOnLoop
    readingValue:    
                     cmp   cx, 2Dh
                     je    valIsNeg
                     sub   cx, 48
                     mov   ax, value
                     mov   bx, 10
                     mul   bx
                     mov   value, ax
                     add   value, cx
                     mov   di, offset buffer
                     jmp   read_next
    justSkipValue:   
                     mov   tenOr13Happened, 0
                     mov   di, offset buffer
                     jmp   jumpOnLoop
    valIsNeg:        
                     mov   isNegative, 1
    ennnnd:          cmp   isNegative, 1
                     jne   veryEnd
                     neg   value
                     jmp   veryEnd
    sumOurValues:    
                     mov   tempoForSi, si
                     mov   si, addressOfSameKey
                     add   si, 16
                     mov   bx, [si]
                     add   ax, bx
                     mov   [si], ax
                     add   si, 2
                     mov   ax, [si]
                     inc   ax
                     mov   [si], ax
                     mov   keyNotUnique, 0
                     mov   value, 0
                     mov   ax, 0
                     mov   di, offset buffer
                     mov   cx, 32
    movLoop1:        
                     stosb
                     loop  movLoop1
                     mov   di, offset buffer
                     mov   si, tempoForSi
                     jmp   read_next
    veryEnd:         
                     mov   ax, value
                     cmp   keyNotUnique, 1
                     je    addLastNum
                     mov   [si], ax
    MarkForLastValue:
                     call  FindAverage
                     call  BubbleSort
                     mov   si, offset MY_ARRAY
                     mov   cx, 0
                     mov   counter, 16
                     xor   dx, dx
                     mov   ax, numOfKeyRead
                     xor   ax, ax
    loopForKeys:     
                     mov   bx, 0
    arrayKeysLoop:   
                     xor dh, dh
                     mov   ah, 02h
                     mov   dl, [si]
                     cmp   dl, 0
                     je    keyHasEnded
                     int   21h
                     inc   si
                     dec   counter
                     inc   bx
                     cmp   bx, 16
                     jne   arrayKeysLoop
    keyHasEnded:     
                     add   si, counter
                     add   si, 4
                     mov   counter, 16
                     inc   cx
                     mov dl, 0Dh
                     int 21h
                     mov   dl, 0Ah
                     int   21h
                     cmp   cx, 100
                     jne   loopForKeys
                     mov   ah, 4Ch
                     int   21h
    jumpOnLoop:      
                     jmp   read_next
    addLastNum:      mov   si, addressOfSameKey
                     add   si, 16
                     mov   bx, [si]
                     add   ax, bx
                     mov   [si], ax
                     add   si, 2
                     mov   ax, [si]
                     inc   ax
                     mov   [si], ax
                     jmp   MarkForLastValue
main endp
end main
