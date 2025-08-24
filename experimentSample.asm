        AREA    EXP6, CODE, READONLY  ;AREA defines a section of memory also called as segment 
        EXPORT  _start
        ENTRY

_start
        ; Load operands
        LDR     r0, =A             ; r0 := A (multiplicand) giving the address of A to ro
		
        LDR     r0, [r0]           ;here im dereferencing the address to put the value of r0 in r0
        LDR     r1, =B             ; r1 := B (multiplier / loop count)
        LDR     r1, [r1]
        MOV     r2, #0             ; r2 := P = 0
        CMP     r1, #0             ;if the flag , 0 is equal to  0 break the loop 
        BEQ     done

loop
        ADD     r2, r2, r0         ; P += A
        SUBS    r1, r1, #1         ; subtract the counter of the multiplier 
        BNE     loop               ; repeat until multiplier is 0

done               ;in case of BEQ i.e early exit , start from here skipping the above part of adding and subtracting
        ; Store result
        LDR     r3, =P
        STR     r2, [r3]           ;feels reverse sometimes, wrt other statements 
                                    ;str <source > [location /destination ]
stop
        B       stop               ; halt

        ALIGN
;-------------- Data -----------------
A       DCD     19                 ; A is multiplicand 
B       DCD     6                  ;B is multiplier 
P       DCD     0                   ;P holds the result , of the multiplication .
        END
