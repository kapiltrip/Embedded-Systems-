        AREA    EXP5, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        LDR     r0, =DATA      ; byte to inspect
        LDRB    r0, [r0]
        MOV     r1, #0         ; ones
        MOV     r2, #0         ; zeros
        MOV     r3, #8         ; bit counter

bit_loop
        RRX     r0, r0         ; shift right through carry
        ADDCS   r1, r1, #1     ; carry set => bit was 1
        ADDCC   r2, r2, #1     ; carry clear => bit was 0
        SUBS    r3, r3, #1
        BNE     bit_loop

        ; verify ones + zeros = 8
        ADD     r4, r1, r2
        CMP     r4, #8
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
DATA    DCB 0xAC
ONES    DCD 0
ZEROS   DCD 0
PASS    DCD 0
        END
