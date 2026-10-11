; ModuleID = 'prep/llvm_ir/promote_demo.ll'
source_filename = "prep/llvm_ir/promote_demo.ll"

declare i32 @getint()

declare void @putint(i32)

declare void @putch(i32)

define i32 @main() {
entry:
  %n = call i32 @getint()
  br label %header

header:                                           ; preds = %body, %entry
  %sum.0 = phi i32 [ 0, %entry ], [ %added, %body ]
  %index.0 = phi i32 [ 0, %entry ], [ %next, %body ]
  %more = icmp slt i32 %index.0, %n
  br i1 %more, label %body, label %done

body:                                             ; preds = %header
  %added = add i32 %sum.0, %index.0
  %next = add i32 %index.0, 1
  br label %header

done:                                             ; preds = %header
  call void @putint(i32 %sum.0)
  call void @putch(i32 10)
  ret i32 0
}
