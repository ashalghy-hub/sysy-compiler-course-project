module {
  func.func @vecadd(%arg0: memref<16xi16>, %arg1: memref<16xi16>, %arg2: memref<16xi16>) attributes {llvm.emit_c_interface} {
    %c0 = arith.constant 0 : index
    %c16 = arith.constant 16 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %c16 step %c1 {
      %0 = memref.load %arg0[%arg3] : memref<16xi16>
      %1 = memref.load %arg1[%arg3] : memref<16xi16>
      %2 = arith.addi %0, %1 : i16
      memref.store %2, %arg2[%arg3] : memref<16xi16>
    }
    return
  }
}

