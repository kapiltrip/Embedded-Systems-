        AREA    EXP5, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        LDR     r0, =DATA      ; 32-bit value to inspect
        LDR     r0, [r0]
        MOV     r1, #0         ; count of ones
        MOV     r3, #32        ; bit counter

bit_loop
        LSRS    r0, r0, #1     ; shift right, LSB into carry
        ADCS    r1, r1, #0     ; accumulate ones from carry
        SUBS    r3, r3, #1
        BNE     bit_loop

        RSB     r2, r1, #32    ; zeros = 32 - ones

        ; verify ones + zeros = 32
        ADD     r4, r1, r2
        CMP     r4, #32
        MOVEQ   r5, #1
        MOVNE   r5, #0

        ; store results
        LDR     r6, =ONES
        STR     r1, [r6]
        LDR     r6, =ZEROS
        STR     r2, [r6]
        LDR     r6, =PASS
        STR     r5, [r6]

stop
        B       stop

        ALIGN
DATA    DCD 0x12345678
ONES    DCD 0
ZEROS   DCD 0
PASS    DCD 0
        END
