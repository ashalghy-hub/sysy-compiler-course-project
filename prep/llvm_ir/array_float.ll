; Handwritten: row-major multidimensional array, implicit zero fill,
; array parameter, float function and signed integer/float conversions.
declare i32 @getint()
declare void @putint(i32)
declare void @putch(i32)
define i32 @row_sum(ptr %a, i32 %row) {
entry:
  %row64 = sext i32 %row to i64
  br label %header
header:
  %j = phi i32 [0, %entry], [%next, %body]
  %sum = phi i32 [0, %entry], [%added, %body]
  %more = icmp slt i32 %j, 3
  br i1 %more, label %body, label %done
body:
  %j64 = sext i32 %j to i64
  %element = getelementptr [3 x i32], ptr %a, i64 %row64, i64 %j64
  %value = load i32, ptr %element, align 4
  %added = add i32 %sum, %value
  %next = add i32 %j, 1
  br label %header
done:
  ret i32 %sum
}
define float @twice(float %x) {
entry:
  %result = fmul float %x, 2.000000e+00
  ret float %result
}
define i32 @main() {
entry:
  %a = alloca [2 x [3 x i32]], align 4
  store [2 x [3 x i32]] [[3 x i32] [i32 1, i32 2, i32 3], [3 x i32] [i32 4, i32 0, i32 0]], ptr %a, align 4
  %n = call i32 @getint()
  %nf = sitofp i32 %n to float
  %product = fmul float %nf, 1.500000e+00
  %offset = fadd float %product, 5.000000e-01
  %scaled = call float @twice(float %offset)
  %truncated = fptosi float %scaled to i32
  %row0 = call i32 @row_sum(ptr %a, i32 0)
  %row1 = call i32 @row_sum(ptr %a, i32 1)
  %sum = add i32 %row0, %row1
  call void @putint(i32 %sum)
  call void @putch(i32 10)
  call void @putint(i32 %truncated)
  call void @putch(i32 10)
  %positive = fcmp ogt float %scaled, 0.000000e+00
  %truth = zext i1 %positive to i32
  call void @putint(i32 %truth)
  call void @putch(i32 10)
  ret i32 0
}
