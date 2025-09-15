        AREA    EXP3, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; Experiment 3
        ; Part 1: Demonstrate STM*/LDM* addressing pairs by copying 4 words
        ;         from SRC_A to four destination blocks using different
        ;         store addressing modes (IA/IB/DA/DB).
        ; Part 2: Copy 4 words using a simple LDR/STR loop.

        ; ---- Part 1: multiple register transfer ----
        ; Load source start address and fetch 4 words into r2-r5
        LDR     r0, SRC_A_PTR          ; r0 = 0x00003060 (SRC_A start)
        LDMIA   r0, {r2-r5}            ; r2=1, r3=2, r4=3, r5=4

        ; Pair 1: use STMIA (Increment After) → ascending layout
        LDR     r1, DSTA1_PTR          ; r1 = 0x00003070
        STMIA   r1, {r2-r5}            ; DSTA1 = 1,2,3,4

        ; Snapshot: show Part 1 (normal) results in r0..r3
        LDR     r12, DSTA1_PTR
        LDMIA   r12, {r0-r3}
        MOV     r4, #0                 ; separator between groups

        ; Pair 2: use STMIB (Increment Before) → set base=start-4
        LDR     r1, DSTA2_PTR          ; r1 = start of DSTA2
        SUB     r1, r1, #4             ; r1 = start-4
        STMIB   r1!, {r2-r5}           ; DSTA2 = 1,2,3,4

        ; Pair 3: use STMDA (Decrement After) → descending layout
        ;         This stores in reverse order (r2 at high address).
        LDR     r1, DSTA3_PTR          ; r1 = start of DSTA3
        ADD     r1, r1, #12            ; r1 = end (start+12)
        STMDA   r1!, {r2-r5}           ; DSTA3 = 4,3,2,1 (low→high)

        ; Pair 4: use STMDB (Decrement Before) → descending layout
        LDR     r1, DSTA4_PTR          ; r1 = start of DSTA4
        ADD     r1, r1, #16            ; r1 = end+4
        STMDB   r1!, {r2-r5}           ; DSTA4 = 4,3,2,1 (low→high)

        ; ---- Part 2: loop copy 4 words ----
        LDR     r0, SRC_B_PTR          ; r0 = 0x000030B0 (SRC_B)
        LDR     r1, DST_B_PTR          ; r1 = 0x000030C0 (DST_B)
        MOV     r2, #4                 ; count = 4 words
copy_loop
        LDR     r3, [r0], #4           ; load and post-increment
        STR     r3, [r1], #4           ; store and post-increment
        
        ; In-loop snapshot: show just the last stored word
        LDR     r5, [r1, #-4]

        SUBS    r2, r2, #1
        BNE     copy_loop

stop
        B       stop

        ALIGN

        ; ----------- Pointer constants (absolute addresses) -----------
        AREA    EXP3_DATA, DATA, READONLY
SRC_A_PTR   DCD 0x00003060     ; SRC_A: 4 words at 0x3060..0x306F
DSTA1_PTR   DCD 0x00003070     ; DSTA1: 0x3070..0x307F (STMIA layout)
DSTA2_PTR   DCD 0x00003080     ; DSTA2: 0x3080..0x308F (STMIB layout)
DSTA3_PTR   DCD 0x00003090     ; DSTA3: 0x3090..0x309F (STMDA layout)
DSTA4_PTR   DCD 0x000030A0     ; DSTA4: 0x30A0..0x30AF (STMDB layout)
SRC_B_PTR   DCD 0x000030B0     ; SRC_B: 0x30B0..0x30BF
DST_B_PTR   DCD 0x000030C0     ; DST_B: 0x30C0..0x30CF

        ; Memory map range (Read + Write): 0x00003060, 0x000030CF
        ;   Alternative roomy range:      0x00003000, 0x000030FF
        ; Big-endian byte layout and simple test values
        ; Initialize before run:
        ;   [0x00003060] SRC_A = {1,2,3,4}
        ;       bytes  : 00 00 00 01 | 00 00 00 02 | 00 00 00 03 | 00 00 00 04
        ;       binary : 000...0001 | 000...0010 | 000...0011 | 000...0100
        ;   [0x000030B0] SRC_B = {5,6,7,8}
        ;       bytes  : 00 00 00 05 | 00 00 00 06 | 00 00 00 07 | 00 00 00 08
        ; After Part 1 stores:
        ;   DSTA1 (0x3070..): 01 02 03 04 (ascending) using STMIA
        ;   DSTA2 (0x3080..): 01 02 03 04 (ascending) using STMIB base=start-4
        ;   DSTA3 (0x3090..): 04 03 02 01 (descending) using STMDA
        ;   DSTA4 (0x30A0..): 04 03 02 01 (descending) using STMDB
        ; After Part 2 loop copy:
        ;   DST_B  (0x30C0..): 05 06 07 08
        END
