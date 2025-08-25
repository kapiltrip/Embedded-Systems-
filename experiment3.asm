; Experiment 3 – Copy blocks of memory using multiple transfer and looped single transfers.
; Instructions explained:
;   LDR    - obtains addresses or data words from memory.
;   LDMIA  - loads multiple registers sequentially, auto-incrementing the address.
;   STMIA  - stores multiple registers sequentially, also auto-incrementing.
;   MOV    - sets up loop counters.
;   LDR/STR with post-index - move one word at a time while advancing pointers.
;   SUBS   - subtracts and sets flags for loop termination.
;   BNE    - branches when Z flag is clear to continue looping.
;   B      - halts execution by looping to itself.

        AREA    EXP3, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; ----- A) multiple register transfer -----
        ; r0 points to source, r1 to destination.
        LDR     r0, =SRC_A
        LDR     r1, =DST_A
        ; LDMIA reads four words from [r0] into r2-r5, incrementing r0 after each.
        LDMIA   r0!, {r2-r5}
        ; STMIA writes those four words to [r1], incrementing r1 after each store.
        STMIA   r1!, {r2-r5}

        ; ----- B) load and store in a loop -----
        ; Set up pointers and loop counter.
        LDR     r0, =SRC_B
        LDR     r1, =DST_B
        MOV     r2, #4
copy_loop
        ; LDR with post-index loads one word then increments source pointer by 4.
        LDR     r3, [r0], #4
        ; STR with post-index writes to destination then advances pointer.
        STR     r3, [r1], #4
        ; SUBS decrements counter; Z flag set when all words copied.
        SUBS    r2, r2, #1
        ; BNE branches back if Z==0, continuing loop.
        BNE     copy_loop

stop
        ; Infinite loop to finish.
        B       stop

        ALIGN
SRC_A   DCD 1,2,3,4
DST_A   DCD 0,0,0,0
SRC_B   DCD 5,6,7,8
DST_B   DCD 0,0,0,0
        END
