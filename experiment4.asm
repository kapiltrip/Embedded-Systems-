; Experiment 4 – Count how many bytes equal 0xAC in a memory block.
; Instructions explained:
;   LDR   - loads base addresses for data and storage locations.
;   MOV   - initializes loop counters and accumulators.
;   LDRB  - reads a single byte from memory and post-increments the pointer.
;   CMP   - compares byte to constant, updating condition flags.
;   ADDEQ - adds one to the count when Z flag indicates equality.
;   SUBS  - decrements remaining byte count and updates flags.
;   BNE   - repeats loop while bytes remain.
;   STR   - stores the final count to memory.
;   B     - loops forever at program end.

        AREA    EXP4, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; r0 points to data array.
        LDR     r0, =DATA
        ; r1 holds number of bytes to inspect.
        MOV     r1, #8          
        ; r2 accumulates matches.
        MOV     r2, #0          

loop
        ; LDRB reads one byte and increments r0.
        LDRB    r3, [r0], #1
        ; CMP sets Z flag if byte equals 0xAC.
        CMP     r3, #0xAC
        ; ADDEQ increments count only when Z==1.
        ADDEQ   r2, r2, #1
        ; SUBS decrements remaining count and sets flags.
        SUBS    r1, r1, #1
        ; BNE loops back until all bytes processed.
        BNE     loop

        ; Store result in memory.
        LDR     r4, =COUNT
        STR     r2, [r4]

stop
        ; Halt by branching to self.
        B       stop

        ALIGN
DATA    DCB 0xAC,0x00,0xAC,0x11,0xAC,0xAC,0x10,0xFF
COUNT   DCD 0
        END
