        AREA    EXP8, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; A) ascending order
        LDR     r0, =ASC_ARRAY
        MOV     r1, #5
outerA
        SUBS    r1, r1, #1
        BEQ     doneA
        MOV     r2, #0
innerA
        ADD     r3, r0, r2, LSL #2
        LDR     r4, [r3]
        LDR     r5, [r3, #4]
        CMP     r4, r5
        BLE     noswapA
        STR     r5, [r3]
        STR     r4, [r3, #4]
noswapA
        ADD     r2, r2, #1
        CMP     r2, r1
        BLT     innerA
        B       outerA
doneA

        ; B) descending order
        LDR     r0, =DESC_ARRAY
        MOV     r1, #5
outerD
        SUBS    r1, r1, #1
        BEQ     doneD
        MOV     r2, #0
innerD
        ADD     r3, r0, r2, LSL #2
        LDR     r4, [r3]
        LDR     r5, [r3, #4]
        CMP     r4, r5
        BGE     noswapD
        STR     r5, [r3]
        STR     r4, [r3, #4]
noswapD
        ADD     r2, r2, #1
        CMP     r2, r1
        BLT     innerD
        B       outerD
doneD

stop
        B       stop

        ALIGN
ASC_ARRAY  DCD 5,1,4,2,3
DESC_ARRAY DCD 1,3,2,5,4
        END
