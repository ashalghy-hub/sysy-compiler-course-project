; Handwritten: recursive i32 function and a void function with parameter.
declare i32 @getint()
declare void @putint(i32)
declare void @putch(i32)
define i32 @factorial(i32 %n) {
entry:
  %base = icmp sle i32 %n, 1
  br i1 %base, label %small, label %recursive
small:
  ret i32 1
recursive:
  %previous = sub i32 %n, 1
  %child = call i32 @factorial(i32 %previous)
  %result = mul i32 %n, %child
  ret i32 %result
}
define void @emit(i32 %value) {
entry:
  call void @putint(i32 %value)
  call void @putch(i32 10)
  ret void
}
define i32 @main() {
entry:
  %n = call i32 @getint()
  %result = call i32 @factorial(i32 %n)
  call void @emit(i32 %result)
  ret i32 0
}
