        AREA    EXP11, CODE, READONLY
        ENTRY

A_ADDR          EQU 0x00003100
B_ADDR          EQU 0x00003104
X_ADDR          EQU 0x00003108
Y_ADDR          EQU 0x0000310C
RESULT_A_ADDR   EQU 0x00003110
X2_ADDR         EQU 0x00003114
Y2_ADDR         EQU 0x00003118
Z_ADDR          EQU 0x0000311C
RESULT_B_ADDR   EQU 0x00003120

_start
        LDR     r0, =A_ADDR
        LDR     r0, [r0]
        LDR     r1, =X_ADDR
        LDR     r1, [r1]
        MUL     r2, r1, r1
        MUL     r2, r0, r2

        LDR     r3, =B_ADDR
        LDR     r3, [r3]
        LDR     r4, =Y_ADDR
        LDR     r4, [r4]
        MUL     r5, r4, r4
        MUL     r5, r3, r5

        ADD     r6, r2, r5
        LDR     r7, =RESULT_A_ADDR
        STR     r6, [r7]

        LDR     r0, =X2_ADDR
        LDR     r0, [r0]
        LDR     r1, =Y2_ADDR
        LDR     r1, [r1]
        ADD     r2, r0, r1
        MOV     r3, #6
        MUL     r2, r3, r2

        LDR     r4, =Z_ADDR
        LDR     r4, [r4]
        ADD     r2, r2, r4, LSL #1
        ADD     r2, r2, #4
        LDR     r5, =RESULT_B_ADDR
        STR     r2, [r5]

stop
        B       stop

        ; Memory map (Read/Write): 0x00003100 .. 0x00003123 (0x24 bytes)
        ; Place initial values before run:
        ;   [0x00003100] a  = 0x00000002
        ;   [0x00003104] b  = 0x00000003
        ;   [0x00003108] x  = 0x00000004
        ;   [0x0000310C] y  = 0x00000005
        ;   [0x00003114] x2 = 0x00000001
        ;   [0x00003118] y2 = 0x00000002
        ;   [0x0000311C] z  = 0x00000003
        ; Outputs written after run (expected):
        ;   [0x00003110] RESULT_A = 0x0000006B (107)
        ;   [0x00003120] RESULT_B = 0x0000001C (28)

        END
