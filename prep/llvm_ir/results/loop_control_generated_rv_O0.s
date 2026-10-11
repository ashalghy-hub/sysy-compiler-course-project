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
	mv	a1, a0
	li	a4, 0
	li	a0, 0
	sext.w	a1, a1
	li	a2, 1
	li	a3, 5
.LBB0_1:                                # %header.outer
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	mv	a5, a4
	bge	a4, a1, .LBB0_6
.LBB0_2:                                # %body
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	bne	a5, a2, .LBB0_4
# %bb.3:                                # %skip
                                        #   in Loop: Header=BB0_2 Depth=2
	addiw	a5, a5, 1
	blt	a5, a1, .LBB0_2
	j	.LBB0_6
.LBB0_4:                                # %break.test
                                        #   in Loop: Header=BB0_1 Depth=1
	addiw	a4, a5, 1
	blt	a3, a4, .LBB0_6
# %bb.5:                                # %accumulate
                                        #   in Loop: Header=BB0_1 Depth=1
	add	a0, a0, a5
	addiw	a0, a0, 1
	j	.LBB0_1
.LBB0_6:                                # %done
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
