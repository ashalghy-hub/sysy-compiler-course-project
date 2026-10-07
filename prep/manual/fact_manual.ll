; ============================================================
; 手写 LLVM IR：阶乘（小题2）
; 与 SysY 源程序等价：
;   int main() {
;       int n = getint();
;       int i = 2, f = 1;
;       while (i <= n) { f = f * i; i = i + 1; }
;       putint(f); putch(10);
;       return 0;
;   }
; 特点：使用 phi 指令的标准 SSA 形式（对应 mem2reg 之后的形态）
; 验证：clang fact_manual.ll sylib.c -o fact_manual_ll && echo 7 | ./fact_manual_ll  -> 5040
; ============================================================

declare i32 @getint()
declare void @putint(i32)
declare void @putch(i32)

define i32 @main() {
entry:
    %n = call i32 @getint()
    br label %loop

loop:                                             ; i, f 的 phi 节点
    %i = phi i32 [ 2, %entry ], [ %i_next, %body ]
    %f = phi i32 [ 1, %entry ], [ %f_next, %body ]
    %cond = icmp sle i32 %i, %n
    br i1 %cond, label %body, label %done

body:
    %f_next = mul nsw i32 %f, %i
    %i_next = add nsw i32 %i, 1
    br label %loop

done:
    call void @putint(i32 %f)
    call void @putch(i32 10)                      ; 输出换行
    ret i32 0
}
