; Experiment 13 – Convert a 32-bit value into ASCII hex string.
; Instructions explained:
;   LDR   - load value to convert and destination buffer address.
;   MOV   - set loop counter and manipulate nibbles.
;   LSR   - extract top nibble by shifting right.
;   CMP   - distinguish between numeric and alphabetic hex digits.
;   ADDLE/ADDGT - add appropriate ASCII offsets for '0'-'9' or 'A'-'F'.
;   STRB  - store one ASCII character and increment pointer.
;   LSL   - shift value left to bring next nibble into position.
;   SUBS  - decrement remaining digit count and set flags.
;   BNE   - continue until all digits processed.
;   B     - final halt loop.

        AREA    EXP13, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; Load source value and buffer pointer.
        LDR     r0, =VALUE
        LDR     r0, [r0]
        LDR     r1, =BUFFER
        ; Eight hex digits to output.
        MOV     r2, #8
hex_loop
        ; Grab top nibble.
        MOV     r3, r0, LSR #28
        ; Convert to ASCII.
        CMP     r3, #9
        ADDLE   r3, r3, #'0'
        ADDGT   r3, r3, #'A' - 10
        ; Store character.
        STRB    r3, [r1], #1
        ; Shift left 4 bits to bring next nibble up.
        LSL     r0, r0, #4
        ; Decrement digit counter.
        SUBS    r2, r2, #1
        BNE     hex_loop
        ; Null-terminate string.
        MOV     r3, #0
        STRB    r3, [r1]

stop
        ; Halt.
        B       stop

        ALIGN
VALUE   DCD 0x1A2B3C4D
BUFFER  DCB 0,0,0,0,0,0,0,0,0
        END
