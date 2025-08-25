; Experiment 8 – Bubble sort arrays in ascending and descending order.
; Instructions explained:
;   LDR   - loads base addresses of arrays.
;   MOV   - initializes loop counters.
;   SUBS  - decrements pass counters and sets flags.
;   ADD   - calculates element addresses using index * 4 (LSL #2).
;   LDR/STR - fetch and store array elements.
;   CMP   - compares adjacent elements.
;   BLE/BGE - branch when elements already in correct order.
;   STR   - swap values when comparison requires it.
;   BLT/B - control inner and outer loops.
;   B     - final halt loop.

        AREA    EXP8, CODE, READONLY
        EXPORT  _start
        ENTRY

_start
        ; ----- A) ascending order -----
        LDR     r0, =ASC_ARRAY
        MOV     r1, #5            ; number of elements
outerA
        ; Each outer pass reduces unsorted tail.
        SUBS    r1, r1, #1
        BEQ     doneA
        MOV     r2, #0            ; inner index
innerA
        ; Compute address of current element.
        ADD     r3, r0, r2, LSL #2
        ; Load current and next elements.
        LDR     r4, [r3]
        LDR     r5, [r3, #4]
        ; If already <=, skip swap.
        CMP     r4, r5
        BLE     noswapA
        ; Swap using two stores.
        STR     r5, [r3]
        STR     r4, [r3, #4]
noswapA
        ; Advance inner index and loop.
        ADD     r2, r2, #1
        CMP     r2, r1
        BLT     innerA
        B       outerA

doneA
        ; ----- B) descending order -----
        LDR     r0, =DESC_ARRAY
        MOV     r1, #5
outerD
        SUBS    r1, r1, #1
        BEQ     doneD
        MOV     r2, #0
innerD
        ADD     r3, r0, r2, LSL #2
        LDR     r4, [r3]
        LDR     r5, [r3, #4]
        ; For descending, swap when next > current.
        CMP     r4, r5
        BGE     noswapD
        STR     r5, [r3]
        STR     r4, [r3, #4]
noswapD
        ADD     r2, r2, #1
        CMP     r2, r1
        BLT     innerD
        B       outerD

doneD
stop
        ; Halt program.
        B       stop

        ALIGN
ASC_ARRAY  DCD 5,1,4,2,3
DESC_ARRAY DCD 1,3,2,5,4
        END
