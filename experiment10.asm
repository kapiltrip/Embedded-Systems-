; Experiment 10 – Count occurrences of a letter in a string.
; Instructions explained:
;   LDR   - obtains pointer to string and storage area.
;   MOV   - initializes counter and target character.
;   LDRB  - reads characters one byte at a time with post-increment.
;   CMP   - checks for string terminator and compares characters.
;   BEQ   - exits loop when null terminator reached.
;   ADDEQ - increments count when character matches target.
;   B     - loops until end and halts afterwards.
;   STR   - stores final count.

        AREA    EXP10, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; Pointer to string and initial values.
        LDR     r0, =STRING
        MOV     r1, #0          ; count
        MOV     r2, #'A'        ; letter to find

loop
        ; Fetch next character and advance pointer.
        LDRB    r3, [r0], #1
        ; If null terminator, exit.
        CMP     r3, #0
        BEQ     done
        ; Compare with target and update count if equal.
        CMP     r3, r2
        ADDEQ   r1, r1, #1
        B       loop

done
        ; Store count to memory.
        LDR     r4, =COUNT
        STR     r1, [r4]

stop
        ; Halt program.
        B       stop

        ALIGN
STRING  DCB "ARM ASSEMBLY",0
COUNT   DCD 0
        END
