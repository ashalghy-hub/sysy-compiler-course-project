# Handwritten 2x3 array, array parameter, float ABI and conversions.
.section .rodata
.balign 4
.Lf_two:  .float 2.0
.Lf_onehalf: .float 1.5
.Lf_half: .float 0.5
.text
.globl row_sum
.type row_sum,@function
row_sum:
    li t0,12
    mul t0,a1,t0
    add t0,a0,t0
    li t1,0
    li a0,0
.Lrow:
    li t2,3
    bge t1,t2,.Lrow_done
    lw t3,0(t0)
    addw a0,a0,t3
    addi t0,t0,4
    addiw t1,t1,1
    j .Lrow
.Lrow_done:
    ret
.size row_sum,.-row_sum
.globl twice
.type twice,@function
twice:
    la t0,.Lf_two
    flw ft0,0(t0)
    fmul.s fa0,fa0,ft0
    ret
.size twice,.-twice
.globl main
.type main,@function
main:
    addi sp,sp,-64
    sd ra,56(sp)
    sd s0,48(sp)
    sd s1,40(sp)
    li t0,1
    sw t0,0(sp)
    li t0,2
    sw t0,4(sp)
    li t0,3
    sw t0,8(sp)
    li t0,4
    sw t0,12(sp)
    sw zero,16(sp)
    sw zero,20(sp)
    call getint
    fcvt.s.w fa0,a0
    la t0,.Lf_onehalf
    flw ft0,0(t0)
    fmul.s fa0,fa0,ft0
    la t0,.Lf_half
    flw ft0,0(t0)
    fadd.s fa0,fa0,ft0
    call twice
    fsw fa0,24(sp)
    fcvt.w.s s1,fa0,rtz
    mv a0,sp
    li a1,0
    call row_sum
    mv s0,a0
    mv a0,sp
    li a1,1
    call row_sum
    addw a0,s0,a0
    call putint
    li a0,10
    call putch
    mv a0,s1
    call putint
    li a0,10
    call putch
    flw ft0,24(sp)
    fmv.w.x ft1,zero
    flt.s a0,ft1,ft0
    call putint
    li a0,10
    call putch
    li a0,0
    ld s1,40(sp)
    ld s0,48(sp)
    ld ra,56(sp)
    addi sp,sp,64
    ret
.size main,.-main
.section .note.GNU-stack,"",@progbits
