# 袁煜杰负责的 MLIR 进阶探索

本目录同时包含：课件指定 AscendNPU IR 官方 VecAdd 的**文档研究**，以及上游 MLIR VecAdd 的**真实 CPU lowering 实验**。两者目标不同，不将 CPU 成功表述为 NPU 执行成功。

## 实际实验

`vecadd.mlir` 是独立设计的 16 元素 i16 按元素加法，使用 Linalg + Arith + Func/MemRef 表达。`driver.c` 构造内存描述符，通过 MLIR 生成的 C 包装接口调用函数，验证 a[i]=i、b[i]=1 时结果为 1–16。

```sh
python3 prep/mlir/run_lowering.py
```

脚本优先寻找 `mlir-opt-21`/`mlir-translate-21` 或无版本工具，也可通过 `MLIR_OPT`、`MLIR_TRANSLATE` 指定路径。本次从 Ubuntu 官方软件源下载 `mlir-21-tools` 与 `libmlir-21` 包，并解压到 `tmp/mlir-tools/unpack/`；未系统安装，不修改系统库路径。重建这个便携环境：

```sh
mkdir -p tmp/mlir-tools
cd tmp/mlir-tools
apt-get download mlir-21-tools libmlir-21
dpkg-deb -x mlir-21-tools_*.deb unpack
dpkg-deb -x libmlir-21_*.deb unpack
cd ../..
python3 prep/mlir/run_lowering.py
```

需要匹配的 LLVM 共享库、Clang、opt 和 Python 3。上述包名适用于本次 Ubuntu 软件源；其他平台安装相应版本即可。

实际检查点：

| 文件 | 转换 | 观察 |
| --- | --- | --- |
| results/00_linalg.mlir | parse/verify | generic 保留统一索引映射和 parallel 迭代语义 |
| results/01_scf.mlir | convert-linalg-to-loops | 明确 scf.for 与 memref load/store |
| results/02_cf.mlir | convert-scf-to-cf | 条件分支、回边、块参数取代结构化循环 |
| results/03_llvm.mlir | convert-to-llvm + reconcile-unrealized-casts | 内存描述符、LLVM 操作、C 包装函数 |
| results/04_llvm.ll | mlir-to-llvmir | 从 MLIR 的 LLVM 方言翻译为真正的 LLVM IR |

2026-10-11：各检查点 12/15/21/67 行，末端运行输出 `1 2 ... 16`，退出码 0，**16/16 元素通过**。行数增长反映描述符与接口展开，不是性能退化的直接证据。`latest.json` 和 `commands.json` 保存版本、命令、各层和结果。

## AscendNPU IR 文档研究

课件指定的 [VecAdd 示例](https://ascendnpu-ir.gitcode.com/zh_cn/sources/introduction/quick_start/examples_zh.html) 已查阅。官方例子使用 HIVM 表达输入从 GM 搬运到 UB、在 UB 加法、结果写回 GM，用 HACC 标识设备入口；官方编译路径需要 bishengir-compile 和 CANN，最终需设备 runtime 注册与调用。

[架构文档](https://ascendnpu-ir.gitcode.com/zh_cn/sources/introduction/architecture_zh.html) 说明 HFusion 处理较高层融合，HIVM表达硬件相关计算/搬运/同步，HACC描述异构执行。VecAdd 快速入门直接从 HIVM 开始，不能声称该文件中观察到一次 HFusion→HIVM 转换。参考 [HIVM 方言](https://ascendnpu-ir.gitcode.com/zh_cn/sources/developer_guide/dialects/HIVMDialect.html) 和 [调试选项](https://ascendnpu-ir.gitcode.com/zh_cn/sources/user_guide/debug_option_zh.html)，报告比较了计算、地址空间、同步与执行环境的差异。

本机检测未发现 bishengir-compile、CANN 安装目录或 `/dev/davinci0`。因此不生成虚构 NPU 输出/性能数据。课程课件允许环境困难时通过文档研究、方言差异和探索过程完成进阶说明；本次另加可实际运行的上游 MLIR 实验支持对逐层降低的理解。

上游工具不能直接解析未注册的 HIVM/HACC 自定义方言，不能简单把 CPU pass 管线套在官方 NPU 程序上。CPU 例子未涉及 NPU片上存储、DMA、流水同步或上板调用。

补充参考：[MLIR SCF](https://mlir.llvm.org/docs/Dialects/SCFDialect/)、[MLIR Passes](https://mlir.llvm.org/docs/Passes/)、[Toy 部分降低教程](https://mlir.llvm.org/docs/Tutorials/Toy/Ch-5/)。所有网页查阅日期为 2026-10-11。
