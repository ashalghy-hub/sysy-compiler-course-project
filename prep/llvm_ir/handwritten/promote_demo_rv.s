# Handwritten register loop for the memory-form IR comparison.
.text
.globl main
.type main,@function
main:
    addi sp,sp,-16
    sd ra,8(sp)
    call getint
    li t0,0
    li t1,0
.Lsum:
    bge t0,a0,.Lexit
    addw t1,t1,t0
    addiw t0,t0,1
    j .Lsum
.Lexit:
    mv a0,t1
    call putint
    li a0,10
    call putch
    li a0,0
    ld ra,8(sp)
    addi sp,sp,16
    ret
.size main,.-main
.section .note.GNU-stack,"",@progbits
