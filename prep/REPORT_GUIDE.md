# 预备工作 · 实验报告全流程指南

> 目标：完成 PPT 要求的小题 1（编译流程研究）+ 小题 2（手写 LLVM IR / RISC-V 汇编），
> 并产出符合科技论文规范的 **PDF 调研报告**（建议 LaTeX，Overleaf 模板：
> https://www.overleaf.com/read/hnsjbjyknbdj ）
> 实验目录：`/home/ddn/biany/prep/`
> 研究载体：**PPT 示例的 C++ 版** `fact.cpp`（小题1）；SysY 风格示例（小题2）

---

## 阶段 0：组队与分工（报告开头必须写清）

- [ ] 两人组队，报助教备案（可跨班，之后不能改）
- [ ] 分工原则（PPT 规定）：
  - **小题 1**：两人**各自独立**完成实验、独立撰写（做一遍相同的流程即可）
  - **小题 2**：两个任务**一人负责一个**
    - 任务 A：LLVM IR 编程
    - 任务 B：RISC-V 汇编编程
  - 其余部分（摘要、引言、结论等）共同撰写
- [ ] 报告**各自独立提交**，内容 = 共同部分 + 自己完成的小题 1 + 小题 2 两个任务的结果

---

## 阶段 1：小题 1 实验（编译流程研究，以 fact.cpp 为例）

> 一键生成：`bash ~/biany/prep/scripts/gen_stages.sh`
> 实验时建议**逐条手动敲命令**并截图/记录，理解每个选项的作用。

### 1.1 预处理（预处理器做了什么）

```bash
cd ~/biany/prep/src
clang++ -E fact.cpp -o ../stages/fact/fact.i
wc -l fact.cpp ../stages/fact/fact.i     # 17 行 -> 30194 行
```

**记录素材**：`.i` 文件头尾对比截图；`#include <iostream>` 被展开成什么
（数万行 C++ 标准库声明）；注释是否还在。可做探索：
```bash
clang++ -E -DMYMACRO=100 fact.cpp -o - | tail -20   # -D 定义宏的效果
```

### 1.2 编译前端（编译器做了什么 · 上）

```bash
clang++ -emit-llvm -S fact.cpp -o ../stages/fact/fact.ll
```

**记录素材**：`fact.ll` 中 `alloca / load / store / icmp sle / br` 指令与源
程序的对应；`cin >> n` 变成对 `_ZNSirsERi`（`std::istream::operator>>`）
的调用、`cout << f` 变成 `_ZNSolsEi`——**C++ 符号修饰（name mangling）**；
全局量 `@_ZSt3cin / @_ZSt4cout` 与 `__cxx_global_var_init` 初始化函数。

**生成控制流图**（报告插图，已生成示例：`stages/fact/fact_main_cfg.png`）：

```bash
# 注意：-O0 的 IR 中 main 带 optnone 属性会被 opt 跳过，
# 需先生成去掉 optnone 的副本再画图
cd ~/biany/prep/src
clang++ -Xclang -disable-O0-optnone -emit-llvm -S fact.cpp -o ../stages/fact/fact_cfg.ll
opt -passes=dot-cfg -cfg-dot-filename-prefix=cfg_ -o /dev/null ../stages/fact/fact_cfg.ll
dot -Tpng cfg_.main.dot -o ../stages/fact/fact_main_cfg.png
```

### 1.3 编译后端（编译器做了什么 · 下）

```bash
g++ -S -O0 fact.cpp -o ../stages/fact/fact_gcc_x86.s                # x86 AT&T
riscv64-linux-gnu-g++ -S -O0 fact.cpp -o ../stages/fact/fact_rv64.s # RISC-V
```

**记录素材**：栈帧建立/销毁（`addi sp,sp,-48` ...）、`call _ZNSirsERi@plt`
的参数传递、x86 与 RISC-V 风格差异（CISC vs RISC）。

### 1.4 汇编（汇编器做了什么）

