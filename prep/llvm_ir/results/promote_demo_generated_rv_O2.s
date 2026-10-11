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
	blez	a0, .LBB0_2
# %bb.1:                                # %body.preheader
	addi	a1, a0, -1
	addi	a0, a0, -2
	slli	a0, a0, 32
	slli	a2, a1, 32
	mulhu	a0, a2, a0
	srli	a0, a0, 1
	addw	a0, a0, a1
	j	.LBB0_3
.LBB0_2:
	li	a0, 0
.LBB0_3:                                # %done
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
