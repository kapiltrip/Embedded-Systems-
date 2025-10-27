        AREA    PRACTISE, CODE, READONLY
        EXPORT  _start
        ENTRY

; Practice program: evaluate a*x^2 + b*y^2 and 6(x+y) + 2z + 4.
_start
        ; ---- Expression A: a*x^2 + b*y^2 ----
        LDR     r0, =A_VAL        ; r0 = a
        LDR     r0, [r0]
        LDR     r1, =X_VAL        ; r1 = x
        LDR     r1, [r1]
        MUL     r2, r1, r1        ; r2 = x^2
        MUL     r2, r2, r0        ; r2 = a*x^2

        LDR     r3, =B_VAL        ; r3 = b
        LDR     r3, [r3]
        LDR     r4, =Y_VAL        ; r4 = y
        LDR     r4, [r4]
        MUL     r5, r4, r4        ; r5 = y^2
        MUL     r5, r5, r3        ; r5 = b*y^2

        ADD     r6, r2, r5        ; r6 = a*x^2 + b*y^2
        LDR     r7, =RESULT_A
        STR     r6, [r7]

        ; ---- Expression B: 6(x + y) + 2z + 4 ----
        LDR     r0, =X2_VAL       ; r0 = x (second expression)
        LDR     r0, [r0]
        LDR     r1, =Y2_VAL       ; r1 = y
        LDR     r1, [r1]
        ADD     r2, r0, r1        ; r2 = x + y
        MOV     r3, #6
        MUL     r2, r2, r3        ; r2 = 6(x + y)

        LDR     r4, =Z_VAL        ; r4 = z
        LDR     r4, [r4]
        ADD     r2, r2, r4, LSL #1 ; r2 += 2z
        ADD     r2, r2, #4
        LDR     r5, =RESULT_B
        STR     r2, [r5]

stop
        B       stop

        ALIGN
A_VAL   DCD 2
B_VAL   DCD 3
X_VAL   DCD 4
Y_VAL   DCD 5
RESULT_A DCD 0
X2_VAL  DCD 1
Y2_VAL  DCD 2
Z_VAL   DCD 3
RESULT_B DCD 0
        END