```bash
clang++ -c fact.cpp -o ../stages/fact/fact.o
file ../stages/fact/fact.o
objdump -d ../stages/fact/fact.o | head -40   # 反汇编，与 .s 对照
objdump -r ../stages/fact/fact.o              # 重定位信息
```

**记录素材**：`.o` 是二进制机器码（汇编指令 -> 操作码），C++ 符号尚未
定址（`call` 的目标是占位符，重定位信息可见）。

### 1.5 链接（链接器做了什么）

```bash
g++ -O0 fact.cpp -o ../stages/fact/fact_x86            # 动态链接（含 libstdc++）
riscv64-linux-gnu-g++ -static fact.cpp -o ../stages/fact/fact_rv64
ldd ../stages/fact/fact_x86                            # 看动态库依赖
file ../stages/fact/fact_rv64                          # statically linked
```

**记录素材**：`std::cin/std::cout` 等符号在链接时才解析到 libstdc++；
动态 vs 静态可执行文件大小差异巨大（`ls -l` 对比）。

### 1.6 运行验证（结果正确性）

```bash
echo 5 | ../stages/fact/fact_x86                    # 120（g++ 可执行）
echo 5 | lli ../stages/fact/fact.ll                 # 120（IR 直接解释执行）
echo 5 | ../stages/fact/fact_fromll_x86             # 120（由 IR 重编译）
echo 5 | qemu-riscv64 ../stages/fact/fact_rv64      # 120（RISC-V 模拟运行）
```

### 1.7 深入探索（PPT 明确期望，拉开分数差距）

已有现成数据（`opt_compare/SUMMARY.txt`），分析即可：

| 探索项 | 命令 | 现象（已生成） |
|---|---|---|
| 优化级别对 IR 的影响 | `clang++ -emit-llvm -S -O0/O1/O2/Os` | fact：111 → O1 163 → O2 250 → Os 152 行 |
| 优化级别对汇编的影响 | `riscv64-...-g++ -S -O*` | 156 → O1 97 → O2 146 → Os 89 行 |
| g++ vs clang++ 风格差异 | 对比 `fact_gcc_x86.s` / `fact_clang_x86.s` | 行数 133 vs 113 |
| 调试选项 | `g++ -g -O0 fact.cpp -o fact_g && objdump -d -S fact_g` | 汇编与源码行对应 |
| 微调程序 | 改 `int` 为 `long long` / 改循环方向，重新生成对比 | IR 类型 i32->i64 等 |

---

## 阶段 2：小题 2 实验（手写 IR / 汇编，两人各负责一个）

> 入门示例已就绪并验证通过（`manual/`，7! = 5040）：
> `fact_manual.ll`、`fact_manual_rv.s`、运行时库 `sylib.c`
> 注意：小题 2 要求**链接 SysY 运行时库**（getint/putint 等），
> 因此示例程序用 **SysY 风格**，而不是小题 1 的 cin/cout 版本。
> **正式要求**：自行设计**覆盖 SysY 特性**的示例程序，不能只用阶乘。

### 2.1 示例程序设计（两人先一起讨论定下来）

用 SysY 特性清单逐一覆盖（基础 track 要求）：

- [ ] 数值运算：+ - * / %、单目 +/-、关系 == > < >= <= !=、逻辑 && || !
- [ ] 语句：赋值、表达式语句、语句块、if/else、while、break/continue、return
- [ ] 函数：声明、调用、参数传递、递归（阶乘递归版是好例子）
- [ ] 常量与变量：const、初始化、作用域（嵌套块内同名遮蔽）
- [ ] 运行时库交互：getint/putint/putch/getch
- [ ] （竞赛 track 加分）数组、浮点

建议拆成 3~5 个小程序（如 `calc.sy`、`branch_loop.sy`、`func_rec.sy`），
每个聚焦一类特性，便于手写和验证。

### 2.2 任务 A：LLVM IR（负责同学）

