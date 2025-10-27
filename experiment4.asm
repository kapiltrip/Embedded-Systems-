        AREA    EXP4, CODE, READONLY
        EXPORT  _start
        ENTRY

DATA_BASE   EQU 0x000030D0         ; start address of 8-byte data block
COUNT_BASE  EQU 0x000030E0         ; address where the count is stored

_start
        ; Count how many 0xAC bytes appear in 8 bytes at DATA_BASE.
        ; Pointer-style like other experiments (no "=label").

        ; Load external addresses (literal pool holds absolute addresses)
        LDR     r0, DATA_PTR        ; r0 <= DATA_BASE  (0x000030D0)
        LDR     r1, COUNT_PTR       ; r1 <= COUNT_BASE (0x000030E0)

        MOV     r2, #8              ; r2 = 8 bytes total
        MOV     r3, #0              ; r3 = running count
        MOV     r4, #0xAC           ; r4 = target byte value

loop
        LDRB    r5, [r0], #1        ; r5 = *r0, r0++ (walk DATA_BASE + index)
        CMP     r5, r4              ; compare byte against 0xAC
        ADDEQ   r3, r3, #1          ; if match, increment count
        SUBS    r2, r2, #1          ; decrement remaining byte count
        BNE     loop                ; loop until all 8 bytes consumed

        STR     r3, [r1]            ; store count to COUNT_BASE (word write)

stop
        B       stop                ; hold execution for debugger

        ALIGN

        ; ----------- Pointer constants (absolute addresses) -----------
        AREA    EXP4_DATA, DATA, READONLY
DATA_PTR    DCD DATA_BASE          ; literal for input block address (0x000030D0)
COUNT_PTR   DCD COUNT_BASE         ; literal for output word address (0x000030E0)

        ; Memory map range (Read + Write): DATA_BASE .. COUNT_BASE + 3
        ;   Alternative roomy range:      0x00003000 .. 0x000030FF
        ; Big-endian byte layout if inspecting raw bytes
        ; Example initialisation before run:
        ;   [DATA_BASE + 0x0]..[DATA_BASE + 0x7] = AC 00 AC 11 AC AC 10 FF
        ; Result after run for the example:
        ;   [COUNT_BASE] = 0x00000004 (bytes: 00 00 00 04)
        END
