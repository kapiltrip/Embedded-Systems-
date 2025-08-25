; Experiment 15 – Convert decimal digit to 7-segment display code.
; Instructions explained:
;   LDR   - load decimal value, lookup table base, and destination address.
;   ADD   - scale index by word size (LSL #2) to access table entry.
;   LDR   - fetch segment code from table.
;   STR   - store resulting code for display hardware.
;   B     - loop forever at end.

        AREA    EXP15, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; Load decimal digit.
        LDR     r0, =DEC_VALUE
        LDR     r0, [r0]
        ; Point to correct table entry: r1 = SEG_TABLE + digit*4.
        LDR     r1, =SEG_TABLE
        ADD     r1, r1, r0, LSL #2
        ; Retrieve segment pattern and store it.
        LDR     r2, [r1]
        LDR     r3, =SEG_CODE
        STR     r2, [r3]

stop
        ; Halt.
        B       stop

        ALIGN
DEC_VALUE DCD 5
SEG_TABLE DCD 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F
SEG_CODE  DCD 0
        END
