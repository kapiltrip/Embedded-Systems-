        AREA    HEX_TO_ASCII, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        LDR     R1, =0x00003100
        LDR     R0, [R1]

        LDR     R2, =0x00003104
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

; range: 0x00000000..0xFFFFFFFF (32-bit unsigned)
; map: IN @ 0x00003100 (word), OUT @ 0x00003104 (9 bytes)
; example1: IN=0x4AF23BCD -> OUT="4AF23BCD",0x00
; example2: IN=0x00000005 -> OUT="00000005",0x00
; write: put 32-bit input at 0x00003100 (as a word). After run,
;        read 9 bytes from 0x00003104 (8 chars + 0x00 terminator).
        END
