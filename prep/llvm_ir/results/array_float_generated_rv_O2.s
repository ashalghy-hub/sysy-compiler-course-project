	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.file	"array_float.ll"
	.text
	.globl	row_sum                         # -- Begin function row_sum
	.p2align	1
	.type	row_sum,@function
row_sum:                                # @row_sum
# %bb.0:                                # %entry
	sext.w	a1, a1
	slli	a2, a1, 2
	slli	a1, a1, 4
	sub	a1, a1, a2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a2, 4(a0)
	lw	a0, 8(a0)
	add	a1, a1, a2
	addw	a0, a0, a1
	ret
.Lfunc_end0:
	.size	row_sum, .Lfunc_end0-row_sum
                                        # -- End function
	.globl	twice                           # -- Begin function twice
	.p2align	1
	.type	twice,@function
twice:                                  # @twice
# %bb.0:                                # %entry
	fadd.s	fa0, fa0, fa0
	ret
.Lfunc_end1:
	.size	twice, .Lfunc_end1-twice
                                        # -- End function
	.globl	main                            # -- Begin function main
	.p2align	1
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	addi	sp, sp, -32
	.cfi_def_cfa_offset 32
	sd	ra, 24(sp)                      # 8-byte Folded Spill
	sd	s0, 16(sp)                      # 8-byte Folded Spill
	fsd	fs0, 8(sp)                      # 8-byte Folded Spill
	.cfi_offset ra, -8
	.cfi_offset s0, -16
	.cfi_offset fs0, -24
	call	getint
	fcvt.s.w	fa5, a0
	lui	a0, 261120
	fmv.w.x	fa4, a0
	lui	a0, 258048
	fmul.s	fa5, fa5, fa4
	fmv.w.x	fa4, a0
	fadd.s	fa5, fa5, fa4
	fadd.s	fs0, fa5, fa5
	fcvt.w.s	s0, fs0, rtz
	li	a0, 10
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
	ld	ra, 24(sp)                      # 8-byte Folded Reload
	ld	s0, 16(sp)                      # 8-byte Folded Reload
	fld	fs0, 8(sp)                      # 8-byte Folded Reload
	.cfi_restore ra
	.cfi_restore s0
	.cfi_restore fs0
	addi	sp, sp, 32
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
