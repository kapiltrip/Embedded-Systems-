AREA    HEX_TO_ASCII, CODE, READONLY
        ; Experiment 5: convert an 8-hex-digit number into ASCII characters
        ; as stated in the lab list. The loop peels off the top nibble, turns
        ; it into '0'..'9' or 'A'..'F', and streams bytes to an output buffer.
        ; R0 is shifted left each pass so the next nibble becomes the top four
        ; bits—simple and easy to trace for beginners.
        EXPORT  _start
        ENTRY

_start
        LDR     R1, =IN_WORD         ; pointer to the input word
        LDR     R0, [R1]             ; R0 = input value (e.g., 0x4AF23BCD)

        LDR     R2, =0x40000000      ; write ASCII bytes starting here

        MOV     R3, #8               ; 8 hex digits to produce

convert_loop
        MOV     R4, R0, LSR #28      ; grab top nibble into R4

        CMP     R4, #9               ; 0-9 become '0'..'9'
        ADDLE   R4, R4, #'0'
        ADDGT   R4, R4, #('A' - 10)  ; 10-15 become 'A'..'F'

        STRB    R4, [R2], #1         ; store ASCII and advance pointer

        MOV     R0, R0, LSL #4       ; bring next nibble to the top
        SUBS    R3, R3, #1
        BNE     convert_loop

        MOV     R4, #0               ; null-terminate string for readability
        STRB    R4, [R2]

halt    B       halt

        AREA    HEX_RO_DATA, DATA, READONLY
        ALIGN

IN_WORD DCD     0x4AF23BCD

        END
