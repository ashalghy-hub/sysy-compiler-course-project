; ModuleID = 'prep/llvm_ir/array_float.ll'
source_filename = "prep/llvm_ir/array_float.ll"

declare i32 @getint() local_unnamed_addr

declare void @putint(i32) local_unnamed_addr

declare void @putch(i32) local_unnamed_addr

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define i32 @row_sum(ptr readonly captures(none) %a, i32 %row) local_unnamed_addr #0 {
entry:
  %row64 = sext i32 %row to i64
  %element = getelementptr [3 x i32], ptr %a, i64 %row64, i64 0
  %value = load i32, ptr %element, align 4
  %element.1 = getelementptr [3 x i32], ptr %a, i64 %row64, i64 1
  %value.1 = load i32, ptr %element.1, align 4
  %added.1 = add i32 %value.1, %value
  %element.2 = getelementptr [3 x i32], ptr %a, i64 %row64, i64 2
  %value.2 = load i32, ptr %element.2, align 4
  %added.2 = add i32 %value.2, %added.1
  ret i32 %added.2
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define float @twice(float %x) local_unnamed_addr #1 {
entry:
  %result = fmul float %x, 2.000000e+00
  ret float %result
}

define noundef i32 @main() local_unnamed_addr {
entry:
  %n = tail call i32 @getint()
  %nf = sitofp i32 %n to float
  %product = fmul float %nf, 1.500000e+00
  %offset = fadd float %product, 5.000000e-01
  %result.i = fmul float %offset, 2.000000e+00
  %truncated = fptosi float %result.i to i32
  tail call void @putint(i32 10)
  tail call void @putch(i32 10)
  tail call void @putint(i32 %truncated)
  tail call void @putch(i32 10)
  %positive = fcmp ogt float %result.i, 0.000000e+00
  %truth = zext i1 %positive to i32
  tail call void @putint(i32 %truth)
  tail call void @putch(i32 10)
  ret i32 0
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read) }
attributes #1 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
