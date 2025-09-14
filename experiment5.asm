        AREA    EXP5, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
RESULT_BASE     EQU     0x40000000      ; base address for debug memory window
INPUT_ADDR      EQU     RESULT_BASE     ; input value stored here
ONES_ADDR       EQU     RESULT_BASE+4   ; number of ones
ZEROS_ADDR      EQU     RESULT_BASE+8   ; number of zeros
PASS_ADDR       EQU     RESULT_BASE+12  ; verification flag

        LDR     r0, =0x12345678        ; 32-bit value to inspect
        LDR     r6, =INPUT_ADDR
        STR     r0, [r6]               ; make input visible in memory
        MOV     r1, #0                 ; count of ones
        MOV     r3, #32                ; bit counter

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

        ; store results in RAM for debugger inspection
        ; open Memory window at 0x40000000-0x4000000F to view:
        ;   0x40000000 = input value
        ;   0x40000004 = ones count
        ;   0x40000008 = zeros count
        ;   0x4000000C = pass flag (1=valid)
        LDR     r6, =ONES_ADDR
        STR     r1, [r6]
        LDR     r6, =ZEROS_ADDR
        STR     r2, [r6]
        LDR     r6, =PASS_ADDR
        STR     r5, [r6]

stop
        B       stop                    ; endless loop

        END
