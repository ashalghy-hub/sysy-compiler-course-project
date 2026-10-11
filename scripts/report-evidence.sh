#!/usr/bin/env bash
# Run in WSL Ubuntu. Output comes from real files and real tool executions.
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
mkdir -p build/report-evidence
mode=${1:-help}
PS4='+ '
case "$mode" in
  short)
    set -x
    opt -passes=verify -disable-output prep/llvm_ir/short_circuit.ll
    sed -n '14,35p' prep/llvm_ir/short_circuit.ll
    clang prep/llvm_ir/short_circuit.ll prep/manual/sylib.c -Wno-override-module -o build/report-evidence/short
    printf '0\n' | build/report-evidence/short
    printf '4\n' | build/report-evidence/short
    ;;
  mem2reg)
    set -x
    opt -S -passes=mem2reg prep/llvm_ir/promote_demo.ll -o build/report-evidence/promoted.ll
    grep -nE '\b(alloca|load|store|phi)\b' prep/llvm_ir/promote_demo.ll build/report-evidence/promoted.ll
    clang build/report-evidence/promoted.ll prep/manual/sylib.c -Wno-override-module -o build/report-evidence/promoted
    printf '10\n' | build/report-evidence/promoted
    ;;
  rv)
    set -x
    sed -n '5,21p' prep/llvm_ir/handwritten/functions_rv.s
    riscv64-linux-gnu-gcc -static -march=rv64gc -mabi=lp64d prep/llvm_ir/handwritten/functions_rv.s prep/manual/sylib.c -o build/report-evidence/functions_rv
    printf '7\n' | qemu-riscv64 build/report-evidence/functions_rv
    ;;
  mlir)
    python3 prep/mlir/run_lowering.py > build/report-evidence/mlir-run.log
    set -x
    cat prep/mlir/results/01_scf.mlir
    cat prep/mlir/results/02_cf.mlir
    ;;
  results)
    set -x
    python3 prep/llvm_ir/verify.py
    python3 prep/mlir/run_lowering.py > build/report-evidence/mlir-run.log
    tail -n 1 build/report-evidence/mlir-run.log
    build/prep-mlir/vecadd
    ;;
  *)
    printf 'Usage: bash scripts/report-evidence.sh {short|mem2reg|rv|mlir|results}\n'
    exit 2
    ;;
esac
set +x
printf '\nCompleted successfully (exit status 0).\n'
