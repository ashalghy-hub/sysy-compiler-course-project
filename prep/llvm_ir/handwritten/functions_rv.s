# Handwritten recursive factorial and void emit. Each non-leaf saves ra.
.text
.globl factorial
.type factorial,@function
factorial:
    li t0,1
    ble a0,t0,.Lbase
    addi sp,sp,-16
    sd ra,8(sp)
    sd s0,0(sp)
    mv s0,a0
    addiw a0,a0,-1
    call factorial
    mulw a0,s0,a0
    ld s0,0(sp)
    ld ra,8(sp)
    addi sp,sp,16
    ret
.Lbase:
    li a0,1
    ret
.size factorial,.-factorial
.globl emit
.type emit,@function
emit:
    addi sp,sp,-16
    sd ra,8(sp)
    call putint
    li a0,10
    call putch
    ld ra,8(sp)
    addi sp,sp,16
    ret
.size emit,.-emit
.globl main
.type main,@function
main:
    addi sp,sp,-16
    sd ra,8(sp)
    call getint
    call factorial
    call emit
    li a0,0
    ld ra,8(sp)
    addi sp,sp,16
    ret
.size main,.-main
.section .note.GNU-stack,"",@progbits
