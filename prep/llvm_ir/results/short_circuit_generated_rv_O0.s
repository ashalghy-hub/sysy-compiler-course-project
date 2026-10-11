	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.file	"short_circuit.ll"
	.text
	.globl	touch                           # -- Begin function touch
	.p2align	1
	.type	touch,@function
touch:                                  # @touch
	.cfi_startproc
# %bb.0:                                # %entry
	lui	a1, %hi(hits)
	lw	a0, %lo(hits)(a1)
	addi	a2, a0, 1
	li	a0, 1
	sw	a2, %lo(hits)(a1)
	ret
.Lfunc_end0:
	.size	touch, .Lfunc_end0-touch
	.cfi_endproc
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
	sd	s1, 8(sp)                       # 8-byte Folded Spill
	.cfi_offset ra, -8
	.cfi_offset s0, -16
	.cfi_offset s1, -24
	call	getint
	sext.w	s1, a0
	beqz	s1, .LBB1_3
# %bb.1:                                # %and.rhs
	li	a1, 12
	divw	a0, a1, a0
	li	a1, 2
	bge	a1, a0, .LBB1_3
# %bb.2:
	li	a0, 1
	j	.LBB1_4
.LBB1_3:                                # %and.false
	li	a0, 0
.LBB1_4:                                # %and.join
	call	putint
	li	a0, 10
	call	putch
	li	s0, 2
	beqz	s1, .LBB1_7
# %bb.5:                                # %or.rhs
	call	touch
	sext.w	a0, a0
	bnez	a0, .LBB1_7
# %bb.6:                                # %or.false
	li	s0, 3
.LBB1_7:                                # %or.join
	mv	a0, s0
	call	putint
	li	a0, 10
	call	putch
	lui	a0, %hi(hits)
	lw	a0, %lo(hits)(a0)
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
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.type	hits,@object                    # @hits
	.bss
	.globl	hits
	.p2align	2, 0x0
hits:
	.word	0                               # 0x0
	.size	hits, 4

	.section	".note.GNU-stack","",@progbits
