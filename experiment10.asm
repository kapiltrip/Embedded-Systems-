        AREA    EXP10, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        LDR     r0, =STRING
        MOV     r1, #0          ; count
        MOV     r2, #'A'        ; letter to find

loop
        LDRB    r3, [r0], #1
        CMP     r3, #0
        BEQ     done
        CMP     r3, r2
        ADDEQ   r1, r1, #1
        B       loop

done
        LDR     r4, =COUNT
        STR     r1, [r4]

stop
        B       stop

        ALIGN
STRING  DCB "ARM ASSEMBLY",0
COUNT   DCD 0
        END
