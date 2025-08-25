; Experiment 6 – Multiply two numbers using repeated addition.
; Instructions explained:
;   LDR   - fetches operands and store location from memory.
;   MOV   - initializes the product accumulator.
;   CMP   - checks if multiplier is zero to allow early exit.
;   BEQ   - branches to done when multiplier is zero.
;   ADD   - adds multiplicand to product each loop iteration.
;   SUBS  - decrements multiplier and updates flags for loop control.
;   BNE   - repeats loop while multiplier not zero.
;   STR   - stores final product to memory.
;   B     - halts program by looping.

        AREA    EXP6, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; ----- Load operands -----
        ; Obtain multiplicand A into r0 via literal pool then dereference.
        LDR     r0, =A
        LDR     r0, [r0]
        ; Load multiplier B into r1.
        LDR     r1, =B
        LDR     r1, [r1]
        ; Initialize product accumulator P in r2.
        MOV     r2, #0
        ; If multiplier already zero, skip loop.
        CMP     r1, #0
        BEQ     done

loop
        ; Add multiplicand to running product.
        ADD     r2, r2, r0
        ; Decrement multiplier and test for zero.
        SUBS    r1, r1, #1
        ; Continue loop while multiplier not yet zero.
        BNE     loop

done
        ; ----- Store result -----
        LDR     r3, =P
        STR     r2, [r3]

stop
        ; Halt execution.
        B       stop

        ALIGN
A       DCD     19
B       DCD     6
P       DCD     0
        END
