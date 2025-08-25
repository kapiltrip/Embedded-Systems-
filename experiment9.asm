; Experiment 9 – Compute factorial using a lookup table.
; Instructions explained:
;   LDR   - fetch input value, table base, and result address.
;   ADD   - compute address within table by scaling index with LSL #2 (word size).
;   LDR   - retrieve factorial value from table.
;   STR   - store factorial result to memory.
;   B     - infinite loop at end for inspection.

        AREA    EXP9, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; Load desired n.
        LDR     r0, =N
        LDR     r0, [r0]
        ; r1 points to start of table; scaled add locates entry n.
        LDR     r1, =FACT_TABLE
        ADD     r1, r1, r0, LSL #2
        ; Fetch factorial from table and store to result.
        LDR     r2, [r1]
        LDR     r3, =RESULT
        STR     r2, [r3]

stop
        ; Halt execution.
        B       stop

        ALIGN
N       DCD 5
FACT_TABLE DCD 1,1,2,6,24,120
RESULT  DCD 0
        END
