; Experiment 5 – Count number of 1s and 0s in a byte.
; Instructions explained:
;   LDR/LDRB - fetch the byte and read it into a register.
;   MOV      - initialize counters for ones, zeros, and bit iterations.
;   RRX      - rotate right through carry; LSB moves into C flag.
;   ADDCS    - add when carry set (bit was 1).
;   ADDCC    - add when carry clear (bit was 0).
;   SUBS     - decrement loop counter and set flags.
;   BNE      - repeat while not finished.
;   ADD      - sum ones and zeros for verification.
;   CMP      - compare sum with expected total.
;   MOVEQ/MOVNE - set pass flag based on comparison result.
;   STR      - store computed counts and result.
;   B        - infinite loop at program end.

        AREA    EXP5, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; Load byte to inspect.
        LDR     r0, =DATA
        LDRB    r0, [r0]
        ; Prepare counters.
        MOV     r1, #0         ; ones
        MOV     r2, #0         ; zeros
        MOV     r3, #8         ; bit counter

bit_loop
        ; RRX shifts r0 right by one through carry; original LSB enters C.
        RRX     r0, r0
        ; If carry set, increment ones.
        ADDCS   r1, r1, #1
        ; If carry clear, increment zeros.
        ADDCC   r2, r2, #1
        ; Decrement remaining bits.
        SUBS    r3, r3, #1
        ; Loop until all bits processed.
        BNE     bit_loop

        ; Verify ones + zeros == 8.
        ADD     r4, r1, r2
        CMP     r4, #8
        MOVEQ   r5, #1        ; pass flag
        MOVNE   r5, #0

        ; Store results in memory.
        LDR     r6, =ONES
        STR     r1, [r6]
        LDR     r6, =ZEROS
        STR     r2, [r6]
        LDR     r6, =PASS
        STR     r5, [r6]

stop
        ; Halt program.
        B       stop

        ALIGN
DATA    DCB 0xAC
ONES    DCD 0
ZEROS   DCD 0
PASS    DCD 0
        END
