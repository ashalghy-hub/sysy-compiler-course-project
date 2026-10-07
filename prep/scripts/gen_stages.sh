#!/bin/bash
# =============================================================
# 预备工作·小题1：批量生成编译各阶段产物
# 研究载体：PPT 示例程序（C++ 版）fact.cpp / fib.cpp
# 覆盖：预处理 .i -> LLVM IR .ll/.bc -> 汇编 .s -> 目标文件 .o -> 可执行
# 目标：x86_64(g++/clang++) 与 riscv64(交叉 g++)，另含 O0~Os 优化对比
# 用法: bash /home/ddn/biany/prep/scripts/gen_stages.sh
# =============================================================
set -e
PREP=/home/ddn/biany/prep
SRC=$PREP/src
OUT=$PREP/stages
OPT=$PREP/opt_compare
rm -rf "$OUT" "$OPT"
mkdir -p "$OUT" "$OPT"

for prog in fact fib; do
  echo "===================== $prog.cpp ====================="
  d="$OUT/$prog"
  mkdir -p "$d"
  src="$SRC/$prog.cpp"

  # 1) 预处理：宏展开、头文件展开、去注释
  clang++ -E "$src" -o "$d/$prog.i"
  # 2) LLVM IR（文本 .ll + 二进制 .bc）
  clang++ -emit-llvm -S "$src" -o "$d/$prog.ll"
  clang++ -emit-llvm -c "$src" -o "$d/$prog.bc"
  # 3) 汇编：x86_64(g++/clang++, AT&T) + RISC-V64(交叉 g++)
  g++     -S -O0 "$src" -o "$d/${prog}_gcc_x86.s"
  clang++ -S -O0 "$src" -o "$d/${prog}_clang_x86.s"
  riscv64-linux-gnu-g++ -S -O0 "$src" -o "$d/${prog}_rv64.s"
  # 4) 目标文件（汇编器产物）
  clang++ -c "$src" -o "$d/$prog.o"
  # 5) 可执行：x86 本地 + RISC-V 静态链接
  g++ -O0 "$src" -o "$d/${prog}_x86"
  riscv64-linux-gnu-g++ -static -O0 "$src" -o "$d/${prog}_rv64"
  # 6) 由 LLVM IR 直接编译为可执行（验证 IR 的完备性）
  clang++ "$d/$prog.ll" -o "$d/${prog}_fromll_x86"

  # 优化级别对比：LLVM IR + RISC-V 汇编（O0/O1/O2/Os）
  for lv in 0 1 2 s; do
    clang++ -emit-llvm -S -O$lv "$src" -o "$OPT/${prog}_O$lv.ll"
    riscv64-linux-gnu-g++ -S -O$lv "$src" -o "$OPT/${prog}_rv64_O$lv.s"
  done
done

# ---- 生成行数/尺寸汇总表（写报告可直接引用）----
SUM="$OPT/SUMMARY.txt"
{
  echo "== 各阶段产物行数汇总（$(date '+%F %T')）=="
  for prog in fact fib; do
    d="$OUT/$prog"
    echo
    echo "[$prog.cpp]"
    wc -l "$SRC/$prog.cpp" "$d/$prog.i" "$d/$prog.ll" "$d/${prog}_gcc_x86.s" "$d/${prog}_clang_x86.s" "$d/${prog}_rv64.s" 2>/dev/null
  done
  echo
  echo "== 优化级别对比（行数）=="
  for prog in fact fib; do
    echo
    echo "[$prog] LLVM IR:"
    wc -l "$OPT/${prog}_O0.ll" "$OPT/${prog}_O1.ll" "$OPT/${prog}_O2.ll" "$OPT/${prog}_Os.ll"
    echo "[$prog] RISC-V 汇编:"
    wc -l "$OPT/${prog}_rv64_O0.s" "$OPT/${prog}_rv64_O1.s" "$OPT/${prog}_rv64_O2.s" "$OPT/${prog}_rv64_Os.s"
  done
} > "$SUM"

echo
echo "全部生成完毕，产物目录："
echo "  $OUT/{fact,fib}/"
echo "  $OPT/  (优化对比 + SUMMARY.txt)"
