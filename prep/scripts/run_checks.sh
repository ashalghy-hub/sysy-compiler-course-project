#!/bin/bash
# =============================================================
# 预备工作：端到端验证（小题1 产物 + 小题2 手写 IR/汇编）
# 研究载体：PPT 示例程序（C++ 版）fact.cpp / fib.cpp
# 每个用例都断言期望输出，全部 PASS 才算环境/产物正确
# 用法: bash /home/ddn/biany/prep/scripts/run_checks.sh
# =============================================================
PREP=/home/ddn/biany/prep
OUT=$PREP/stages
MAN=$PREP/manual
export PATH=/opt/qemu/bin:$PATH   # 使用 7.0.0 源码编译版（与实验环境一致）
PASS=0; FAIL=0

check() { # check <描述> <期望> <实际>
  if [ "$2" = "$3" ]; then
    echo "PASS  $1 (=$2)"; PASS=$((PASS+1))
  else
    echo "FAIL  $1 期望[$2] 实际[$3]"; FAIL=$((FAIL+1))
  fi
}

echo "===== 1) 原生 x86 可执行（g++ -O0 产物，cin/cout）====="
check "fact x86, n=5"  "120" "$(echo 5 | $OUT/fact/fact_x86)"
check "fib  x86, n=6"  "0 1 1 2 3 5 8" "$(echo 6 | $OUT/fib/fib_x86 | tr '\n' ' ' | sed 's/ $//')"

echo "===== 2) clang++ 生成的 LLVM IR：lli 解释执行 & 重编译 ====="
check "lli fact.ll, n=5" "120" "$(echo 5 | lli $OUT/fact/fact.ll)"
check "fact.ll 重编译运行, n=5" "120" "$(echo 5 | $OUT/fact/fact_fromll_x86)"

echo "===== 3) qemu-riscv64 运行交叉编译产物 ====="
check "qemu-riscv64 fact_rv64, n=5" "120" "$(echo 5 | qemu-riscv64 $OUT/fact/fact_rv64)"
check "qemu-riscv64 fib_rv64,  n=6" "0 1 1 2 3 5 8" "$(echo 6 | qemu-riscv64 $OUT/fib/fib_rv64 | tr '\n' ' ' | sed 's/ $//')"

echo "===== 4) 小题2：手写 LLVM IR + SysY 运行时库 ====="
clang "$MAN/fact_manual.ll" "$MAN/sylib.c" -o "$MAN/fact_manual_ll" -Wno-override-module 2>/dev/null
check "手写 IR + sylib, n=7" "5040" "$(echo 7 | $MAN/fact_manual_ll)"

echo "===== 5) 小题2：手写 IR --llc--> RISC-V 汇编 --> qemu ====="
llc -march=riscv64 -mattr=+m,+a,+f,+d,+c "$MAN/fact_manual.ll" -o "$MAN/fact_manual_fromll_rv.s"
riscv64-linux-gnu-gcc -static "$MAN/fact_manual_fromll_rv.s" "$MAN/sylib.c" -o "$MAN/fact_manual_fromll_rv"
check "手写IR->RISC-V, n=7" "5040" "$(echo 7 | qemu-riscv64 $MAN/fact_manual_fromll_rv)"

echo "===== 6) 小题2：手写 RISC-V 汇编 + SysY 运行时库 ====="
riscv64-linux-gnu-gcc -static "$MAN/fact_manual_rv.s" "$MAN/sylib.c" -o "$MAN/fact_manual_rv"
check "手写 RISC-V 汇编, n=7" "5040" "$(echo 7 | qemu-riscv64 $MAN/fact_manual_rv)"

echo
echo "================== 结果: PASS=$PASS FAIL=$FAIL =================="
[ $FAIL -eq 0 ] && echo "全部通过！" || echo "有失败项，请检查"
