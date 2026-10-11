"""Build read-only views of real project files and recorded execution results."""
from pathlib import Path
import html
import json

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'LaTeX模板/figures/views'
OUT.mkdir(parents=True, exist_ok=True)

def excerpt(path, start, end):
    lines = (ROOT/path).read_text(encoding='utf-8').splitlines()
    return '\n'.join(f'{i+1:>3}  {lines[i]}' for i in range(start-1, min(end, len(lines))))

def page(name, title, panels):
    cards = ''.join('<section><h2>'+html.escape(label)+'</h2><pre>'+html.escape(content)+'</pre></section>'
                    for label, content in panels)
    template = '''<!doctype html><html lang="zh-CN"><meta charset="utf-8">
<style>*{box-sizing:border-box}body{margin:0;background:#fff;color:#152238;font-family:"Microsoft YaHei",sans-serif}
#capture{padding:24px;width:100%;max-width:1180px}h1{font-size:25px;margin:0 0 18px}.panels{display:grid;grid-template-columns:1fr 1fr;gap:16px}
section{border:1px solid #b7c7d9;border-radius:5px;overflow:hidden}h2{margin:0;padding:12px 15px;background:#edf3f8;font-size:18px;font-weight:600}
pre{margin:0;padding:16px;font:17px/1.5 Consolas,"Courier New",monospace;white-space:pre-wrap;overflow-wrap:anywhere;background:#fff}
.note{font-size:14px;color:#586b7f;margin-top:14px}</style><div id="capture"><h1>''' +html.escape(title)+'''</h1><div class="panels">'''+cards+'''</div>
<div class="note">项目文件与已保存运行记录的只读视图</div></div></html>'''
    (OUT/(name+'.html')).write_text('\n'.join(line.rstrip() for line in template.splitlines())+'\n', encoding='utf-8')

page('preprocess', '预处理：源程序与展开后的头文件', [
    ('prep/src/fact.cpp', excerpt('prep/src/fact.cpp',1,17)),
    ('prep/stages/fact/fact.i（开头）', excerpt('prep/stages/fact/fact.i',1,10))])
page('short_circuit', '短路条件：SysY 源码与手写 LLVM IR', [
    ('short_circuit.sy', excerpt('prep/llvm_ir/short_circuit.sy',2,12)),
    ('short_circuit.ll（条件及合流）', excerpt('prep/llvm_ir/short_circuit.ll',14,29))])
page('mem2reg', 'mem2reg：局部访存转换为 SSA 合流', [
    ('promote_demo.ll（优化前）', excerpt('prep/llvm_ir/promote_demo.ll',7,23)),
    ('promote_demo_mem2reg.ll（优化后）', excerpt('prep/llvm_ir/results/promote_demo_mem2reg.ll',7,20))])
results = json.loads((ROOT/'prep/llvm_ir/results/latest.json').read_text(encoding='utf-8'))
record = next(x for x in results['checks'] if x['program']=='functions' and x['variant']=='handwritten_rv' and x['input']==7)
page('recursive_rv', '递归调用：手写汇编与运行记录', [
    ('handwritten/functions_rv.s', excerpt('prep/llvm_ir/handwritten/functions_rv.s',5,22)),
    ('results/latest.json（对应测试）', json.dumps(record,ensure_ascii=False,indent=2))])
page('mlir_lowering', 'MLIR：结构化循环降低为基本块分支', [
    ('01_scf.mlir', excerpt('prep/mlir/results/01_scf.mlir',3,13)),
    ('02_cf.mlir', excerpt('prep/mlir/results/02_cf.mlir',3,20))])
mlir = json.loads((ROOT/'prep/mlir/results/latest.json').read_text(encoding='utf-8'))
mlir_record = json.loads((ROOT/'prep/mlir/results/commands.json').read_text(encoding='utf-8'))[-1]
summary = {'summary':results['summary'], 'mem2reg':results['mem2reg']}
page('results', '验证记录：LLVM IR / RISC-V 与 MLIR VecAdd', [
    ('llvm_ir/results/latest.json（摘要）', '\n\n'.join(k+'\n'+json.dumps(v,ensure_ascii=False,indent=2) if k=='summary' else k+'\n'+json.dumps(v,ensure_ascii=False) for k,v in summary.items())),
    ('mlir/results/commands.json（运行项）', json.dumps(mlir_record,ensure_ascii=False,indent=2)+'\n\n'+json.dumps({'passed':mlir['passed'],'elements_checked':mlir['elements_checked']},ensure_ascii=False,indent=2))])
print(OUT)
