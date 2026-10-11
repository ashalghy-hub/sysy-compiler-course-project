module {
  func.func @vecadd(%arg0: memref<16xi16>, %arg1: memref<16xi16>, %arg2: memref<16xi16>) attributes {llvm.emit_c_interface} {
    %c0 = arith.constant 0 : index
    %c16 = arith.constant 16 : index
    %c1 = arith.constant 1 : index
    cf.br ^bb1(%c0 : index)
  ^bb1(%0: index):  // 2 preds: ^bb0, ^bb2
    %1 = arith.cmpi slt, %0, %c16 : index
    cf.cond_br %1, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %2 = memref.load %arg0[%0] : memref<16xi16>
    %3 = memref.load %arg1[%0] : memref<16xi16>
    %4 = arith.addi %2, %3 : i16
    memref.store %4, %arg2[%0] : memref<16xi16>
    %5 = arith.addi %0, %c1 : index
    cf.br ^bb1(%5 : index)
  ^bb3:  // pred: ^bb1
    return
  }
}

