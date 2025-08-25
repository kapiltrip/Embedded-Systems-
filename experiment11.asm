        AREA    EXP11, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; A) a*x^2 + b*y^2
        LDR     r0, =A_VAL
        LDR     r0, [r0]
        LDR     r1, =X_VAL
        LDR     r1, [r1]
        MUL     r2, r1, r1        ; x^2
        MUL     r2, r2, r0        ; a*x^2

        LDR     r3, =B_VAL
        LDR     r3, [r3]
        LDR     r4, =Y_VAL
        LDR     r4, [r4]
        MUL     r5, r4, r4        ; y^2
        MUL     r5, r5, r3        ; b*y^2

        ADD     r6, r2, r5
        LDR     r7, =RESULT_A
        STR     r6, [r7]

        ; B) 6(x+y) + 2z + 4
        LDR     r0, =X2_VAL
        LDR     r0, [r0]
        LDR     r1, =Y2_VAL
        LDR     r1, [r1]
        ADD     r2, r0, r1
        MOV     r3, #6
        MUL     r2, r2, r3        ; 6(x+y)
        LDR     r4, =Z_VAL
        LDR     r4, [r4]
        ADD     r2, r2, r4, LSL #1 ; +2z
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
