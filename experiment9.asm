        AREA    EXP9, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        LDR     r0, =N
        LDR     r0, [r0]
        LDR     r1, =FACT_TABLE
        ADD     r1, r1, r0, LSL #2
        LDR     r2, [r1]
        LDR     r3, =RESULT
        STR     r2, [r3]

stop
        B       stop

        ALIGN
N       DCD 5
FACT_TABLE DCD 1,1,2,6,24,120
RESULT  DCD 0
        END
