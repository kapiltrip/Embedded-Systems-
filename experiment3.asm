        AREA    EXP3, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; A) multiple register transfer (demonstrate addressing mode pairs)
        ; Pair 1: STMIA  <-> LDMDB (same layout)
        ; Load using LDMDB by starting r0 at end+4 (pre-decrement before access)
        LDR     r0, =SRC_A_END      ; r0 -> end+4
        LDR     r1, =DST_A1         ; destination for pair 1
        LDMDB   r0!, {r2-r5}        ; loads SRC_A[0..3] into r2-r5
        STMIA   r1!, {r2-r5}        ; stores in ascending order

        ; Pair 2: STMIB  <-> LDMDA
        ; LDMDA pre-decrements, so start r0 at end
        LDR     r0, =SRC_A_END      ; r0 -> end+4, LDMDA pre-dec makes it end
        LDR     r1, =DST_A2
        LDMDA   r0!, {r2-r5}
        STMIB   r1!, {r2-r5}

        ; Pair 3: STMDA  <-> LDMIB
        ; LDMIB pre-increments before access; start r0 at start-4
        LDR     r0, =SRC_A_START    ; r0 -> start
        SUB     r0, r0, #4          ; r0 -> start-4
        LDR     r1, =DST_A3
        LDMIB   r0!, {r2-r5}
        STMDA   r1!, {r2-r5}

        ; Pair 4: STMDB  <-> LDMIA
        ; LDMIA post-increments; start r0 at start
        LDR     r0, =SRC_A_START
        LDR     r1, =DST_A4
        LDMIA   r0!, {r2-r5}
        STMDB   r1!, {r2-r5}

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

        ; Place data in a writable DATA area for Keil simulator
        AREA    DATA, DATA, READWRITE
        ALIGN
; Source array A
SRC_A_START
SRC_A   DCD 1,2,3,4
SRC_A_END
; Destinations for each pair demonstration
DST_A1  DCD 0,0,0,0
DST_A2  DCD 0,0,0,0
DST_A3  DCD 0,0,0,0
DST_A4  DCD 0,0,0,0
SRC_B   DCD 5,6,7,8
DST_B   DCD 0,0,0,0
        END