1. 对照 `.sy` 源程序手写等价 `.ll`（参考 `manual/fact_manual.ll` 的风格：
   phi 节点 SSA 形式；也可用 alloca/load/store 形式，报告里可对比两种写法）
2. 编译运行验证：
   ```bash
   clang xxx_manual.ll sylib.c -o xxx_ll -Wno-override-module
   echo 输入 | ./xxx_ll        # 与预期结果比对
   ```
3. 加分演示：`llc -march=riscv64 -mattr=+m,+a,+f,+d,+c xxx.ll -o xxx.s`
   再交叉编译 + qemu 运行 → 体现"IR 是跨平台中间层"

### 2.3 任务 B：RISC-V 汇编（负责同学）

1. 对照同一批 `.sy` 源程序手写等价 `.s`（参考 `manual/fact_manual_rv.s`：
   栈帧、调用约定 a0-a7/ra/s0-s11、RVC 压缩指令可选）
2. 交叉编译 + 模拟运行：
   ```bash
   riscv64-linux-gnu-gcc -static xxx.s sylib.c -o xxx_rv
   echo 输入 | qemu-riscv64 ./xxx_rv
   ```
3. 对照组：`riscv64-linux-gnu-gcc -S -O0` 生成的汇编 vs 手写汇编，
   比较指令选择、冗余程度（手写通常更简洁，报告好素材）

### 2.4 等价性验证表（报告必备）

| 示例程序 | SysY 特性 | IR 运行结果 | 汇编运行结果 | 预期 | 是否一致 |
|---|---|---|---|---|---|
| fact | 循环/运算/库调用 | 5040 | 5040 | 5040 | ✅ |
| ... | ... | | | | |

---

## 阶段 3：报告撰写（LaTeX）

1. 打开 https://www.overleaf.com/read/hnsjbjyknbdj → copy project 成为自己的项目
   （本地模板骨架在 `D:\work\biany\LaTeX模板\`，已按 C++ 研究载体更新）
2. 两人共建整体框架，按下表分工填充（**开头写清分工**）：

```
题目、摘要、关键字                     —— 共同
1 引言（背景、任务、环境、分工）        —— 共同
   ├─ 实验环境表：WSL2 Ubuntu 22.04.5 LTS / g++ 11.4 / clang++ 14 /
   │   flex 2.6.4 / bison 3.8.2 / riscv64-linux-gnu-g++ 11.4 / qemu 7.0
2 编译流程研究（小题1，以 fact.cpp 为例）—— 各自独立撰写（内容不同）
   ├─ 2.1 预处理器  2.2 编译器(前端/后端)  2.3 汇编器  2.4 链接器
   └─ 2.5 深入探索（优化级别对比等）
3 LLVM IR 与汇编编程（小题2，SysY 风格）—— 分别撰写各自任务，结果合并展示
   ├─ 3.1 示例程序设计（共同）
   ├─ 3.2 LLVM IR 编程与验证（同学 A）
   ├─ 3.3 RISC-V 汇编编程与验证（同学 B）
   └─ 3.4 等价性验证汇总（共同）
4 结论（收获、对后续编译器实现模块的启示）  —— 共同
```

### 图表清单（直接可用）

- **图**：编译流程框图；fact.ll 控制流图（opt -dot-cfg）；.i/.ll/.s 关键片段截图
- **表**：实验环境表；各阶段产物行数表（`opt_compare/SUMMARY.txt`）；
  优化级别对比表；命令选项汇总表；小题 2 等价性验证表

---

## 阶段 4：检查与提交

- [ ] 报告结构完整：题目/摘要/关键字/引言/正文/结论
- [ ] 图表编号、引用、格式规范（科技论文要求）
- [ ] 开头有明确的分工说明
- [ ] 所有实验结果可复现（命令都在本指南/scripts 里）
- [ ] 导出 **PDF**，两人**各自提交**（小题 1 部分两人内容不同）
- [ ] 雨课堂提交时勿删 PPT 封面页要求的部分（按课程平台提示）
