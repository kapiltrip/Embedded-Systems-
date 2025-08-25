        AREA    EXP7, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        LDR     r0, =DIVIDEND   ;the address of dividend in ro 
        LDR     r0, [r0]        ;dereferences the pointer stored in r0 and loads , the address data of r0
        LDR     r1, =DIVISOR
        LDR     r1, [r1]
        MOV     r2, #0          ; quotient (how many times, should i divide , i.e the count )
        CMP     r1, #0
        BEQ     done            ;this is a reference 1

loop
        CMP     r0, r1
        BLT     done             ;this is reference 2 BLT signal -> done is the target 
        SUB     r0, r0, r1             
        ADD     r2, r2, #1      ;increasing the quotient 
        B       loop

done                            ;loop will start from here, if CMP r1 , #0 will give 1 i.e z flag set
                                ;here there is the definition of done , which is referred earlier .
        LDR     r3, =QUOTIENT
        STR     r2, [r3]
        LDR     r3, =REMAINDER
        STR     r0, [r3]

stop
        B       stop

        ALIGN
DIVIDEND DCD 20 
DIVISOR  DCD 3
QUOTIENT DCD 0
REMAINDER DCD 0
        END
