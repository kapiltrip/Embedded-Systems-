        AREA    EXP6, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; Multiply two 32-bit integers using repeated addition.
        ; Pointer-style like experiment 7 (no '=label').

        ; Load external addresses from data labels
        LDR     r0, A_PTR          ; r0 = 0x00003030 (A address)
        LDR     r1, B_PTR          ; r1 = 0x00003034 (B address)
        LDR     r2, P_PTR          ; r2 = 0x00003038 (P address)

        ; Read operands from memory
        LDR     r3, [r0]           ; r3 = A (multiplicand)
        LDR     r4, [r1]           ; r4 = B (multiplier / loop count)
        MOV     r5, #0             ; r5 = product accumulator (P)

        ; If multiplier is zero, skip the loop
        CMP     r4, #0
        BEQ     store

loop
        ADD     r5, r5, r3         ; P += A
        SUBS    r4, r4, #1         ; B--
        BNE     loop               ; repeat until B == 0

store
        ; Store result back to memory so it can be viewed
        STR     r5, [r2]

stop
        B       stop               ; halt

        ALIGN
;-------------- Pointers (absolute addresses) --------------
        AREA    EXP6_DATA, DATA, READONLY
A_PTR   DCD     0x00003030         ; input: A address
B_PTR   DCD     0x00003034         ; input: B address
P_PTR   DCD     0x00003038         ; output: P address

        ; Memory map range (Read + Write): 0x00003000, 0x0000303F
        ;   Alternative roomy range:      0x00003000, 0x000030FF
        ; Example memory contents (big-endian) and binaries
        ; Inputs you set before running:
        ;   [0x00003030] A = 0x00000013 (19)
        ;       bytes  : 00 00 00 13
        ;       binary : 00000000 00000000 00000000 00010011
        ;   [0x00003034] B = 0x00000006 (6)
        ;       bytes  : 00 00 00 06
        ;       binary : 00000000 00000000 00000000 00000110
        ; Output written after running:
        ;   [0x00003038] P = 0x00000072 (114)
        ;       bytes  : 00 00 00 72
        ;       binary : 00000000 00000000 00000000 01110010
        END
