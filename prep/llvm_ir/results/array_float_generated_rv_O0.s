	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.file	"array_float.ll"
	.text
	.globl	row_sum                         # -- Begin function row_sum
	.p2align	1
	.type	row_sum,@function
row_sum:                                # @row_sum
	.cfi_startproc
# %bb.0:                                # %entry
	mv	a2, a0
	li	a3, 0
	li	a0, 0
	sext.w	a1, a1
	slli	a4, a1, 2
	slli	a1, a1, 4
	sub	a1, a1, a4
	add	a2, a2, a1
	li	a1, 2
	bltz	a1, .LBB0_2
.LBB0_1:                                # %body
                                        # =>This Inner Loop Header: Depth=1
	lw	a4, 0(a2)
	addiw	a3, a3, 1
	addw	a0, a0, a4
	addi	a2, a2, 4
	bge	a1, a3, .LBB0_1
.LBB0_2:                                # %done
	ret
.Lfunc_end0:
	.size	row_sum, .Lfunc_end0-row_sum
	.cfi_endproc
                                        # -- End function
	.globl	twice                           # -- Begin function twice
	.p2align	1
	.type	twice,@function
twice:                                  # @twice
	.cfi_startproc
# %bb.0:                                # %entry
	fadd.s	fa0, fa0, fa0
	ret
.Lfunc_end1:
	.size	twice, .Lfunc_end1-twice
	.cfi_endproc
                                        # -- End function
	.globl	main                            # -- Begin function main
	.p2align	1
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	addi	sp, sp, -64
	.cfi_def_cfa_offset 64
	sd	ra, 56(sp)                      # 8-byte Folded Spill
	sd	s0, 48(sp)                      # 8-byte Folded Spill
	sd	s1, 40(sp)                      # 8-byte Folded Spill
	fsd	fs0, 32(sp)                     # 8-byte Folded Spill
	.cfi_offset ra, -8
	.cfi_offset s0, -16
	.cfi_offset s1, -24
	.cfi_offset fs0, -32
	sw	zero, 24(sp)
	sw	zero, 28(sp)
	li	a0, 4
	li	a1, 3
	li	a2, 2
	li	a3, 1
	sw	a3, 8(sp)
	sw	a2, 12(sp)
	sw	a1, 16(sp)
	sw	a0, 20(sp)
	call	getint
	fcvt.s.w	fa5, a0
	lui	a0, 261120
	fmv.w.x	fa4, a0
	lui	a0, 258048
	fmul.s	fa5, fa5, fa4
	fmv.w.x	fa4, a0
	fadd.s	fa0, fa5, fa4
	call	twice
	fmv.s	fs0, fa0
	fcvt.w.s	s0, fa0, rtz
	addi	a0, sp, 8
	li	a1, 0
	call	row_sum
	mv	s1, a0
	addi	a0, sp, 8
	li	a1, 1
	call	row_sum
	addw	a0, a0, s1
	call	putint
	li	a0, 10
	call	putch
	mv	a0, s0
	call	putint
	li	a0, 10
	call	putch
	fmv.w.x	fa5, zero
	flt.s	a0, fa5, fs0
	call	putint
	li	a0, 10
	call	putch
	li	a0, 0
	ld	ra, 56(sp)                      # 8-byte Folded Reload
	ld	s0, 48(sp)                      # 8-byte Folded Reload
	ld	s1, 40(sp)                      # 8-byte Folded Reload
	fld	fs0, 32(sp)                     # 8-byte Folded Reload
	.cfi_restore ra
	.cfi_restore s0
	.cfi_restore s1
	.cfi_restore fs0
	addi	sp, sp, 64
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
