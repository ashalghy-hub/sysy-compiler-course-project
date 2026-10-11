; ModuleID = 'prep/llvm_ir/short_circuit.ll'
source_filename = "prep/llvm_ir/short_circuit.ll"

@hits = local_unnamed_addr global i32 0, align 4

declare i32 @getint() local_unnamed_addr

declare void @putint(i32) local_unnamed_addr

declare void @putch(i32) local_unnamed_addr

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(readwrite, argmem: none, inaccessiblemem: none)
define noundef i32 @touch() local_unnamed_addr #0 {
entry:
  %old = load i32, ptr @hits, align 4
  %new = add i32 %old, 1
  store i32 %new, ptr @hits, align 4
  ret i32 1
}

define noundef i32 @main() local_unnamed_addr {
entry:
  %n = tail call i32 @getint()
  %nonzero.not = icmp eq i32 %n, 0
  br i1 %nonzero.not, label %and.false, label %and.rhs

and.rhs:                                          ; preds = %entry
  %q = sdiv i32 12, %n
  %large = icmp sgt i32 %q, 2
  br i1 %large, label %and.join, label %and.false

and.false:                                        ; preds = %and.rhs, %entry
  br label %and.join

and.join:                                         ; preds = %and.rhs, %and.false
  %and.value = phi i32 [ 0, %and.false ], [ 1, %and.rhs ]
  tail call void @putint(i32 %and.value)
  tail call void @putch(i32 10)
  br i1 %nonzero.not, label %or.join, label %or.rhs

or.rhs:                                           ; preds = %and.join
  %old.i = load i32, ptr @hits, align 4
  %new.i = add i32 %old.i, 1
  store i32 %new.i, ptr @hits, align 4
  br label %or.join

or.join:                                          ; preds = %or.rhs, %and.join
  tail call void @putint(i32 2)
  tail call void @putch(i32 10)
  %count = load i32, ptr @hits, align 4
  tail call void @putint(i32 %count)
  tail call void @putch(i32 10)
  ret i32 0
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(readwrite, argmem: none, inaccessiblemem: none) }
