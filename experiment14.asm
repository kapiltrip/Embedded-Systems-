; Experiment 14 – Determine length of a null-terminated string.
; Instructions explained:
;   LDR   - load pointer to string and storage location.
;   MOV   - initialize length counter.
;   LDRB  - read bytes at offset without altering base pointer.
;   CMP   - detect null terminator.
;   ADD   - increment length counter.
;   BEQ/B - control loop and exit.
;   STR   - store final length.
;   B     - halt.

        AREA    EXP14, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; r0 points to string, r1 counts length.
        LDR     r0, =STRING
        MOV     r1, #0
len_loop
        ; Fetch byte at offset r1.
        LDRB    r2, [r0, r1]
        ; If zero terminator, exit.
        CMP     r2, #0
        BEQ     len_done
        ; Otherwise increment count and continue.
        ADD     r1, r1, #1
        B       len_loop
len_done
        ; Store length.
        LDR     r3, =LEN
        STR     r1, [r3]

stop
        ; Halt program.
        B       stop

        ALIGN
STRING  DCB "Embedded Systems",0
LEN     DCD 0
        END
