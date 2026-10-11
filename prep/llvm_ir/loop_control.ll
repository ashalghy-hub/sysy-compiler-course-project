; Handwritten. Three backedges represent continue and the normal iteration.
declare i32 @getint()
declare void @putint(i32)
declare void @putch(i32)
define i32 @main() {
entry:
  %n = call i32 @getint()
  br label %header
header:
  %i = phi i32 [0, %entry], [%next, %skip], [%next, %accumulate]
  %sum = phi i32 [0, %entry], [%sum, %skip], [%added, %accumulate]
  %more = icmp slt i32 %i, %n
  br i1 %more, label %body, label %done
body:
  %next = add i32 %i, 1
  %is.two = icmp eq i32 %next, 2
  br i1 %is.two, label %skip, label %break.test
skip:
  br label %header
break.test:
  %too.large = icmp sgt i32 %next, 5
  br i1 %too.large, label %done, label %accumulate
accumulate:
  %added = add i32 %sum, %next
  br label %header
done:
  %result = phi i32 [%sum, %header], [%sum, %break.test]
  call void @putint(i32 %result)
  call void @putch(i32 10)
  ret i32 0
}
