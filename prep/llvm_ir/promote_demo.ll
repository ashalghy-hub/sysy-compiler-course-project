; Handwritten memory-form loop for observing opt -passes=mem2reg.
declare i32 @getint()
declare void @putint(i32)
declare void @putch(i32)
define i32 @main() {
entry:
  %index = alloca i32, align 4
  %sum = alloca i32, align 4
  %n = call i32 @getint()
  store i32 0, ptr %index, align 4
  store i32 0, ptr %sum, align 4
  br label %header
header:
  %i = load i32, ptr %index, align 4
  %more = icmp slt i32 %i, %n
  br i1 %more, label %body, label %done
body:
  %old = load i32, ptr %sum, align 4
  %added = add i32 %old, %i
  store i32 %added, ptr %sum, align 4
  %next = add i32 %i, 1
  store i32 %next, ptr %index, align 4
  br label %header
done:
  %result = load i32, ptr %sum, align 4
  call void @putint(i32 %result)
  call void @putch(i32 10)
  ret i32 0
}
