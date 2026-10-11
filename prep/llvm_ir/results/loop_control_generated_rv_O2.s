	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.file	"loop_control.ll"
	.text
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
	sext.w	a1, a0
	blez	a1, .LBB0_7
# %bb.1:                                # %body.peel.preheader
	li	a0, 0
	li	a4, 0
	li	a2, 2
	li	a3, 4
	j	.LBB0_4
.LBB0_2:                                # %break.test
                                        #   in Loop: Header=BB0_4 Depth=1
	blt	a3, a4, .LBB0_8
.LBB0_3:                                # %accumulate
                                        #   in Loop: Header=BB0_4 Depth=1
	addw	a0, a0, a5
	mv	a4, a5
	bge	a5, a1, .LBB0_8
.LBB0_4:                                # %body.peel
                                        # =>This Inner Loop Header: Depth=1
	addiw	a5, a4, 1
	bne	a5, a2, .LBB0_2
# %bb.5:                                # %header
                                        #   in Loop: Header=BB0_4 Depth=1
	bge	a2, a1, .LBB0_8
# %bb.6:                                #   in Loop: Header=BB0_4 Depth=1
	li	a5, 3
	j	.LBB0_3
.LBB0_7:
	li	a0, 0
.LBB0_8:                                # %done
	call	putint
	li	a0, 10
	call	putch
	li	a0, 0
	ld	ra, 8(sp)                       # 8-byte Folded Reload
	.cfi_restore ra
	addi	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
