        AREA    PROGRAM, CODE, READONLY
        ENTRY

MAIN
        ; Load external addresses from data labels (no '=' immediate)
        LDR     R1, DIVIDEND_PTR    ; R1 = 0x00003020 (dividend address)
        LDR     R2, DIVISOR_PTR     ; R2 = 0x00003024 (divisor address)

        ; Read operands from memory
        LDR     R3, [R1]            ; R3 = dividend
        LDR     R4, [R2]            ; R4 = divisor
        MOV     R5, #0              ; R5 = quotient

        ; Handle divide-by-zero: leave quotient=0, remainder=dividend
        CMP     R4, #0
        BEQ     STORE_RESULTS

LOOP
        CMP     R3, R4
        BLT     STORE_RESULTS       ; if dividend < divisor, exit
        SUB     R3, R3, R4          ; dividend -= divisor
        ADD     R5, R5, #1          ; quotient++
        B       LOOP

STORE_RESULTS
        ; Write results back to memory so you can view them
        LDR     R6, QUOTIENT_PTR    ; R6 = 0x00003028 (quotient out)
        STR     R5, [R6]
        LDR     R6, REMAINDER_PTR   ; R6 = 0x0000302C (remainder out)
        STR     R3, [R6]

DONE
        B       DONE                ; R5=quotient, R3=remainder

        AREA    PROGRAM, DATA, READONLY
DIVIDEND_PTR   DCD 0x00003020       ; input: dividend address
DIVISOR_PTR    DCD 0x00003024       ; input: divisor  address
QUOTIENT_PTR   DCD 0x00003028       ; output: quotient address
REMAINDER_PTR  DCD 0x0000302C       ; output: remainder address
        
        ;
        ; Memory map range (Read + Write): 0x00003000, 0x0000302F
        ;   Alternative roomy range:      0x00003000, 0x000030FF
        ; Example memory contents (big-endian) and binaries
        ; Inputs you set before running:
        ;   [0x00003020] dividend = 0x0000012C (300)
        ;       bytes  : 00 00 01 2C
        ;       binary : 00000000 00000000 00000001 00101100
        ;   [0x00003024] divisor  = 0x0000000F (15)
        ;       bytes  : 00 00 00 0F
        ;       binary : 00000000 00000000 00000000 00001111
        ; Outputs written after running:
        ;   [0x00003028] quotient = 0x00000014 (20)
        ;       bytes  : 00 00 00 14
        ;       binary : 00000000 00000000 00000000 00010100
        ;   [0x0000302C] remainder = 0x00000000 (0)
        ;       bytes  : 00 00 00 00
        ;       binary : 00000000 00000000 00000000 00000000
        END
