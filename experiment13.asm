        AREA    HEX_TO_ASCII, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        LDR     R1, =IN_ADDR
        LDR     R0, [R1]
        LDR     R2, =OUT_ADDR
        MOV     R3, #8

loop_convert
        MOV     R4, R0, LSR #28
        CMP     R4, #9
        ADDLE   R4, R4, #'0'
        SUBGT   R4, R4, #10
        ADDGT   R4, R4, #'A'
        STRB    R4, [R2], #1
        MOV     R0, R0, LSL #4
        SUBS    R3, R3, #1
        BNE     loop_convert

        MOV     R4, #0
        STRB    R4, [R2]

stop    B       stop

        AREA    HEX_DATA, DATA, READONLY
IN_ADDR DCD     0x00003100
OUT_ADDR DCD    0x00003104
        END
