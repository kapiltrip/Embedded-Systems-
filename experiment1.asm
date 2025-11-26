        AREA    EXP1, CODE, READONLY
        ; Experiment 1: basic shift/rotate variations from the lab sheet.
        ; Each block matches items A–D so beginners can map the code to the
        ; printed instructions: left shift, logical right shift, conditional
        ; shift when Z=1, and arithmetic right shift. r0 holds the sample
        ; 32-bit value and r2 carries the shift count.
        EXPORT  _start
        ENTRY

_start
        LDR     r0, =0x12345678     ; load 32-bit constant
        MOV     r2, #3              ; shift count

        ; A) left shift by 2 bits
        MOV     r4, r0, LSL #2

        ; B) logical right shift by r2
        MOV     r5, r0, LSR r2

        ; C) shift left 5 bits when Z flag is set (if r0==0)
        CMP     r0, #0              ; set Z based on r0==0
        MOVEQ   r6, r0, LSL #5

        ; D) arithmetic right shift by r2
        MOV     r7, r0, ASR r2

stop
        B       stop
        END
