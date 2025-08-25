        AREA    EXP2, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; A) direct addressing
        LDR     r0, =VALUE1_A
        LDR     r0, [r0]
        LDR     r1, =VALUE2_A
        LDR     r1, [r1]
        ADDS    r2, r0, r1
        LDR     r3, =RESULT_A
        STR     r2, [r3]

        ; B) indirect addressing (two consecutive)
        LDR     r4, =PAIR_B
        LDMIA   r4, {r5, r6}
        ADDS    r7, r5, r6
        STR     r7, [r4, #8]        ; store after the two values

        ; C) barrel shifter
        MOV     r8, #0x22
        MOV     r9, #0x11
        ADD     r10, r8, r9, LSL #2 ; r10 = 0x22 + (0x11<<2) = 0x66
        LDR     r11, =RESULT_C
        STR     r10, [r11]

stop
        B       stop

        ALIGN
VALUE1_A DCD 0x00001111
VALUE2_A DCD 0x00002222
RESULT_A DCD 0
PAIR_B   DCD 0xAAAA5555, 0x0000FFFF, 0
RESULT_C DCD 0
        END
