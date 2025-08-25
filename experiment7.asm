; Experiment 7 – Division using repeated subtraction.
; Instructions explained:
;   LDR   - retrieve dividend, divisor, and storage addresses.
;   MOV   - clear quotient accumulator.
;   CMP   - compare values to control loops and detect division by zero.
;   BEQ   - branch to done when divisor is zero to avoid division.
;   BLT   - exit loop when dividend becomes less than divisor.
;   SUB   - subtract divisor from dividend each iteration.
;   ADD   - increment quotient after each successful subtraction.
;   STR   - store quotient and remainder.
;   B     - loop for both the division process and the final halt.

        AREA    EXP7, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; Load dividend and divisor.
        LDR     r0, =DIVIDEND
        LDR     r0, [r0]
        LDR     r1, =DIVISOR
        LDR     r1, [r1]
        ; Initialize quotient.
        MOV     r2, #0
        ; Guard against division by zero.
        CMP     r1, #0
        BEQ     done

loop
        ; If dividend < divisor, exit loop.
        CMP     r0, r1
        BLT     done
        ; Subtract divisor and increase quotient.
        SUB     r0, r0, r1
        ADD     r2, r2, #1
        B       loop

done
        ; Store quotient and remainder.
        LDR     r3, =QUOTIENT
        STR     r2, [r3]
        LDR     r3, =REMAINDER
        STR     r0, [r3]

stop
        ; Halt program.
        B       stop

        ALIGN
DIVIDEND DCD 20
DIVISOR  DCD 3
QUOTIENT DCD 0
REMAINDER DCD 0
        END
