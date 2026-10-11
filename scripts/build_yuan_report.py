"""Build the standalone report from the shared, maintained chapter fragments."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPORT = ROOT / "LaTeX模板"
BIB = r"""
\begin{thebibliography}{9}
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
\pagestyle{fancy}\fancyhf{}\lhead{LLVM IR 与 MLIR 预备实验}\rhead{袁煜杰}\cfoot{\thepage}
\lstset{basicstyle=\small\ttfamily,breaklines=true,frame=single,columns=fullflexible,keepspaces=true}
\title{编译系统上机大作业预备工作\\LLVM IR 编程与 MLIR 进阶探索}
\author{袁煜杰（合作成员：张龙飞，3769lkj）}
\date{2026年10月11日}
\setlength{\emergencystretch}{2em}
\begin{document}
\maketitle
\begin{abstract}
本报告记录本人负责的基本要求二 LLVM IR 编程与进阶 MLIR 探索。
独立设计六组 SysY 程序并手写 LLVM IR，使用结构验证、独立预期结果、参考程序、
本机执行及 RISC-V 模拟执行检查语义；33 组输入和 mem2reg 对照共 236 项检查全部通过。
进阶部分研究 AscendNPU IR 官方文档，另实际执行上游 MLIR 的
Linalg、SCF、CF、LLVM 方言降低以及 LLVM IR 翻译，VecAdd 的 16 个元素全部正确。
当前未配置 Ascend NPU 与 CANN，因此专有方言路线仅报告文档研究。
本报告是本人部分的完整附件；小组最终共同报告还需合入搭档的分析和手写汇编实验。
\end{abstract}
\tableofcontents\newpage
\section{任务与分工}
课程原始资料包括大作业说明、预备工作课件、SysY 定义、运行时说明及文法补充。
两人合作完成一份预备作业报告，开头说明分工，两人分别提交。
袁煜杰负责 LLVM IR 示例、验证脚本、MLIR 进阶探索及相应报告；
张龙飞负责基本要求二的手写 RISC-V 汇编，已有工作流程实验由其继续完善。
本附件不替代尚待整合的小组共同报告，也不代表已实现完整 SysY 编译器。
\section{基本要求二：手写 LLVM IR}
"""
    source += (REPORT / "llvm_ir_yuan.tex").read_text(encoding="utf-8")
    source += "\n\\section{进阶要求：MLIR 多级中间表示探索}\n"
    source += (REPORT / "mlir_yuan.tex").read_text(encoding="utf-8")
    source += r"""
\section{交付物与后续整合}
原始手写代码、参考源码、运行脚本、命令记录和分层输出均保存在项目中。
LLVM IR 复现入口为 \texttt{prep/llvm\_ir/verify.py}，MLIR 复现入口为
\texttt{prep/mlir/run\_lowering.py}；两个目录的 README 说明工具、运行方式与验证范围。
共同报告入口为 \texttt{LaTeX模板/main.tex}，本附件由
\texttt{scripts/build\_yuan\_report.py} 从相同章节生成，以保持内容一致。
后续由搭档补齐手写汇编对应示例与工作流程分析，双方取得课程正式运行库后再次验证，
再统一共同报告并分别提交。当前可作为后续 IR 生成器和目标代码生成器的对照样例。
""" + BIB + "\n\\end{document}\n"
    target = REPORT / "袁煜杰-LLVMIR与MLIR实验报告.tex"
    target.write_text(source, encoding="utf-8")
    print(target)

if __name__ == "__main__":
    build()
