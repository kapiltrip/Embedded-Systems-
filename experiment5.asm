AREA    HEX_TO_ASCII, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        LDR     R1, =IN_WORD
        LDR     R0, [R1]

        LDR     R2, =0x40000000

        MOV     R3, #8

convert_loop
        MOV     R4, R0, LSR #28

        CMP     R4, #9
        ADDLE   R4, R4, #'0'
        ADDGT   R4, R4, #('A' - 10)

        STRB    R4, [R2], #1

        MOV     R0, R0, LSL #4
        SUBS    R3, R3, #1
        BNE     convert_loop

        MOV     R4, #0
        STRB    R4, [R2]

halt    B       halt

        AREA    HEX_RO_DATA, DATA, READONLY
        ALIGN

IN_WORD DCD     0x4AF23BCD

        END