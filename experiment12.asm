        AREA    EXP12, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        LDR     r0, =A
        LDR     r0, [r0]
        LDR     r1, =B
        LDR     r1, [r1]
        LDR     r2, =C
        LDR     r2, [r2]

        ; compute discriminant D = b^2 - 4ac
        MUL     r3, r1, r1          ; b^2
        MUL     r4, r0, r2          ; a*c
        LSL     r4, r4, #2          ; 4ac
        SUB     r5, r3, r4          ; D

        ; sqrt(D) by trial
        MOV     r6, #0
sqrt_loop
        MUL     r7, r6, r6
        CMP     r7, r5
        BEQ     sqrt_done
        ADD     r6, r6, #1
        B       sqrt_loop
sqrt_done

        ; root1 = (-b + sqrtD)/(2a)
        RSBS    r7, r1, r6         ; r7 = sqrtD - b = -b + sqrtD
        LSL     r8, r0, #1         ; 2a
        SDIV    r9, r7, r8

        ; root2 = (-b - sqrtD)/(2a)
        ADD     r10, r1, r6        ; b + sqrtD
        RSBS    r10, r10, #0       ; -(b+sqrtD)
        SDIV    r11, r10, r8

        LDR     r12, =ROOT1
        STR     r9, [r12]
        LDR     r12, =ROOT2
        STR     r11, [r12]

stop
        B       stop

        ALIGN
A       DCD 1
B       DCD -5
C       DCD 6
ROOT1   DCD 0
ROOT2   DCD 0
        END
