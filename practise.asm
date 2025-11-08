        AREA    EXP11, CODE, READONLY
        EXPORT  _start
        ENTRY

; Computes expression (a*x^2 + b*y^2) and (6(x+y) + 2z + 4) using literal data.
; Results are written back to RESULT_A and RESULT_B so they can be inspected in memory.
_start
        ; ---- Expression A: a*x^2 + b*y^2 ----
        ;we will implement a*x^2 in this , one first 

        ldr r0,=A_VAL
        ldr r0,[r0]
        ldr r1,=X_VAL
        ldr r1,[r1]
        mul r2,r1,r1
        mul r2,r2,r0
        ; now , we can proceed, for creating the eqn , b*y^2
        ldr r3,=B_VAL
        ldr r3,[r3]
        ldr r4,=Y_VAL
        ldr r4,[r4]
        mul r5,r4,r4
        mul r5,r3,r5
        add r6,r2,r5
        ldr r7,=RESULT_A
        str r6,[r7]
        ; ---- Expression B: 6(x + y) + 2z + 4 ----
        ldr r0,=X_VAL
        ldr ro,[ro]
        ldr r1,Y_VAL
        ldr r1,[r1]
        ldr r2,Z_VAL
        ldr r2,[r2]
        add r0,r0,r1
        mov r3,#6
        mul r0,r3,r0
        add r0,r0,r3,lsl #1 , 
        ;to add 4
        add r0,r0,#4
        
        ldr r4,=RESULT_B
        str r0,r4


stop
        B       stop              ; simple halt loop for debugger

        ALIGN
A_VAL   DCD 2
B_VAL   DCD 3
X_VAL   DCD 4
Y_VAL   DCD 5
RESULT_A DCD 0
X2_VAL  DCD 1
Y2_VAL  DCD 2
Z_VAL   DCD 3
RESULT_B DCD 0
        END