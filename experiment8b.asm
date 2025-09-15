        AREA    EXP8B, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; Experiment 8B (Descending)
        ; In-place bubble sort of 10 x 32-bit words at a fixed external address.
        ; Keil notes (beginner-friendly):
        ;   - Map RW once per session: MAP 0x00003000, 0x000031FF READ WRITE
        ;   - Seed/edit as 32-bit words (W32 or 32-bit view). On big-endian
        ;     targets each word N appears as bytes: 00 00 00 NN.
        ;   - Memory Address box takes only an address (e.g., 0x00003120).

        ; ---- Descending order (largest to smallest) ----
        LDR     r0, DESC_PTR          ; r0 = base of DESC array (0x00003120)
        MOV     r1, #10               ; n = 10 elements
outerD
        SUBS    r1, r1, #1            ; pass count: 9,8,...,0
        BEQ     doneD
        MOV     r2, #0                ; i = 0
innerD
        ADD     r3, r0, r2, LSL #2    ; r3 = &D[i]
        LDR     r4, [r3]              ; D[i]
        LDR     r5, [r3, #4]          ; D[i+1]
        CMP     r4, r5
        BHS     noswapD               ; if D[i] >= D[i+1], keep (unsigned)
        STR     r5, [r3]              ; else swap
        STR     r4, [r3, #4]
noswapD
        ADD     r2, r2, #1            ; i++
        CMP     r2, r1                ; while i < pass_count
        BLT     innerD
        B       outerD
doneD

        ; Snapshot: first five descending values -> r6..r10
        LDR     r12, DESC_PTR
        LDMIA   r12, {r6-r10}

stop
        B       stop

        ALIGN

        ; ----------- Pointer constants (absolute addresses) -----------
        AREA    EXP8B_DATA, DATA, READONLY
DESC_PTR    DCD 0x00003120       ; DESC at 0x00003120..0x00003147 (10 x 32-bit words)

        ; Observation / Debug notes:
        ; - Data size: 32-bit words. Use LDR/STR and index step of 4 bytes.
        ; - Endianness: Big-endian view → a word N shows as bytes 00 00 00 NN.
        ;   For small values (1..10) only the last byte is non-zero — expected.
        ; - Memory window: type only an address like 0x00003120 (no ",10").
        ;   To dump 10 words, use Command window: D32 0x00003120,10.
        ; - Mapping required in simulator (once per session):
        ;     MAP 0x00003000, 0x000031FF READ WRITE
        ; - Seed as 32-bit words (example):
        ;     W32 0x00003120,2 | W32 0x00003124,3 | W32 0x00003128,1 | W32 0x0000312C,10 | ...
        ; - After run: memory becomes {10,9,8,7,6,5,4,3,2,1}; snapshot loads r6..r10=10..6.
        END
