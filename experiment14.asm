        AREA    EXP14, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        LDR     r0, =STRING
        MOV     r1, #0
len_loop
        LDRB    r2, [r0, r1]
        CMP     r2, #0
        BEQ     len_done
        ADD     r1, r1, #1
        B       len_loop
len_done
        LDR     r3, =LEN
        STR     r1, [r3]

stop
        B       stop

        ALIGN
STRING  DCB "Embedded Systems",0
LEN     DCD 0
        END
