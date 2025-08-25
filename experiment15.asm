        AREA    EXP15, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        LDR     r0, =DEC_VALUE
        LDR     r0, [r0]
        LDR     r1, =SEG_TABLE
        ADD     r1, r1, r0, LSL #2
        LDR     r2, [r1]
        LDR     r3, =SEG_CODE
        STR     r2, [r3]

stop
        B       stop

        ALIGN
DEC_VALUE DCD 5
SEG_TABLE DCD 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F
SEG_CODE  DCD 0
        END
