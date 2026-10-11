# 袁煜杰负责的 LLVM IR 实验

本目录为预备作业“基本要求 2”中的 LLVM IR 编程部分。`.sy` 和 `.ll` 均为本次设计和手写；`results/*_O2.ll`、`*_generated_rv_*.s` 是工具生成的对照结果，**不是手写汇编**。搭档原有 `prep/manual/` 文件保留。

## 复现

在 Linux 或 Ubuntu WSL 中，从任意目录执行：

```sh
python3 prep/llvm_ir/verify.py
```

需要 Clang/LLVM（llvm-as、llvm-link、opt、llc、lli）、Python 3、RISC-V Linux GCC 和 qemu-riscv64。脚本自动根据自己的位置找到项目，不依赖 `/home/ddn/biany`，遇到编译、运行、超时或输出错误会返回失败。中间二进制写入被忽略的 `build/prep-llvm-ir/`，文本 IR/汇编和日志保存在 `results/`。

## 覆盖与真实验证结果

| 示例 | 覆盖 | 输入 | 检查数 |
| --- | --- | --- | ---: |
| arithmetic | 加减乘除余数、单目正负、const、作用域遮蔽、`!` 转 int | -7,-1,0,1,7,12 | 42 |
| short_circuit | if/else、`&&`/`||`、受保护除法、全局副作用、自定义函数 | -3,0,1,4,5,12 | 42 |
| loop_control | while、continue、break、多条回边的 phi | -2,0,1,2,5,8 | 42 |
| functions | 递归、参数、int/void 返回、函数调用 | 0,1,5,7,12 | 35 |
| array_float | 二维数组、隐式补零、数组参数、float 运算/函数、隐式转换 | -3,-1,0,2,7 | 35 |
| promote_demo | alloca/load/store 到 mem2reg/phi 的结构变化 | -3,0,1,5,10 | 40 |

每个输入比较七条执行路径：C 参考本机/RV64、手写 IR 的本机/RV64（原始与 O2）、链接运行库后的 lli；另外 mem2reg 结果独立测五项。2026-10-11 本次执行 **236/236 通过**；完整 stdout 和退出码见 `results/latest.json`，命令和诊断见 `results/commands.json`。

源程序特性与 C 语义相同，参考编译用命令行 `-include runtime.h`，不在真实 `.sy` 中加头文件。负数除法 oracle 采用向零截断，余数由 `a - trunc(a/b)*b` 求出。浮点输入选择可精确表示的小整数，避免把舍入容差或 int 溢出混入实验。

## 关键结论与边界

- 短路测试 n=0 时不会执行 `12/n` 或 touch，hits=0；非零时 touch 一次。只写 `and`/`or` 不能表达这种带副作用的短路语义。
- 循环 phi 为每个实际前驱分别提供值；continue 回到 header，break 进入 done。LLVM verifier 检查 IR 结构，运行对照检查可观测行为。
- mem2reg 前：2 alloca、3 load、4 store、0 phi；之后：0 alloca/load/store、2 phi。本实验使用现成 LLVM pass 观察变化，**不代表实现了编译器的 mem2reg 模块**。
- 二维数组的 GEP 按 `[3 x i32]` 行类型寻址，第二行后两个元素显式补零；float 使用 sitofp、fmul、fadd、fptosi、fcmp。
- 本次链接搭档的最小教学 `sylib.c`；没有取得课程正式库。该库的 getint/putint/putch 足以支撑本组示例，但不声称正式运行时 ABI 已全部验收。正式库取得后应重新运行。
- 不涵盖用户输入失败、溢出、除零程序、任意数组越界等未定义情形；阶乘限定 0–12。
- 新示例对应的**手写** RISC-V 汇编由搭档负责；这里的自动降低只能证明 IR 可进入目标工具链，不能替代搭档的作业部分。

参考：[LLVM Language Reference](https://llvm.org/docs/LangRef.html)、本地 SysY 语言定义与文法补充说明。完整报告在 `LaTeX模板/袁煜杰-LLVMIR与MLIR实验报告.tex`，共同报告在 `LaTeX模板/main.tex`。
