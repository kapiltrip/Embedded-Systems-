; Experiment 1 – Shift instructions demonstration.
; Instructions explained:
;   LDR - loads a 32-bit immediate via literal pool using PC-relative addressing.
;   MOV - copies registers or performs shifts as part of operand2.
;   CMP - subtracts operand from rn to set flags.
;   MOVEQ - conditional move executed when Z flag is set.
;   B - unconditional branch used to halt execution for inspection.

        AREA    EXP1, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; LDR: pseudo-instruction loads 0x12345678 into r0. The assembler places
        ; the constant in a literal pool and performs a PC-relative fetch.
        LDR     r0, =0x12345678

        ; MOV: load the immediate shift count 3 into r2 without affecting flags.
        MOV     r2, #3

        ; MOV with LSL: logical shift left by two positions. Zeroes fill the low
        ; bits and the result is written to r4.
        MOV     r4, r0, LSL #2

        ; MOV with LSR and register count: logical right shift by value in r2.
        ; High bits are cleared; result placed in r5.
        MOV     r5, r0, LSR r2

        ; CMP: compare r0 with itself, producing zero and setting Z flag to 1.
        CMP     r0, r0

        ; MOVEQ: executes only when Z==1, shifting r0 left by five and storing
        ; the value in r6.
        MOVEQ   r6, r0, LSL #5

        ; MOV with ASR: arithmetic right shift by value in r2. Sign bit is copied
        ; into vacated high bits; result goes to r7.
        MOV     r7, r0, ASR r2

stop
        ; B: form an infinite loop so program can be inspected after execution.
        B       stop
        END
