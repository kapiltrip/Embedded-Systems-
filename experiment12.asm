; Experiment 12 – Compute integer roots of quadratic equation ax^2 + bx + c = 0.
; Instructions explained:
;   LDR   - load coefficients and store locations.
;   MUL   - multiply values (b^2 and a*c).
;   LSL   - multiply by 4 by shifting left two bits.
;   SUB   - subtract to form discriminant D.
;   MOV   - initialize trial value for square root.
;   CMP/BEQ/B - loop to find integer square root by trial.
;   RSBS - reverse subtract setting flags; here computes -b + sqrtD etc.
;   SDIV - signed divide for final roots.
;   STR   - save computed roots.
;   B     - infinite loop at end.

        AREA    EXP12, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; Load coefficients a, b, c.
        LDR     r0, =A
        LDR     r0, [r0]
        LDR     r1, =B
        LDR     r1, [r1]
        LDR     r2, =C
        LDR     r2, [r2]

        ; ----- Compute discriminant D = b^2 - 4ac -----
        MUL     r3, r1, r1          ; b^2
        MUL     r4, r0, r2          ; a*c
        LSL     r4, r4, #2          ; 4ac
        SUB     r5, r3, r4          ; D

        ; ----- Integer square root by trial -----
        MOV     r6, #0
sqrt_loop
        MUL     r7, r6, r6
        CMP     r7, r5
        BEQ     sqrt_done
        ADD     r6, r6, #1
        B       sqrt_loop
sqrt_done

        ; ----- root1 = (-b + sqrtD) / (2a) -----
        RSBS    r7, r1, r6         ; r7 = -b + sqrtD
        LSL     r8, r0, #1         ; 2a
        SDIV    r9, r7, r8

        ; ----- root2 = (-b - sqrtD) / (2a) -----
        ADD     r10, r1, r6        ; b + sqrtD
        RSBS    r10, r10, #0       ; -(b+sqrtD)
        SDIV    r11, r10, r8

        ; Store roots.
        LDR     r12, =ROOT1
        STR     r9, [r12]
        LDR     r12, =ROOT2
        STR     r11, [r12]

stop
        ; Halt.
        B       stop

        ALIGN
A       DCD 1
B       DCD -5
C       DCD 6
ROOT1   DCD 0
ROOT2   DCD 0
        END
