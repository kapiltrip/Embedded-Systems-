        AREA    EXP1, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        LDR     r0, =0x12345678     ; load 32-bit constant
        MOV     r2, #3              ; shift count

        ; A) left shift by 2 bits
        MOV     r4, r0, LSL #2

        ; B) logical right shift by r2
        MOV     r5, r0, LSR r2

        ; C) shift left 5 bits when Z flag is set
        CMP     r0, r0              ; set Z=1
        MOVEQ   r6, r0, LSL #5

        ; D) arithmetic right shift by r2
        MOV     r7, r0, ASR r2

stop
        B       stop
        END
