        AREA    EXP4, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; Count how many 0xAC bytes appear in 8 bytes at DATA.
        ; Pointer-style like other experiments (no '=label').

        ; Load external addresses
        LDR     r0, DATA_PTR        ; r0 = 0x000030D0 (start of 8 bytes)
        LDR     r1, COUNT_PTR       ; r1 = 0x000030E0 (result word)

        MOV     r2, #8              ; number of bytes
        MOV     r3, #0              ; count accumulator
        MOV     r4, #0xAC           ; target byte

loop
        LDRB    r5, [r0], #1        ; load byte and advance
        CMP     r5, r4
        ADDEQ   r3, r3, #1
        SUBS    r2, r2, #1
        BNE     loop

        STR     r3, [r1]            ; store count (32-bit word)

stop
        B       stop

        ALIGN

        ; ----------- Pointer constants (absolute addresses) -----------
        AREA    EXP4_DATA, DATA, READONLY
DATA_PTR    DCD 0x000030D0       ; input: 8-byte block address
COUNT_PTR   DCD 0x000030E0       ; output: count word address

        ; Memory map range (Read + Write): 0x000030D0, 0x000030E3
        ;   Alternative roomy range:      0x00003000, 0x000030FF
        ; Big-endian byte layout
        ; Initialize before run (example bytes):
        ;   [0x000030D0..0x000030D7] DATA = AC 00 AC 11 AC AC 10 FF
        ; After run (for the above input):
        ;   [0x000030E0] COUNT = 0x00000004 (there are four 0xAC bytes)
        ;       bytes  : 00 00 00 04
        ;       binary : 00000000 00000000 00000000 00000100
        END
