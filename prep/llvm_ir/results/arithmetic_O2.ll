; ModuleID = 'prep/llvm_ir/arithmetic.ll'
source_filename = "prep/llvm_ir/arithmetic.ll"

declare i32 @getint() local_unnamed_addr

declare void @putint(i32) local_unnamed_addr

declare void @putch(i32) local_unnamed_addr

define noundef i32 @main() local_unnamed_addr {
entry:
  %n = tail call i32 @getint()
  %shift = shl i32 %n, 1
  %half.neg = sdiv i32 %n, -2
  %rem = srem i32 %n, 3
  %difference = add i32 %shift, 13
  %base = add i32 %difference, %half.neg
  %answer = add i32 %base, %rem
  tail call void @putint(i32 %answer)
  tail call void @putch(i32 10)
  %negative = sub i32 0, %n
  tail call void @putint(i32 %negative)
  tail call void @putch(i32 10)
  tail call void @putint(i32 %n)
  tail call void @putch(i32 10)
  %notanswer = tail call i32 @llvm.umax.i32(i32 %n, i32 1)
  tail call void @putint(i32 %notanswer)
  tail call void @putch(i32 10)
  ret i32 0
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #0

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
