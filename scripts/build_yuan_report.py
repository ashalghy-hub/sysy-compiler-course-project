"""Build the standalone report from the shared, maintained chapter fragments."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPORT = ROOT / "LaTeX模板"
BIB = r"""
\newpage
\begin{thebibliography}{9}
\bibitem{riscvabi} RISC-V International. RISC-V ABIs Specification. \url{https://riscv-non-isa.github.io/riscv-elf-psabi-doc/}.
\bibitem{llvmref} LLVM Project. LLVM Language Reference Manual. \url{https://llvm.org/docs/LangRef.html}.
\bibitem{ascendexample} AscendNPU IR. 快速入门示例. \url{https://ascendnpu-ir.gitcode.com/zh_cn/sources/introduction/quick_start/examples_zh.html}.
\bibitem{ascendarchitecture} AscendNPU IR. 架构介绍. \url{https://ascendnpu-ir.gitcode.com/zh_cn/sources/introduction/architecture_zh.html}.
\bibitem{hivmref} AscendNPU IR. HIVM Dialect. \url{https://ascendnpu-ir.gitcode.com/zh_cn/sources/developer_guide/dialects/HIVMDialect.html}.
\bibitem{scfref} MLIR Project. SCF Dialect. \url{https://mlir.llvm.org/docs/Dialects/SCFDialect/}.
\bibitem{mlirpasses} MLIR Project. Passes. \url{https://mlir.llvm.org/docs/Passes/}.
\end{thebibliography}
"""

def build():
    source = r"""\documentclass[UTF8,a4paper,11pt]{ctexart}
\usepackage[margin=2.5cm]{geometry}
\usepackage{amsmath,array,booktabs,xcolor,listings}
\usepackage[colorlinks=true,linkcolor=black,urlcolor=blue,citecolor=black]{hyperref}
\usepackage{fancyhdr}
\setlength{\headheight}{15pt}
\pagestyle{fancy}\fancyhf{}\lhead{LLVM IR、RISC-V 与 MLIR 预备实验}\rhead{袁煜杰}\cfoot{\thepage}
\lstset{basicstyle=\small\ttfamily,breaklines=true,frame=single,columns=fullflexible,keepspaces=true}
\title{编译系统上机大作业预备工作\\LLVM IR 与 RISC-V 编程及 MLIR 进阶探索}
\author{袁煜杰}
\date{2026年10月11日}
\raggedbottom
\setlength{\emergencystretch}{2em}
\begin{document}
\maketitle
\begin{abstract}
本报告记录基本要求二的 LLVM IR 与 RISC-V 汇编编程及进阶 MLIR 探索。
设计六组 SysY 程序并手写 LLVM IR 和 RISC-V 汇编，使用结构验证、独立预期结果、参考程序、
本机执行及 RISC-V 模拟执行检查语义；33 组输入的八条执行路径和 mem2reg 对照共 269 项检查全部通过。
进阶部分研究 AscendNPU IR 官方文档，另实际执行上游 MLIR 的
Linalg、SCF、CF、LLVM 方言降低以及 LLVM IR 翻译，VecAdd 的 16 个元素全部正确。
当前未配置 Ascend NPU 与 CANN，因此专有方言路线仅报告文档研究。
本文重点覆盖基本要求二与进阶要求，基本要求一的编译流程调研不在本文展开。
\end{abstract}
\noindent\textbf{关键词：}SysY；LLVM IR；RISC-V；SSA；MLIR；等价性验证
\newpage\tableofcontents\newpage
\section{引言与实验任务}
课程要求设计涵盖数值运算、赋值、分支、循环、函数和其他进阶特性的 SysY 示例，
编写等价的 LLVM IR 以及 ARM 或 RISC-V 汇编，链接运行库并验证实际输出。
本实验选择 RISC-V 64，针对相同源程序给出两种手写表示，并以独立预期结果和
参考编译器建立交叉验证。原始依据为课程大作业说明、预备工作课件、SysY 定义、
运行时说明及文法补充。实验重点是语义、结构、目标 ABI 与执行结果之间的对应关系。
本文不涉及完整 SysY 编译器实现；MLIR 进阶部分另用 VecAdd 展示多级降低。
\section{基本要求二：LLVM IR 与 RISC-V 编程}
"""
    source += (REPORT / "llvm_ir_yuan.tex").read_text(encoding="utf-8")
    source += "\n" + (REPORT / "riscv_basic2.tex").read_text(encoding="utf-8")
    source += "\n\\section{进阶要求：MLIR 多级中间表示探索}\n"
    source += (REPORT / "mlir_yuan.tex").read_text(encoding="utf-8")
    source += r"""
\section{总结与复现材料}
原始手写代码、参考源码、运行脚本、命令记录和分层输出均保存在项目中。
LLVM IR 复现入口为 \texttt{prep/llvm\_ir/verify.py}，MLIR 复现入口为
\texttt{prep/mlir/run\_lowering.py}；两个目录的 README 说明工具、运行方式与验证范围。
共同报告入口为 \texttt{LaTeX模板/main.tex}，本附件由
\texttt{scripts/build\_yuan\_report.py} 从相同章节生成，以保持内容一致。
六组手写 IR 与汇编完成同输入的验证闭环，支持后续 IR 生成器和目标代码生成器的开发。
正式运行库取得后需复测；环境限制、有限输入范围和 NPU 文档研究的证据边界
均已明确说明。LLVM IR 通过结构验证与执行对照检查，MLIR 降低则展示类型、
控制流、访存表示和接口的同步转换。
""" + BIB + "\n\\end{document}\n"
    target = REPORT / "袁煜杰-LLVMIR与MLIR实验报告.tex"
    target.write_text(source, encoding="utf-8")
    print(target)

if __name__ == "__main__":
    build()
