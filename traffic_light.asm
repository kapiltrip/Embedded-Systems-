        ;===============================================
        ; Traffic Light - ARM7 Big Endian (Keil Simulator)
        ; RED  -> PORT bit0
        ; YEL  -> PORT bit1
        ; GRN  -> PORT bit2
        ; View "PORT" in Logic Analyzer.
        ;===============================================

        ;---------- Vector at 0x00000000 ----------
        AREA    VECTORS, CODE, READONLY
        ENTRY
        B       __main                 ; Reset jumps to program entry

        ;---------- Program Code ----------
        AREA    PROGRAM, CODE, READONLY
        EXPORT  __main

RED     EQU     0x1                    ; bit 0
YEL     EQU     0x2                    ; bit 1
GRN     EQU     0x4                    ; bit 2

__main
        ; R1 will hold &PORT, R0 the pattern we write
        LDR     R1, =PORT
        MOV     R0, #0
        STR     R0, [R1]               ; clear PORT

MAIN_LOOP
        ; ---- GREEN (long) ----
        MOV     R0, #GRN
        STR     R0, [R1]
        LDR     R4, =DELAY_LONG
        BL      DELAY

        ; ---- YELLOW (short) ----
        MOV     R0, #YEL
        STR     R0, [R1]
        LDR     R4, =DELAY_SHORT
        BL      DELAY

        ; ---- RED (long) ----
        MOV     R0, #RED
        STR     R0, [R1]
        LDR     R4, =DELAY_LONG
        BL      DELAY

        B       MAIN_LOOP

;-----------------------------------------------
; DELAY: busy-wait. R4 holds address of count.
;-----------------------------------------------
DELAY
        LDR     R5, [R4]               ; R5 = loop count
DELAY_LOOP
        SUBS    R5, R5, #1
        BNE     DELAY_LOOP
        BX      LR

        ;---------- Data ----------
        AREA    DATASEC, DATA, READWRITE
        EXPORT  PORT                   ; easy to add in Logic Analyzer
        ALIGN
PORT    DCD     0                      ; watched variable

; tune these if too fast/slow on your PC
DELAY_LONG   DCD     3000000
DELAY_SHORT  DCD     1200000

        END 

