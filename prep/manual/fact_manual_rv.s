# ============================================================
# 手写 RISC-V (RV64) 汇编：阶乘（小题2）
# 与 SysY 源程序等价：
#   int main() {
#       int n = getint();
#       int i = 2, f = 1;
#       while (i <= n) { f = f * i; i = i + 1; }
#       putint(f); putch(10);
#       return 0;
#   }
# 调用约定：a0-a7 传参，a0 返回值；s0-s11 被调者保存
# 构建：riscv64-linux-gnu-gcc -static fact_manual_rv.s sylib.c -o fact_manual_rv
# 运行：echo 7 | qemu-riscv64 ./fact_manual_rv   -> 5040
# ============================================================
    .text
    .globl  main
    .type   main, @function
main:
    addi    sp, sp, -32         # 建立栈帧（16 字节对齐）
    sd      ra, 24(sp)          # 保存返回地址与被调者保存寄存器
    sd      s0, 16(sp)
    sd      s1, 8(sp)
    sd      s2, 0(sp)

    call    getint              # a0 = n
    mv      s0, a0              # s0 = n
    li      s1, 2               # s1 = i = 2
    li      s2, 1               # s2 = f = 1

.Lloop:
    bgt     s1, s0, .Ldone      # while (i <= n)，否则跳出
    mul     s2, s2, s1          # f = f * i
    addi    s1, s1, 1           # i = i + 1
    j       .Lloop

.Ldone:
    mv      a0, s2              # putint(f)
    call    putint
    li      a0, 10              # putch('\n')
    call    putch
    li      a0, 0               # return 0

    ld      ra, 24(sp)          # 恢复现场，拆除栈帧
    ld      s0, 16(sp)
    ld      s1, 8(sp)
    ld      s2, 0(sp)
    addi    sp, sp, 32
    ret
    .size   main, .-main
