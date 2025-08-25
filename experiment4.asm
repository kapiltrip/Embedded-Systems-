        AREA    EXP4, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        LDR     r0, =DATA
        MOV     r1, #8          ; number of bytes
        MOV     r2, #0          ; count of 0xAC

loop
        LDRB    r3, [r0], #1
        CMP     r3, #0xAC
        ADDEQ   r2, r2, #1
        SUBS    r1, r1, #1
        BNE     loop

        LDR     r4, =COUNT
        STR     r2, [r4]

stop
        B       stop

        ALIGN
DATA    DCB 0xAC,0x00,0xAC,0x11,0xAC,0xAC,0x10,0xFF
COUNT   DCD 0
        END
