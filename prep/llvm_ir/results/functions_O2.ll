; ModuleID = 'prep/llvm_ir/functions.ll'
source_filename = "prep/llvm_ir/functions.ll"

declare i32 @getint() local_unnamed_addr

declare void @putint(i32) local_unnamed_addr

declare void @putch(i32) local_unnamed_addr

; Function Attrs: nofree norecurse nosync nounwind memory(none)
define i32 @factorial(i32 %n) local_unnamed_addr #0 {
entry:
  %base1 = icmp slt i32 %n, 2
  br i1 %base1, label %common.ret, label %recursive

common.ret:                                       ; preds = %recursive, %entry
  %accumulator.tr.lcssa = phi i32 [ 1, %entry ], [ %result, %recursive ]
  ret i32 %accumulator.tr.lcssa

recursive:                                        ; preds = %entry, %recursive
  %n.tr3 = phi i32 [ %previous, %recursive ], [ %n, %entry ]
  %accumulator.tr2 = phi i32 [ %result, %recursive ], [ 1, %entry ]
  %previous = add nsw i32 %n.tr3, -1
  %result = mul i32 %n.tr3, %accumulator.tr2
  %base = icmp samesign ult i32 %n.tr3, 3
  br i1 %base, label %common.ret, label %recursive
}

define void @emit(i32 %value) local_unnamed_addr {
entry:
  tail call void @putint(i32 %value)
  tail call void @putch(i32 10)
  ret void
}

define noundef i32 @main() local_unnamed_addr {
entry:
  %n = tail call i32 @getint()
  %base1.i = icmp slt i32 %n, 2
  br i1 %base1.i, label %factorial.exit, label %recursive.i

recursive.i:                                      ; preds = %entry, %recursive.i
  %n.tr3.i = phi i32 [ %previous.i, %recursive.i ], [ %n, %entry ]
  %accumulator.tr2.i = phi i32 [ %result.i, %recursive.i ], [ 1, %entry ]
  %previous.i = add nsw i32 %n.tr3.i, -1
  %result.i = mul i32 %accumulator.tr2.i, %n.tr3.i
  %base.i = icmp samesign ult i32 %n.tr3.i, 3
  br i1 %base.i, label %factorial.exit, label %recursive.i

factorial.exit:                                   ; preds = %recursive.i, %entry
  %accumulator.tr.lcssa.i = phi i32 [ 1, %entry ], [ %result.i, %recursive.i ]
  tail call void @putint(i32 %accumulator.tr.lcssa.i)
  tail call void @putch(i32 10)
  ret i32 0
}

attributes #0 = { nofree norecurse nosync nounwind memory(none) }
