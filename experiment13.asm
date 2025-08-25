        AREA    EXP13, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        LDR     r0, =VALUE
        LDR     r0, [r0]
        LDR     r1, =BUFFER
        MOV     r2, #8
hex_loop
        MOV     r3, r0, LSR #28
        CMP     r3, #9
        ADDLE   r3, r3, #'0'
        ADDGT   r3, r3, #'A' - 10
        STRB    r3, [r1], #1
        LSL     r0, r0, #4
        SUBS    r2, r2, #1
        BNE     hex_loop
        MOV     r3, #0
        STRB    r3, [r1]

stop
        B       stop

        ALIGN
VALUE   DCD 0x1A2B3C4D
BUFFER  DCB 0,0,0,0,0,0,0,0,0
        END
