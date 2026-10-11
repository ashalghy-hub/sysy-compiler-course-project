#!/usr/bin/env python3
"""Real upstream MLIR lowering with checkpoints and CPU execution."""
import json, os, re, shutil, subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
os.chdir(ROOT)
local=ROOT/'tmp/mlir-tools/unpack/usr/lib/llvm-21'
OPT=os.environ.get('MLIR_OPT') or shutil.which('mlir-opt-21') or shutil.which('mlir-opt') or str(local/'bin/mlir-opt')
TRANSLATE=os.environ.get('MLIR_TRANSLATE') or shutil.which('mlir-translate-21') or shutil.which('mlir-translate') or str(local/'bin/mlir-translate')
env=os.environ.copy()
if local.exists(): env['LD_LIBRARY_PATH']=str(local/'lib')+(':'+env['LD_LIBRARY_PATH'] if env.get('LD_LIBRARY_PATH') else '')
out=Path('prep/mlir/results');out.mkdir(exist_ok=True)
build=Path('build/prep-mlir');build.mkdir(parents=True,exist_ok=True)
records=[]
def run(cmd):
    p=subprocess.run([str(x) for x in cmd],text=True,capture_output=True,env=env,timeout=60)
    records.append(dict(command=[str(x) for x in cmd],returncode=p.returncode,stdout=p.stdout,stderr=p.stderr))
    (out/'commands.json').write_text(json.dumps(records,ensure_ascii=False,indent=2)+'\n')
    if p.returncode: raise RuntimeError(f'{cmd}: {p.stderr}')
    return p.stdout
version=run([OPT,'--version'])
source=Path('prep/mlir/vecadd.mlir')
run([OPT,source,'-o',out/'00_linalg.mlir'])
run([OPT,out/'00_linalg.mlir','--convert-linalg-to-loops','-o',out/'01_scf.mlir'])
run([OPT,out/'01_scf.mlir','--convert-scf-to-cf','-o',out/'02_cf.mlir'])
run([OPT,out/'02_cf.mlir','--convert-to-llvm','--reconcile-unrealized-casts','-o',out/'03_llvm.mlir'])
run([TRANSLATE,'--mlir-to-llvmir',out/'03_llvm.mlir','-o',out/'04_llvm.ll'])
run(['opt','-passes=verify','-disable-output',out/'04_llvm.ll'])
run(['clang',out/'04_llvm.ll','prep/mlir/driver.c','-Wno-override-module','-o',build/'vecadd'])
actual=run([build/'vecadd']);expected=' '.join(str(i) for i in range(1,17))+'\n'
if actual!=expected: raise AssertionError((actual,expected))
stages=[]
for p in sorted(out.glob('0*.mlir')):
    s=p.read_text();dialects=sorted(set(re.findall(r'(?:^|\n)\s*(?:%[^=\n]+=\s*)?([a-z][a-z0-9_]*)\.[a-z_]+',s)))
    stages.append(dict(file=str(p),dialects=dialects,lines=len(s.splitlines())))
(out/'latest.json').write_text(json.dumps(dict(tool_version=version,stages=stages,stdout=actual,expected=expected,passed=True,elements_checked=16,execution_target='x86_64 CPU; not Ascend NPU'),ensure_ascii=False,indent=2)+'\n')
print(json.dumps(stages,indent=2));print('PASS: VecAdd 16/16; '+actual.strip())
