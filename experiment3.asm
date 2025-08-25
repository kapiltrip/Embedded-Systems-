        AREA    EXP3, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; A) multiple register transfer
        LDR     r0, =SRC_A
        LDR     r1, =DST_A
        LDMIA   r0!, {r2-r5}
        STMIA   r1!, {r2-r5}

        ; B) load and store in a loop
        LDR     r0, =SRC_B
        LDR     r1, =DST_B
        MOV     r2, #4
copy_loop
        LDR     r3, [r0], #4
        STR     r3, [r1], #4
        SUBS    r2, r2, #1
        BNE     copy_loop

stop
        B       stop

        ALIGN
SRC_A   DCD 1,2,3,4
DST_A   DCD 0,0,0,0
SRC_B   DCD 5,6,7,8
DST_B   DCD 0,0,0,0
        END
