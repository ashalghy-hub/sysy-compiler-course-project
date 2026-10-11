	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.file	"promote_demo.ll"
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
	sext.w	a0, a0
	sw	zero, 4(sp)
	sw	zero, 0(sp)
	lw	a1, 4(sp)
	bge	a1, a0, .LBB0_2
.LBB0_1:                                # %body
                                        # =>This Inner Loop Header: Depth=1
	lw	a2, 0(sp)
	add	a2, a2, a1
	addi	a1, a1, 1
	sw	a2, 0(sp)
	sw	a1, 4(sp)
	lw	a1, 4(sp)
	blt	a1, a0, .LBB0_1
.LBB0_2:                                # %done
	lw	a0, 0(sp)
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
