        AREA    EXP12, CODE, READONLY
        EXPORT  _start
        ENTRY

; Improved quadratic solver for ax^2 + bx + c
; - Uses only simple integer ops (ADD/SUB/MUL/LSL/CMP/branches, SDIV for divide)
; - Handles a = 0 (linear), D < 0 (no real roots), and non-perfect sqrt(D)
; - Outputs: ROOT1, ROOT2, D_OUT, SQRTD, STATUS
;   STATUS codes:
;     0 = OK exact integer roots
;     1 = OK but truncated (non-perfect sqrt or non-divisible)
;     2 = D < 0 (no real roots)
;     3 = Linear (a=0) solved as -c/b
;     4 = Invalid (a=0 and b=0) or divide-by-zero

_start
        ; Load inputs A,B,C
        LDR     r0, =A              ; r0 = a
        LDR     r0, [r0]
        LDR     r1, =B              ; r1 = b
        LDR     r1, [r1]
        LDR     r2, =C              ; r2 = c
        LDR     r2, [r2]

        ; Prepare output addresses
        LDR     r12, =ROOT1         ; r12 will be reused to store outputs
        LDR     r3,  =ROOT2
        LDR     r4,  =D_OUT
        LDR     r5,  =SQRTD
        LDR     r6,  =STATUS

        ; Default outputs
        MOV     r7,  #0
        STR     r7,  [r12]          ; ROOT1 = 0
        STR     r7,  [r3]           ; ROOT2 = 0
        STR     r7,  [r4]           ; D_OUT = 0
        STR     r7,  [r5]           ; SQRTD = 0
        STR     r7,  [r6]           ; STATUS = 0 (will adjust later)

        ; If a == 0, handle linear: bx + c = 0 => x = -c / b
        CMP     r0,  #0
        BNE     do_quadratic

        ; linear path
        CMP     r1,  #0
        BEQ     invalid_case        ; a=0 and b=0 => invalid

        RSB     r7,  r2, #0         ; r7 = -c
        ; Divide using SDIV (requires ARMv7-M or ARMv7-A/R). If not supported on target,
        ; replace this SDIV with a software divide.
        SDIV    r8,  r7, r1         ; r8 = -c / b (trunc toward zero)
        STR     r8,  [r12]          ; ROOT1
        STR     r8,  [r3]           ; ROOT2 (same for linear)
        MOV     r7,  #3
        STR     r7,  [r6]           ; STATUS = 3 (linear)
        B       done

do_quadratic
        ; Compute D = b^2 - 4ac
        MUL     r7,  r1, r1         ; r7 = b^2
        MUL     r8,  r0, r2         ; r8 = a*c
        LSL     r8,  r8, #2         ; r8 = 4ac
        SUB     r9,  r7, r8         ; r9 = D
        STR     r9,  [r4]           ; D_OUT = D

        ; If D < 0: no real roots
        CMP     r9,  #0
        BLT     d_negative

        ; Integer sqrt(D) by safe trial: r10 = floor_sqrt(D), r11 = perfect(0/1)
        MOV     r10, #0             ; candidate sqrt
        MOV     r11, #0             ; perfect flag = 0
sqrt_loop
        MUL     r7,  r10, r10       ; r7 = r10^2
        CMP     r7,  r9             ; compare with D
        BEQ     sqrt_exact
        BGT     sqrt_over
        ADD     r10, r10, #1
        B       sqrt_loop

sqrt_exact
        MOV     r11, #1             ; perfect square
        B       sqrt_done

sqrt_over
        SUB     r10, r10, #1        ; stepped one too far; floor it

sqrt_done
        STR     r10, [r5]           ; SQRTD = floor_sqrt(D)

        ; Compute roots: (-b ± sqrtD) / (2a)
        LSL     r8,  r0, #1         ; r8 = 2a (denominator)
        RSB     r7,  r1, #0         ; r7 = -b
        ADD     r0,  r7, r10        ; r0 = num1 = -b + sqrtD
        SUB     r1,  r7, r10        ; r1 = num2 = -b - sqrtD

        ; Divide (uses SDIV). For targets without SDIV, replace with software divide.
        SDIV    r2,  r0, r8         ; r2 = root1
        SDIV    r3,  r1, r8         ; r3 = root2

        ; Store roots
        LDR     r12, =ROOT1
        STR     r2,  [r12]
        LDR     r12, =ROOT2
        STR     r3,  [r12]

        ; Decide STATUS: 0 exact if perfect sqrt AND numerators divisible by 2a
        ; Check divisibility by verifying (quotient * denom == numerator)
        MUL     r4,  r2, r8         ; r4 = root1 * (2a)
        CMP     r4,  r0
        MOVNE   r11, #0             ; force non-exact if not divisible
        MUL     r4,  r3, r8         ; r4 = root2 * (2a)
        CMP     r4,  r1
        MOVNE   r11, #0
        ; r11 == 1 => exact; else truncated
        MOV     r7,  #0
        CMP     r11, #1
        MOVEQ   r7,  #0             ; exact
        MOVNE   r7,  #1             ; truncated
        LDR     r12, =STATUS
        STR     r7,  [r12]
        B       done

d_negative
        ; D<0 => no real roots
        MOV     r7,  #2
        STR     r7,  [r6]           ; STATUS = 2
        B       done

invalid_case
        ; a=0 and b=0 (not a valid equation)
        MOV     r7,  #4
        STR     r7,  [r6]           ; STATUS = 4

done
        B       done

        ALIGN
A       DCD 1
B       DCD -5
C       DCD 6
ROOT1   DCD 0
ROOT2   DCD 0
D_OUT   DCD 0
SQRTD   DCD 0
STATUS  DCD 0
        END
