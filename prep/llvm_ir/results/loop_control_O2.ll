; ModuleID = 'prep/llvm_ir/loop_control.ll'
source_filename = "prep/llvm_ir/loop_control.ll"

declare i32 @getint() local_unnamed_addr

declare void @putint(i32) local_unnamed_addr

declare void @putch(i32) local_unnamed_addr

define noundef i32 @main() local_unnamed_addr {
entry:
  %n = tail call i32 @getint()
  %more = icmp sgt i32 %n, 2
  %more.peel16 = icmp sgt i32 %n, 0
  br i1 %more.peel16, label %body.peel, label %done

body.peel:                                        ; preds = %entry, %accumulate
  %sum.ph18 = phi i32 [ %added, %accumulate ], [ 0, %entry ]
  %i.ph17 = phi i32 [ %next.lcssa15, %accumulate ], [ 0, %entry ]
  %next.peel = add nsw i32 %i.ph17, 1
  %is.two.peel = icmp eq i32 %next.peel, 2
  br i1 %is.two.peel, label %header, label %break.test

header:                                           ; preds = %body.peel
  br i1 %more, label %accumulate, label %done

break.test:                                       ; preds = %body.peel
  %too.large = icmp sgt i32 %i.ph17, 4
  br i1 %too.large, label %done, label %accumulate

accumulate:                                       ; preds = %header, %break.test
  %next.lcssa15 = phi i32 [ %next.peel, %break.test ], [ 3, %header ]
  %added = add i32 %sum.ph18, %next.lcssa15
  %more.peel = icmp slt i32 %next.lcssa15, %n
  br i1 %more.peel, label %body.peel, label %done

done:                                             ; preds = %accumulate, %header, %break.test, %entry
  %sum.ph.lcssa = phi i32 [ 0, %entry ], [ %added, %accumulate ], [ %sum.ph18, %header ], [ %sum.ph18, %break.test ]
  tail call void @putint(i32 %sum.ph.lcssa)
  tail call void @putch(i32 10)
  ret i32 0
}
