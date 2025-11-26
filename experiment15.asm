        AREA    EXP15, CODE, READONLY
        ; Experiment 15: decimal digit to seven-segment code using a lookup
        ; table (items a & b from the lab sheet). R0 reads the input digit,
        ; R3 takes the seven-seg pattern from SEG_TABLE, and invalid digits fall
        ; back to 0 so the behavior is predictable for beginners.
        EXPORT  _start
        ENTRY

_start
        LDR     R1, =IN_PTR
        LDR     R1, [R1]
        LDRB    R0, [R1]

        CMP     R0, #9
        BHI     bad

        LDR     R2, =SEG_TABLE
        ADD     R2, R2, R0
        LDRB    R3, [R2]
        B       store

bad
        MOV     R3, #0

store
        LDR     R4, =OUT_PTR
        LDR     R4, [R4]
        STRB    R3, [R4]

STOP    B       STOP

        AREA    DATA_CONST, DATA, READONLY
IN_PTR  DCD 0x00003100
OUT_PTR DCD 0x00003104

SEG_TABLE
        DCB 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F

        END
