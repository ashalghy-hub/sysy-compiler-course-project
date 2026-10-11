; Handwritten by Yuan Yujie. No generated IR is used as this source.
; Constants and shadowed n=7 are represented by distinct SSA operands.
declare i32 @getint()
declare void @putint(i32)
declare void @putch(i32)
define i32 @main() {
entry:
  %n = call i32 @getint()
  %shift = add i32 %n, 3
  %double = mul i32 %shift, 2
  %half = sdiv i32 %n, 2
  %rem = srem i32 %n, 3
  %difference = sub i32 %double, %half
  %base = add i32 %difference, %rem
  %answer = add i32 %base, 7
  call void @putint(i32 %answer)
  call void @putch(i32 10)
  %negative = sub i32 0, %n
  call void @putint(i32 %negative)
  call void @putch(i32 10)
  call void @putint(i32 %n)
  call void @putch(i32 10)
  %iszero = icmp eq i32 %n, 0
  %notn = zext i1 %iszero to i32
  %notanswer = add i32 %n, %notn
  call void @putint(i32 %notanswer)
  call void @putch(i32 10)
  ret i32 0
}
