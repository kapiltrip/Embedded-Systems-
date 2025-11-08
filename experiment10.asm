        ; Count occurrences of 'A' in STRING and store in COUNT
        ; r0 = ptr to STRING, r1 = count, r2 = target 'A', r3 = current byte
        ; Execution loops until null terminator (0) is found
        AREA    EXP10, CODE, READONLY
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
