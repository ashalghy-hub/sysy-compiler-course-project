# Handwritten RV64GC, LP64D. All SysY integer arithmetic uses word operations.
.text
.globl main
.type main,@function
main:
    addi sp,sp,-32
    sd ra,24(sp)
    sd s0,16(sp)
    sd s1,8(sp)
    call getint
    mv s0,a0
    addiw s1,s0,3
    slliw s1,s1,1
    li t0,2
    divw t1,s0,t0
    subw s1,s1,t1
    li t0,3
    remw t1,s0,t0
    addw s1,s1,t1
    addiw a0,s1,7
    call putint
    li a0,10
    call putch
    negw a0,s0
    call putint
    li a0,10
    call putch
    mv a0,s0
    call putint
    li a0,10
    call putch
    seqz t0,s0
    addw a0,s0,t0
    call putint
    li a0,10
    call putch
    li a0,0
    ld s1,8(sp)
    ld s0,16(sp)
    ld ra,24(sp)
    addi sp,sp,32
    ret
.size main,.-main
.section .note.GNU-stack,"",@progbits
