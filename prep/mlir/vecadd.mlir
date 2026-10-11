// Yuan Yujie: a portable, upstream MLIR analogue of element-wise VecAdd.
// This is NOT an AscendNPU/HIVM program and does not run on an NPU.
module {
  func.func @vecadd(%a: memref<16xi16>, %b: memref<16xi16>, %c: memref<16xi16>) attributes {llvm.emit_c_interface} {
    linalg.generic {
      indexing_maps = [affine_map<(i) -> (i)>, affine_map<(i) -> (i)>, affine_map<(i) -> (i)>],
      iterator_types = ["parallel"]
    } ins(%a, %b : memref<16xi16>, memref<16xi16>) outs(%c : memref<16xi16>) {
    ^bb0(%x: i16, %y: i16, %old: i16):
      %sum = arith.addi %x, %y : i16
      linalg.yield %sum : i16
    }
    return
  }
}
