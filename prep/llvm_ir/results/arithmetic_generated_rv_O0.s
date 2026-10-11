	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.file	"arithmetic.ll"
	.text
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
	sd	s1, 8(sp)                       # 8-byte Folded Spill
	.cfi_offset ra, -8
	.cfi_offset s0, -16
	.cfi_offset s1, -24
	call	getint
	mv	s0, a0
	slli	a0, a0, 1
	srliw	a1, s0, 31
	sext.w	s1, s0
	lui	a2, 349525
	add	a1, a1, s0
	addi	a2, a2, 1366
	sraiw	a1, a1, 1
	mul	a2, s1, a2
	srli	a3, a2, 63
	srli	a2, a2, 32
	add	a2, a2, a3
	slli	a3, a2, 1
	subw	a2, s0, a2
	subw	a2, a2, a3
	subw	a0, a0, a1
	add	a0, a0, a2
	addiw	a0, a0, 13
	call	putint
	li	a0, 10
	call	putch
	negw	a0, s0
	call	putint
	li	a0, 10
	call	putch
	mv	a0, s0
	call	putint
	li	a0, 10
	call	putch
	seqz	a0, s1
	addw	a0, a0, s0
	call	putint
	li	a0, 10
	call	putch
	li	a0, 0
	ld	ra, 24(sp)                      # 8-byte Folded Reload
	ld	s0, 16(sp)                      # 8-byte Folded Reload
	ld	s1, 8(sp)                       # 8-byte Folded Reload
	.cfi_restore ra
	.cfi_restore s0
	.cfi_restore s1
	addi	sp, sp, 32
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
