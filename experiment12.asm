AREA    QUADROOT, CODE, READONLY
        EXPORT  __main
        ENTRY

__main
        LDR     R0, =IN_A_PTR
        LDR     R0, [R0]
        LDR     R3, [R0]

        LDR     R0, =IN_B_PTR
        LDR     R0, [R0]
        LDR     R4, [R0]

        LDR     R0, =IN_C_PTR
        LDR     R0, [R0]
        LDR     R5, [R0]

        MUL     R6, R4, R4
        MOV     R7, #4
        MUL     R8, R3, R5
        MUL     R8, R8, R7
        SUB     R9, R6, R8

        MOV     R10, #0
SQRT_LOOP
        ADD     R11, R10, #1
        MUL     R12, R11, R11
        CMP     R12, R9
        BHI     SQRT_DONE
        MOV     R10, R11
        B       SQRT_LOOP
SQRT_DONE

        ADD     R12, R3, R3

        RSB     R0, R4, #0
        ADD     R0, R0, R10
        MOV     R1, #0
DIV_LOOP1
        SUBS    R0, R0, R12
        ADDPL   R1, R1, #1
        BPL     DIV_LOOP1
        MOV     R6, R1

        RSB     R0, R4, #0
        SUB     R0, R0, R10
        MOV     R1, #0
DIV_LOOP2
        SUBS    R0, R0, R12
        ADDPL   R1, R1, #1
        BPL     DIV_LOOP2
        MOV     R7, R1

        LDR     R0, =OUT_R1_PTR
        LDR     R0, [R0]
        STR     R6, [R0]

        LDR     R0, =OUT_R2_PTR
        LDR     R0, [R0]
        STR     R7, [R0]

STOP    B       STOP

        AREA    DATA_CONST, DATA, READONLY
        ALIGN
IN_A_PTR    DCD 0x40000100
IN_B_PTR    DCD 0x40000104
IN_C_PTR    DCD 0x40000108
OUT_R1_PTR  DCD 0x4000010C
OUT_R2_PTR  DCD 0x40000110

        END