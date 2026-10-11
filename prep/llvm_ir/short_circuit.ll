; Handwritten. RHS blocks are entered only when required; no eager division.
@hits = global i32 0, align 4
declare i32 @getint()
declare void @putint(i32)
declare void @putch(i32)
define i32 @touch() {
entry:
  %old = load i32, ptr @hits, align 4
  %new = add i32 %old, 1
  store i32 %new, ptr @hits, align 4
  ret i32 1
}
define i32 @main() {
entry:
  %n = call i32 @getint()
  %nonzero = icmp ne i32 %n, 0
  br i1 %nonzero, label %and.rhs, label %and.false
and.rhs:
  %q = sdiv i32 12, %n
  %large = icmp sgt i32 %q, 2
  br i1 %large, label %and.true, label %and.false
and.true:
  br label %and.join
and.false:
  br label %and.join
and.join:
  %and.value = phi i32 [1, %and.true], [0, %and.false]
  call void @putint(i32 %and.value)
  call void @putch(i32 10)
  %zero = icmp eq i32 %n, 0
  br i1 %zero, label %or.true, label %or.rhs
or.rhs:
  %called = call i32 @touch()
  %truth = icmp ne i32 %called, 0
  br i1 %truth, label %or.true, label %or.false
or.true:
  br label %or.join
or.false:
  br label %or.join
or.join:
  %or.value = phi i32 [2, %or.true], [3, %or.false]
  call void @putint(i32 %or.value)
  call void @putch(i32 10)
  %count = load i32, ptr @hits, align 4
  call void @putint(i32 %count)
  call void @putch(i32 10)
  ret i32 0
}
