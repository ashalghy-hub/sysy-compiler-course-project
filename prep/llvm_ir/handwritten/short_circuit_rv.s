# Handwritten short-circuit branches. touch is called only for nonzero n.
.bss
.balign 4
hits:
    .zero 4
.text
.globl touch
.type touch,@function
touch:
    la t0,hits
    lw t1,0(t0)
    addiw t1,t1,1
    sw t1,0(t0)
    li a0,1
    ret
.size touch,.-touch
.globl main
.type main,@function
main:
    addi sp,sp,-16
    sd ra,8(sp)
    sd s0,0(sp)
    call getint
    mv s0,a0
    li a0,0
    beqz s0,.Land_done
    li t0,12
    divw t0,t0,s0
    li t1,2
    slt a0,t1,t0
.Land_done:
    call putint
    li a0,10
    call putch
    beqz s0,.Lor_true
    call touch
    bnez a0,.Lor_true
    li a0,3
    j .Lor_done
.Lor_true:
    li a0,2
.Lor_done:
    call putint
    li a0,10
    call putch
    la t0,hits
    lw a0,0(t0)
    call putint
    li a0,10
    call putch
    li a0,0
    ld s0,0(sp)
    ld ra,8(sp)
    addi sp,sp,16
    ret
.size main,.-main
.section .note.GNU-stack,"",@progbits
