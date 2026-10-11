# Handwritten continue and break; t registers live only within the call-free loop.
.text
.globl main
.type main,@function
main:
    addi sp,sp,-16
    sd ra,8(sp)
    call getint
    li t0,0
    li t1,0
.Lheader:
    bge t0,a0,.Ldone
    addiw t0,t0,1
    li t2,2
    beq t0,t2,.Lheader
    li t2,5
    bgt t0,t2,.Ldone
    addw t1,t1,t0
    j .Lheader
.Ldone:
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
