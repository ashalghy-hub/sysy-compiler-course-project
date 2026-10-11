#!/usr/bin/env python3
"""Rebuild all implementations; assert expected output AND process exit status."""
import json, math, os, platform, subprocess, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
BASE = Path('prep/llvm_ir')
BUILD = Path('build/prep-llvm-ir')
RESULTS = BASE / 'results'
os.chdir(ROOT)
BUILD.mkdir(parents=True, exist_ok=True)
RESULTS.mkdir(exist_ok=True)
commands, checks = [], []

def execute(cmd, data=None, timeout=60):
    p = subprocess.run([str(x) for x in cmd], input=data, text=True,
                       capture_output=True, timeout=timeout)
    commands.append(dict(command=[str(x) for x in cmd], returncode=p.returncode,
                         stdout=p.stdout, stderr=p.stderr))
    if p.returncode != 0:
        raise RuntimeError(f'Command failed: {cmd}\n{p.stderr}')
    return p

def lines(*values): return ''.join(f'{v}\n' for v in values)
def quotient(a, b): return (abs(a)//abs(b)) * (1 if a*b >= 0 else -1)
def arithmetic(n): return lines((n+3)*2-quotient(n,2)+(n-quotient(n,3)*3)+7, -n, n, n+(n==0))
def short(n): return lines(int(n!=0 and quotient(12,n)>2), 2, int(n!=0))
def loop(n): return lines(sum(i for i in range(1,min(n,5)+1) if i!=2))
def array(n): return lines(10,3*n+1,int(3*n+1>0))
def promote(n): return lines(max(n,0)*(max(n,0)-1)//2)
CASES = {
    'arithmetic':([-7,-1,0,1,7,12], arithmetic),
    'short_circuit':([-3,0,1,4,5,12], short),
    'loop_control':([-2,0,1,2,5,8], loop),
    'functions':([0,1,5,7,12],lambda n:lines(math.factorial(n))),
    'array_float':([-3,-1,0,2,7],array),
    'promote_demo':([-3,0,1,5,10],promote),
}

def main():
    environment = {'platform':platform.platform(), 'os_release':Path('/etc/os-release').read_text(),
                   'tools':{}}
    for t in ['clang','llvm-as','opt','llc','lli','riscv64-linux-gnu-gcc','qemu-riscv64']:
        environment['tools'][t]=execute([t,'--version']).stdout.splitlines()[0]
    runtime = Path('prep/manual/sylib.c')
    execute(['clang','-emit-llvm','-c',runtime,'-o',BUILD/'runtime.bc'])
    for name,(inputs,oracle) in CASES.items():
        src,ir = BASE/f'{name}.sy',BASE/f'{name}.ll'
        execute(['llvm-as',ir,'-o',BUILD/f'{name}.bc'])
        execute(['opt','-passes=verify','-disable-output',ir])
        optimized=RESULTS/f'{name}_O2.ll'
        execute(['opt','-S','-passes=default<O2>',ir,'-o',optimized])
        execute(['llvm-link',BUILD/f'{name}.bc',BUILD/'runtime.bc','-o',BUILD/f'{name}_linked.bc'])
        variants={}
        for rv in [False,True]:
            exe=BUILD/(f'{name}_reference'+('_rv' if rv else ''))
            # .sy stays genuine SysY; the header is forced only for C reference compilation.
            if rv:
                execute(['riscv64-linux-gnu-gcc','-x','c','-include',BASE/'runtime.h',src,runtime,'-static','-O0','-o',exe])
            else:
                execute(['clang','-x','c','-include',BASE/'runtime.h',src,runtime,'-O0','-o',exe])
            variants['reference_rv' if rv else 'reference_native']=(['qemu-riscv64',exe] if rv else [exe])
        for level,module in [('O0',ir),('O2',optimized)]:
            exe=BUILD/f'{name}_ir_{level}'
            execute(['clang',module,runtime,'-Wno-override-module','-o',exe])
            variants[f'ir_native_{level}']=[exe]
            asm=RESULTS/f'{name}_generated_rv_{level}.s'
            execute(['llc','-mtriple=riscv64-linux-gnu','-mattr=+m,+a,+f,+d,+c','-target-abi=lp64d',module,'-o',asm])
            rvexe=BUILD/f'{name}_ir_rv_{level}'
            execute(['riscv64-linux-gnu-gcc','-static','-march=rv64gc','-mabi=lp64d',asm,runtime,'-o',rvexe])
            variants[f'ir_rv_{level}']=['qemu-riscv64',rvexe]
        variants['ir_lli']=['lli',BUILD/f'{name}_linked.bc']
        handwritten = BASE/'handwritten'/f'{name}_rv.s'
        manual_exe = BUILD/f'{name}_handwritten_rv'
        execute(['riscv64-linux-gnu-gcc','-static','-march=rv64gc','-mabi=lp64d',
                 handwritten,runtime,'-o',manual_exe])
        variants['handwritten_rv']=['qemu-riscv64',manual_exe]
        for n in inputs:
            expected=oracle(n)
            for variant,cmd in variants.items():
                p=execute(cmd,f'{n}\n',timeout=15)
                passed=p.stdout==expected
                checks.append(dict(program=name,variant=variant,input=n,expected=expected,
                                   stdout=p.stdout,stderr=p.stderr,returncode=p.returncode,passed=passed))
                if not passed: raise AssertionError(f'{name} {variant} n={n}: {p.stdout!r} != {expected!r}')
        print(f'PASS {name}: {len(inputs)} inputs x {len(variants)} execution paths')
    promoted=RESULTS/'promote_demo_mem2reg.ll'
    execute(['opt','-S','-passes=mem2reg',BASE/'promote_demo.ll','-o',promoted])
    before=(BASE/'promote_demo.ll').read_text();after=promoted.read_text()
    import re
    counts=lambda s:{k:len(re.findall(r'\b'+k+r'\b', '\n'.join(l.split(';')[0] for l in s.splitlines()))) for k in ['alloca','load','store','phi']}
    promotion={'before':counts(before),'after':counts(after)}
    assert promotion['after']['alloca']==0 and promotion['after']['phi']==2
    exe=BUILD/'promote_demo_mem2reg'
    execute(['clang',promoted,runtime,'-Wno-override-module','-o',exe])
    for n in CASES['promote_demo'][0]:
        p=execute([exe],f'{n}\n');expected=promote(n)
        assert p.stdout==expected
        checks.append(dict(program='promote_demo',variant='mem2reg_native',input=n,expected=expected,stdout=p.stdout,returncode=p.returncode,passed=True))
    (RESULTS/'latest.json').write_text(json.dumps(dict(environment=environment,summary={'passed':len(checks),'total':len(checks)},mem2reg=promotion,checks=checks),ensure_ascii=False,indent=2)+'\n')
    (RESULTS/'commands.json').write_text(json.dumps(commands,ensure_ascii=False,indent=2)+'\n')
    print(f'ALL PASS: {len(checks)}/{len(checks)}; mem2reg: {promotion}')

if __name__=='__main__':
    try: main()
    except Exception:
        (RESULTS/'failed_commands.json').write_text(json.dumps(commands,ensure_ascii=False,indent=2))
        raise
