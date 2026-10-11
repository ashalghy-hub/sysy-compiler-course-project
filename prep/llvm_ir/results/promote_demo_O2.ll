; ModuleID = 'prep/llvm_ir/promote_demo.ll'
source_filename = "prep/llvm_ir/promote_demo.ll"

declare i32 @getint() local_unnamed_addr

declare void @putint(i32) local_unnamed_addr

declare void @putch(i32) local_unnamed_addr

define noundef i32 @main() local_unnamed_addr {
entry:
  %n = tail call i32 @getint()
  %more2 = icmp sgt i32 %n, 0
  br i1 %more2, label %body.preheader, label %done

body.preheader:                                   ; preds = %entry
  %0 = add nsw i32 %n, -1
  %1 = zext nneg i32 %0 to i33
  %2 = add nsw i32 %n, -2
  %3 = zext i32 %2 to i33
  %4 = mul i33 %1, %3
  %5 = lshr i33 %4, 1
  %6 = trunc nuw i33 %5 to i32
  %7 = add i32 %n, %6
  %8 = add i32 %7, -1
  br label %done

done:                                             ; preds = %body.preheader, %entry
  %sum.0.lcssa = phi i32 [ 0, %entry ], [ %8, %body.preheader ]
  tail call void @putint(i32 %sum.0.lcssa)
  tail call void @putch(i32 10)
  ret i32 0
}
