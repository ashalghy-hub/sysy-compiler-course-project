	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.file	"functions.ll"
	.text
	.globl	factorial                       # -- Begin function factorial
	.p2align	1
	.type	factorial,@function
factorial:                              # @factorial
# %bb.0:                                # %entry
	mv	a1, a0
	sext.w	a0, a0
	li	a2, 2
	bge	a0, a2, .LBB0_2
# %bb.1:
	li	a0, 1
	ret
.LBB0_2:                                # %recursive.preheader
	li	a0, 1
	li	a2, 3
.LBB0_3:                                # %recursive
                                        # =>This Inner Loop Header: Depth=1
	sext.w	a3, a1
	addi	a4, a1, -1
	mulw	a0, a1, a0
	mv	a1, a4
	bgeu	a3, a2, .LBB0_3
# %bb.4:                                # %common.ret
	ret
.Lfunc_end0:
	.size	factorial, .Lfunc_end0-factorial
                                        # -- End function
	.globl	emit                            # -- Begin function emit
	.p2align	1
	.type	emit,@function
emit:                                   # @emit
	.cfi_startproc
# %bb.0:                                # %entry
	addi	sp, sp, -16
	.cfi_def_cfa_offset 16
	sd	ra, 8(sp)                       # 8-byte Folded Spill
	.cfi_offset ra, -8
	call	putint
	li	a0, 10
	ld	ra, 8(sp)                       # 8-byte Folded Reload
	.cfi_restore ra
	addi	sp, sp, 16
	.cfi_def_cfa_offset 0
	tail	putch
.Lfunc_end1:
	.size	emit, .Lfunc_end1-emit
	.cfi_endproc
                                        # -- End function
	.globl	main                            # -- Begin function main
	.p2align	1
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	addi	sp, sp, -16
	.cfi_def_cfa_offset 16
	sd	ra, 8(sp)                       # 8-byte Folded Spill
	.cfi_offset ra, -8
	call	getint
	sext.w	a2, a0
	li	a0, 1
	li	a1, 2
	blt	a2, a1, .LBB2_2
.LBB2_1:                                # %recursive.i
                                        # =>This Inner Loop Header: Depth=1
	mv	a3, a2
	addiw	a2, a2, -1
	mulw	a0, a0, a3
	bltu	a1, a3, .LBB2_1
.LBB2_2:                                # %factorial.exit
	call	putint
	li	a0, 10
	call	putch
	li	a0, 0
	ld	ra, 8(sp)                       # 8-byte Folded Reload
	.cfi_restore ra
	addi	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
