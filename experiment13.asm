        AREA    EXP13, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        LDR     R4, =IN_PTR
        LDR     R4, [R4]
        LDR     R0, [R4]

        LDR     R6, =OUT_PTR
        LDR     R6, [R6]
        MOV     R2, #8

LOOP
        MOV     R3, R0, LSR #28
        AND     R3, R3, #0xF

        CMP     R3, #9
        ADDLE   R3, R3, #0x30
        ADDGT   R3, R3, #0x37

        STRB    R3, [R6], #1

        LSL     R0, R0, #4
        SUBS    R2, R2, #1
        BNE     LOOP

        MOV     R3, #0
        STRB    R3, [R6]

STOP    B       STOP

        AREA    DATA_CONST, DATA, READONLY
IN_PTR  DCD 0x00003100
OUT_PTR DCD 0x00003104
;
; basic info (big-endian)
; range: 0x00000000..0xFFFFFFFF (0..4,294,967,295)
; map: IN 0x00003100 (word), OUT 0x00003104 (9 bytes)
; example: IN=0x4AF23BCD -> OUT="4AF23BCD\0"
; final regs (example): R0=0x00000000, R2=0x00000000, R3=0x00000000,
;                       R4=0x00003100, R6=0x0000310C
        END
