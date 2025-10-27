        AREA    EXP11, CODE, READONLY
        EXPORT  _start
        ENTRY

DATA_BASE   EQU 0x00003100         ; base address of constant/result block in memory

; Computes expression (a*x^2 + b*y^2) and (6(x+y) + 2z + 4) using literal data.
; Offsets and hexadecimal values are noted so you can match debugger memory views.
_start
        ; ---- Expression A: a*x^2 + b*y^2 ----
        LDR     r0, =A_VAL        ; r0 = &A_VAL (0x00003100)
        LDR     r0, [r0]          ; r0 = a = 0x00000002
        LDR     r1, =X_VAL        ; r1 = &X_VAL (0x00003108)
        LDR     r1, [r1]          ; r1 = x = 0x00000004
        MUL     r2, r1, r1        ; r2 = x^2
        MUL     r2, r0, r2        ; r2 = a*x ^2 

        LDR     r3, =B_VAL        ; r3 = &B_VAL (0x00003104)
        LDR     r3, [r3]          ; r3 = b = 0x00000003
        LDR     r4, =Y_VAL        ; r4 = &Y_VAL (0x0000310C)
        LDR     r4, [r4]          ; r4 = y = 0x00000005
        MUL     r5, r4, r4        ; r5 = y^2
        MUL     r5, r3, r5        ; r5 = b*y ^2 

        ADD     r6, r2, r5        ; r6 = a*x^2 + b*y^2 (expect 0x0000006B)
        LDR     r7, =RESULT_A     ; r7 = &RESULT_A (0x00003110)
        STR     r6, [r7]          ; [0x00003110] <= 0x0000006B

        ; ---- Expression B: 6(x + y) + 2z + 4 ----
        LDR     r0, =X2_VAL       ; r0 = &X2_VAL (0x00003114)
        LDR     r0, [r0]          ; r0 = x = 0x00000001
        LDR     r1, =Y2_VAL       ; r1 = &Y2_VAL (0x00003118)
        LDR     r1, [r1]          ; r1 = y = 0x00000002
        ADD     r2, r0, r1        ; r2 = x + y
        MOV     r3, #6            ; r3 = 0x00000006
        MUL     r2, r3, r2        ; r2 = 6(x + y)

        LDR     r4, =Z_VAL        ; r4 = &Z_VAL (0x0000311C)
        LDR     r4, [r4]          ; r4 = z = 0x00000003
        ADD     r2, r2, r4, LSL #1 ; r2 += 2z (adds 0x00000006)
        ADD     r2, r2, #4        ; r2 += 0x00000004
        LDR     r5, =RESULT_B     ; r5 = &RESULT_B (0x00003120)
        STR     r2, [r5]          ; [0x00003120] <= 0x0000001C

stop
        B       stop              ; simple halt loop for debugger

        ALIGN
; Data layout (absolute addresses based on DATA_BASE = 0x00003100)
A_VAL   DCD 0x00000002            ; 0x00003100  (a)
B_VAL   DCD 0x00000003            ; 0x00003104  (b)
X_VAL   DCD 0x00000004            ; 0x00003108  (x)
Y_VAL   DCD 0x00000005            ; 0x0000310C  (y)
RESULT_A DCD 0x00000000           ; 0x00003110  expect 0x0000006B
X2_VAL  DCD 0x00000001            ; 0x00003114  (x for expr B)
Y2_VAL  DCD 0x00000002            ; 0x00003118  (y for expr B)
Z_VAL   DCD 0x00000003            ; 0x0000311C  (z)
RESULT_B DCD 0x00000000           ; 0x00003120  expect 0x0000001C

        ; Memory map range (Read + Write): 0x00003100 .. 0x00003123
        ; Example bytes before run:
        ;   [0x00003100] = 00 00 00 02 (a)
        ;   [0x00003104] = 00 00 00 03 (b)
        ;   [0x00003108] = 00 00 00 04 (x)
        ;   [0x0000310C] = 00 00 00 05 (y)
        ;   [0x00003114] = 00 00 00 01 (x2)
        ;   [0x00003118] = 00 00 00 02 (y2)
        ;   [0x0000311C] = 00 00 00 03 (z)
        ; After run:
        ;   [0x00003110] = 00 00 00 6B (RESULT_A)
        ;   [0x00003120] = 00 00 00 1C (RESULT_B)
        END
