        ;=====================================================
        ; Traffic Light Controller (Sample) - ARM7 Big Endian
        ; Uses a single RO AREA like your working experiments
        ; RED -> bit0, YEL -> bit1, GRN -> bit2 of PORT variable
        ; Watch variable: PORT (add to Logic Analyzer)
        ;=====================================================

        AREA    SAMPLE, CODE, READONLY
        EXPORT  _start
        ENTRY

RED     EQU     0x1                ; bit 0
YEL     EQU     0x2                ; bit 1
GRN     EQU     0x4                ; bit 2

_start
        ; R1 holds &PORT, R0 the pattern we write
        LDR     r1, =PORT
        MOV     r0, #0
        STR     r0, [r1]           ; clear PORT
        BL      update_signals     ; mirror bits for Logic Analyzer

main_loop
        ; ---- GREEN (long) ----
        MOV     r0, #GRN
        STR     r0, [r1]
        BL      update_signals
        LDR     r4, =DELAY_LONG
        BL      delay

        ; ---- YELLOW (short) ----
        MOV     r0, #YEL
        STR     r0, [r1]
        BL      update_signals
        LDR     r4, =DELAY_SHORT
        BL      delay

        ; ---- RED (long) ----
        MOV     r0, #RED
        STR     r0, [r1]
        BL      update_signals
        LDR     r4, =DELAY_LONG
        BL      delay

        B       main_loop

;---------------------------------------
; delay: busy-wait, r4 holds &count word
;---------------------------------------
delay
        LDR     r5, [r4]           ; r5 = loop count
delay_loop
        SUBS    r5, r5, #1
        BNE     delay_loop
        BX      lr

;---------------------------------------
; update_signals: mirror PORT bits to
; SIG_RED/YEL/GRN (0/1 words) for LA
; Input: r0 = current PORT pattern
; Clobbers: r2, r3
;---------------------------------------
update_signals
        ; RED
        LDR     r2, =SIG_RED
        TST     r0, #RED
        MOVEQ   r3, #0
        MOVNE   r3, #1
        STR     r3, [r2]
        ; YEL
        LDR     r2, =SIG_YEL
        TST     r0, #YEL
        MOVEQ   r3, #0
        MOVNE   r3, #1
        STR     r3, [r2]
        ; GRN
        LDR     r2, =SIG_GRN
        TST     r0, #GRN
        MOVEQ   r3, #0
        MOVNE   r3, #1
        STR     r3, [r2]
        BX      lr

        ALIGN
PORT    DCD     0                  ; watched variable (bits 2:0)

; Individual logic-analyzer-friendly signals (0/1)
SIG_RED DCD     0
SIG_YEL DCD     0
SIG_GRN DCD     0

; Tune these if too fast/slow
DELAY_LONG   DCD     3000000
DELAY_SHORT  DCD     1200000

        END
