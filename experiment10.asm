        AREA    EXP10, CODE, READONLY
        ; Experiment 10: string search from the lab list (count letters in a
        ; string). The code below keeps the register roles obvious for a
        ; beginner: r0 walks the string, r1 accumulates the count, r2 holds the
        ; target character ('A'), and r3 is the current byte.
        EXPORT  _start
        ENTRY

_start                   ; program entry
        LDR     r0, =STRING
        MOV     r1, #0          ; count
        MOV     r2, #'A'        ; letter to find

loop                    ; walk string one byte at a time
        LDRB    r3, [r0], #1
        CMP     r3, #0
        BEQ     done            ; stop at null terminator
        CMP     r3, r2
        ADDEQ   r1, r1, #1      ; increment count if match
        B       loop

done                    ; r1 holds final count
        LDR     r4, =COUNT
        STR     r1, [r4]

stop                    ; simple halt loop
        B       stop

        ALIGN
STRING  DCB "ARM ASSEMBLY",0   ; source string (null-terminated)
COUNT   DCD 0
        END
