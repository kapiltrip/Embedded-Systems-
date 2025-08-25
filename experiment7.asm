        AREA    EXP7, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        LDR     r0, =DIVIDEND
        LDR     r0, [r0]
        LDR     r1, =DIVISOR
        LDR     r1, [r1]
        MOV     r2, #0          ; quotient
        CMP     r1, #0
        BEQ     done

loop
        CMP     r0, r1
        BLT     done
        SUB     r0, r0, r1
        ADD     r2, r2, #1
        B       loop

done
        LDR     r3, =QUOTIENT
        STR     r2, [r3]
        LDR     r3, =REMAINDER
        STR     r0, [r3]

stop
        B       stop

        ALIGN
DIVIDEND DCD 20
DIVISOR  DCD 3
QUOTIENT DCD 0
REMAINDER DCD 0
        END
