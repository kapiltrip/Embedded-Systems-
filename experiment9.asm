        AREA    EXP9, CODE, READONLY
        EXPORT  _start
        ENTRY

; Factorial via lookup table (fixed addresses)
; Reads N from 0x00003100, looks up N! from table at 0x00003104,
; and writes RESULT to 0x0000311C.

_start
        ; Load external addresses (pointer-style)
        LDR     r0, N_PTR            ; r0 -> N address (0x00003100)
        LDR     r1, TBL_PTR          ; r1 -> FACT_TABLE base (0x00003104)
        LDR     r2, RES_PTR          ; r2 -> RESULT address (0x0000311C)

        ; Read N and compute &FACT_TABLE[N]
        LDR     r0, [r0]             ; r0 = N
        ADD     r1, r1, r0, LSL #2   ; r1 = base + (N*4)

        ; Load table value and store result
        LDR     r3, [r1]             ; r3 = FACT_TABLE[N]
        STR     r3, [r2]             ; RESULT = r3

stop
        B       stop

        ALIGN

        AREA    EXP9_DATA, DATA, READONLY
; Fixed-address pointers (fill values in Memory window as described below)
N_PTR       DCD     0x00003100       ; N
TBL_PTR     DCD     0x00003104       ; FACT_TABLE base (0! at +0, 1! at +4, ...)
RES_PTR     DCD     0x0000311C       ; RESULT

; Memory map to populate (word/hex):
;   0x00003100: N               = 0x00000005   ; example input (set 0..5)
;   0x00003104: FACT_TABLE[0]   = 0x00000001   ; 0! = 1
;   0x00003108: FACT_TABLE[1]   = 0x00000001   ; 1! = 1
;   0x0000310C: FACT_TABLE[2]   = 0x00000002   ; 2! = 2
;   0x00003110: FACT_TABLE[3]   = 0x00000006   ; 3! = 6
;   0x00003114: FACT_TABLE[4]   = 0x00000018   ; 4! = 24
;   0x00003118: FACT_TABLE[5]   = 0x00000078   ; 5! = 120
;   0x0000311C: RESULT          = 0x00000000   ; output (becomes 0x78 for N=5)

; Memory window range (R/W): 0x00003100 .. 0x0000311F (32 bytes)

        END
