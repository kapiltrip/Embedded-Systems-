        AREA    PROGRAM, CODE, READONLY
        ENTRY

MAIN
        ; Count ones and zeros in a 32-bit word.
        ; Pointer-style like exp6/exp7 (no '=label').

        ; Load external addresses from data labels
        LDR     r7, WORD_PTR       ; r7 = 0x00003040 (input word address)
        LDR     r8, ONES_PTR       ; r8 = 0x00003044 (ones out)
        LDR     r9, ZEROS_PTR      ; r9 = 0x00003048 (zeros out)
        LDR     r10, PASS_PTR      ; r10 = 0x0000304C (pass flag)

        ; Read input word
        LDR     r0, [r7]           ; r0 = 32-bit word from memory
        MOV     r1, #0             ; r1 = count of ones
        MOV     r3, #32            ; r3 = bit counter

bit_loop
        LSRS    r0, r0, #1         ; shift right, LSB into carry
        ADCS    r1, r1, #0         ; ones += carry
        SUBS    r3, r3, #1
        BNE     bit_loop

        RSB     r2, r1, #32        ; r2 = zeros = 32 - ones

        ; Optional check: ones + zeros == 32 → pass=1 else 0
        ADD     r4, r1, r2
        CMP     r4, #32
        MOVEQ   r5, #1
        MOVNE   r5, #0

        ; Store results to memory so they can be viewed
        STR     r1, [r8]           ; ones
        STR     r2, [r9]           ; zeros
        STR     r5, [r10]          ; pass flag

DONE
        B       DONE

        ; Pointers to external addresses (absolute)
        AREA    PROGRAM, DATA, READONLY
WORD_PTR    DCD 0x00003040       ; input: word address
ONES_PTR    DCD 0x00003044       ; output: ones count address
ZEROS_PTR   DCD 0x00003048       ; output: zeros count address
PASS_PTR    DCD 0x0000304C       ; output: pass flag address

        ; Memory map range (Read + Write): 0x00003000, 0x0000304F
        ;   Alternative roomy range:      0x00003000, 0x000030FF
        ; Example memory contents (big-endian) and binaries
        ; Input you set before running:
        ;   [0x00003040] WORD = 0xF0F0F0F0
        ;       bytes  : F0 F0 F0 F0
        ;       binary : 11110000 11110000 11110000 11110000
        ; Outputs written after running:
        ;   [0x00003044] ONES  = 0x00000010 (16)
        ;       bytes  : 00 00 00 10
        ;       binary : 00000000 00000000 00000000 00010000
        ;   [0x00003048] ZEROS = 0x00000010 (16)
        ;       bytes  : 00 00 00 10
        ;       binary : 00000000 00000000 00000000 00010000
        ;   [0x0000304C] PASS  = 0x00000001 (1 if ones+zeros==32)
        ;       bytes  : 00 00 00 01
        ;       binary : 00000000 00000000 00000000 00000001
        END
