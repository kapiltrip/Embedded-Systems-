        AREA    EXP9, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; Load external addresses from pointer labels (fixed RAM map)
        LDR     r0, N_PTR            ; r0 = 0x00003100 (N address)
        LDR     r1, TBL_PTR          ; r1 = 0x00003104 (FACT_TABLE base)
        LDR     r2, RES_PTR          ; r2 = 0x0000311C (RESULT address)

        ; Read N from memory
        LDR     r0, [r0]             ; r0 = N

        ; Compute &FACT_TABLE[N] (each entry is 4 bytes)
        ADD     r1, r1, r0, LSL #2   ; r1 = base + N*4

        ; Load FACT_TABLE[N] and store to RESULT
        LDR     r3, [r1]             ; r3 = FACT_TABLE[N]
        STR     r3, [r2]             ; RESULT = r3

stop
        B       stop

        ALIGN

        AREA    EXP9_DATA, DATA, READONLY
; Pointer-style fixed addresses (fill these locations in Memory window)
N_PTR       DCD     0x00003100   ; N (input)
TBL_PTR     DCD     0x00003104   ; FACT_TABLE base (0! at +0, 1! at +4, ...)
RES_PTR     DCD     0x0000311C   ; RESULT (output)

; Fixed RAM map to populate before run:
;   0x00003100: N (input)
;   0x00003104: FACT_TABLE[0] = 1   ; 0!
;   0x00003108: FACT_TABLE[1] = 1   ; 1!
;   0x0000310C: FACT_TABLE[2] = 2   ; 2!
;   0x00003110: FACT_TABLE[3] = 6   ; 3!
;   0x00003114: FACT_TABLE[4] = 24  ; 4!
;   0x00003118: FACT_TABLE[5] = 120 ; 5!
;   0x0000311C: RESULT (output)

        END
