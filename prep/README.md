# 预备工作（小题1 + 小题2）实验目录

> 上机大作业模块 1：了解编译器、LLVM IR 编程及汇编编程（5 分）
> 研究载体：**PPT 示例程序（C++ 版）fact.cpp / fib.cpp**
> 目标后端：**RISC-V 64**（riscv64-linux-gnu-g++ 11.4.0 + qemu-riscv64 7.0.0，/opt/qemu/bin）

## 目录结构

新增袁煜杰部分见 [llvm_ir/](llvm_ir/README.md) 和 [mlir/](mlir/README.md)，工具版本与本页记录的搭档环境分别保留。六组扩展示例已补齐同源手写 IR 与手写汇编，八条执行路径加 mem2reg 共通过 269 项检查。

```
prep/
├── src/                     # 源程序（PPT 示例，C++ 版）
│   ├── fact.cpp             #   阶乘：cin >> n; ... cout << f << endl;
│   └── fib.cpp              #   斐波那契数列
├── scripts/
│   ├── gen_stages.sh        # 一键生成所有阶段产物
│   └── run_checks.sh        # 一键端到端验证（9 项断言）
├── stages/                  # 小题1：各阶段产物
│   ├── fact/  fib/
│   │   ├── fact.i                 # ① 预处理（clang++ -E）
│   │   ├── fact.ll / fact.bc      # ② LLVM IR（文本/二进制）
│   │   ├── fact_gcc_x86.s         # ③ x86 汇编（g++，AT&T）
│   │   ├── fact_clang_x86.s       # ③ x86 汇编（clang++）
│   │   ├── fact_rv64.s            # ③ RISC-V 汇编（riscv64-linux-gnu-g++）
│   │   ├── fact.o                 # ④ 目标文件（clang++ -c）
│   │   ├── fact_x86               # ⑤ x86 可执行（g++）
│   │   ├── fact_rv64              # ⑤ RISC-V 可执行（静态链接）
│   │   ├── fact_fromll_x86        # ⑥ 由 .ll 直接重编译的可执行
│   │   ├── fact_cfg.ll            # 去掉 optnone 的 IR 副本（画 CFG 图用）
│   │   └── fact_main_cfg.png      # main 函数控制流图（graphviz 生成，报告插图）
│   └── ...
├── opt_compare/             # 优化级别对比 O0/O1/O2/Os
│   ├── fact_O*.ll           #   各优化级别的 LLVM IR
│   ├── fact_rv64_O*.s       #   各优化级别的 RISC-V 汇编
│   └── SUMMARY.txt          #   行数汇总（报告可直接引用）
└── manual/                  # 小题2：手写 IR / 汇编（SysY 风格示例）
    ├── sylib.c              #   最小 SysY 运行时库（getint/putint/...）
    ├── fact_manual.ll       #   手写 LLVM IR（含 phi 节点的标准 SSA）
    ├── fact_manual_rv.s     #   手写 RISC-V 汇编
    ├── fact_manual_fromll_rv.s  # 手写 IR 经 llc 生成的 RISC-V 汇编
    └── (fact_manual_ll / fact_manual_rv / fact_manual_fromll_rv 可执行)
```

## 常用命令

```bash
# 重新生成全部阶段产物
bash ~/biany/prep/scripts/gen_stages.sh

# 端到端验证（9 项全部 PASS 即正确）
bash ~/biany/prep/scripts/run_checks.sh
```

## 与报告（小题）的对应关系

**小题1：以 GCC/G++ 与 LLVM/Clang++ 为研究对象探究编译各阶段**

| 阶段 | 命令 | 产物 | 观察点 |
|---|---|---|---|
| 预处理 | `clang++ -E` | `.i` | 宏展开、iostream 头文件注入（17 行 → 3 万+ 行）、注释删除 |
| 编译(前端) | `clang++ -emit-llvm -S` | `.ll` | 类型系统、alloca/load/store（非 SSA）、控制流、C++ 符号修饰（mangled name） |
| 编译(后端) | `g++ -S` / `riscv64-linux-gnu-g++ -S` | `.s` | 指令选择、栈帧、调用约定；x86 vs RISC-V 对比 |
| 汇编 | `clang++ -c` | `.o` | `file`/`objdump -d` 反汇编查看 |
| 链接 | `g++` / `...-g++ -static` | 可执行 | 静态 vs 动态链接（qemu -L 对比）；链接 libstdc++ |
| IR 完备性 | `clang++ fact.ll` | 可执行 | 由 IR 直接重建可执行程序 |

加分探索（PPT 期望）：`opt_compare/` 里 O0→O2 的 IR/汇编行数变化；
可再加 `-g` 调试选项、`-fno-stack-protector`、`-march=rv64gc` 等观察变化。

**小题2：LLVM IR 编程 & 汇编编程（链接 SysY 运行时库）**

小题2 要求链接 SysY 运行时库（getint/putint 等），故示例程序为
**SysY 风格**（与小题1 的 C++ 研究载体不同）：

- `manual/fact_manual.ll`：手写 LLVM IR（phi 节点 SSA 形式），
  `clang fact_manual.ll sylib.c` 链接运行库后执行 → 7! = 5040
- `manual/fact_manual_rv.s`：手写 RV64 汇编（标准调用约定），
  交叉编译 + qemu 运行 → 7! = 5040
- 进阶演示：手写 IR 经 `llc -march=riscv64 -mattr=+m,+a,+f,+d,+c`
  自动降到 RISC-V 汇编再运行 → 同样 5040（体会 IR 作为中间层的作用）

## 注意事项

- 手写汇编/IR 仅为**入门示例**，小题2 正式要求是：自行设计覆盖 SysY
  特性的示例程序（各类运算、分支、循环、函数等），手写等价 IR 和汇编。
  建议在本目录 `manual/` 下继续扩充。
- 正式《SysY 运行时库》下发后，替换 `manual/sylib.c` 重新验证即可。
- Windows 侧访问路径：`\\wsl.localhost\Ubuntu-20.04\home\ddn\biany\prep`
