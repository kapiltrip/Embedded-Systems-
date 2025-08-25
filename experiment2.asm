; Experiment 2 – Add numbers using direct, indirect, and barrel shifter methods.
; Instructions explained:
;   LDR   - fetches a word from memory or loads an immediate via literal pool.
;   ADDS  - performs addition and updates N,Z,C,V flags for later use.
;   STR   - writes a register value back to memory.
;   LDMIA/STMIA - transfer consecutive registers with auto-increment addressing.
;   MOV   - prepares registers with constants or acts as an operand for shifts.
;   ADD   - demonstrates barrel shifter by shifting one operand before addition.
;   B     - loops forever to allow result inspection.

        AREA    EXP2, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; ----- A) direct addressing -----
        ; LDR with = loads the address of VALUE1_A, second LDR dereferences it.
        LDR     r0, =VALUE1_A
        LDR     r0, [r0]
        ; Repeat for second operand.
        LDR     r1, =VALUE2_A
        LDR     r1, [r1]
        ; ADDS adds r0 and r1, updating flags; result placed in r2.
        ADDS    r2, r0, r1
        ; Store the sum to RESULT_A.
        LDR     r3, =RESULT_A
        STR     r2, [r3]

        ; ----- B) indirect addressing (two consecutive) -----
        ; Base address of pair loaded into r4.
        LDR     r4, =PAIR_B
        ; LDMIA reads two consecutive words into r5 and r6, incrementing r4.
        LDMIA   r4, {r5, r6}
        ; ADDS forms their sum in r7, again updating flags.
        ADDS    r7, r5, r6
        ; STR stores result eight bytes past start (after the two values).
        STR     r7, [r4, #8]

        ; ----- C) barrel shifter -----
        ; MOV loads small constants.
        MOV     r8, #0x22
        MOV     r9, #0x11
        ; ADD uses barrel shifter: r9 is shifted left by 2 before addition.
        ADD     r10, r8, r9, LSL #2
        ; Store the computed value.
        LDR     r11, =RESULT_C
        STR     r10, [r11]

stop
        ; Branch back to create a halt loop.
        B       stop

        ALIGN
VALUE1_A DCD 0x00001111
VALUE2_A DCD 0x00002222
RESULT_A DCD 0
PAIR_B   DCD 0xAAAA5555, 0x0000FFFF, 0
RESULT_C DCD 0
        END
