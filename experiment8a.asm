        AREA    EXP8A, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; Experiment 8A (Ascending)
        ; In-place bubble sort of 10 x 32-bit words at a fixed external address.
        ; Keil notes (beginner-friendly):
        ;   - Map RW once per session: MAP 0x00003000, 0x000031FF READ WRITE
        ;   - Seed/edit as 32-bit words (W32 or 32-bit view). On big-endian
        ;     targets each word N appears as bytes: 00 00 00 NN.
        ;   - Memory Address box takes only an address (e.g., 0x000030F0).

        ; ---- Ascending order (smallest to largest) ----
        LDR     r0, ASC_PTR           ; r0 = base of ASC array (0x000030F0)
        MOV     r1, #10               ; n = 10 elements
outerA
        SUBS    r1, r1, #1            ; pass count: 9,8,...,0
        BEQ     doneA
        MOV     r2, #0                ; i = 0
innerA
        ADD     r3, r0, r2, LSL #2    ; r3 = &A[i]
        LDR     r4, [r3]              ; A[i]
        LDR     r5, [r3, #4]          ; A[i+1]
        CMP     r4, r5
        BLS     noswapA               ; if A[i] <= A[i+1], keep (unsigned)
        STR     r5, [r3]              ; else swap
        STR     r4, [r3, #4]
noswapA
        ADD     r2, r2, #1            ; i++
        CMP     r2, r1                ; while i < pass_count
        BLT     innerA
        B       outerA
doneA

stop
        B       stop

        ALIGN

        ; ----------- Pointer constants (absolute addresses) -----------
        AREA    EXP8A_DATA, DATA, READONLY
ASC_PTR     DCD 0x000030F0       ; ASC base: 0x000030F0..0x00003117 (10 words)

        ; Big-endian bytes per word: 00 00 00 NN (only last byte changes for small N)
        ; Seed before run (example): {7,1,9,3,2,5,4,10,6,8} at 0x000030F0..
        ; After run (ascending):     {1,2,3,4,5,6,7,8,9,10}
        END
