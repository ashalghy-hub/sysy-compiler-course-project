	.file	"fact.cpp"
	.option pic
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
.LFB1808:
	.cfi_startproc
	addi	sp,sp,-32
	.cfi_def_cfa_offset 32
	sd	ra,24(sp)
	.cfi_offset 1, -8
	la	a5,__stack_chk_guard
	ld	a4, 0(a5)
	sd	a4, 8(sp)
	li	a4, 0
	addi	a1,sp,4
	la	a0,_ZSt3cin
	call	_ZNSirsERi@plt
	lw	a4,4(sp)
	li	a5,1
	ble	a4,a5,.L5
	addiw	a4,a4,1
	li	a1,1
	li	a5,2
.L3:
	mulw	a1,a5,a1
	addiw	a5,a5,1
	bne	a5,a4,.L3
.L2:
	la	a0,_ZSt4cout
	call	_ZNSolsEi@plt
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@plt
	la	a5,__stack_chk_guard
	ld	a4, 8(sp)
	ld	a5, 0(a5)
	xor	a5, a4, a5
	li	a4, 0
	bne	a5,zero,.L8
	li	a0,0
	ld	ra,24(sp)
	.cfi_remember_state
	.cfi_restore 1
	addi	sp,sp,32
	.cfi_def_cfa_offset 0
	jr	ra
.L5:
	.cfi_restore_state
	li	a1,1
	j	.L2
.L8:
	call	__stack_chk_fail@plt
	.cfi_endproc
.LFE1808:
	.size	main, .-main
	.align	1
	.type	_GLOBAL__sub_I_main, @function
_GLOBAL__sub_I_main:
.LFB2295:
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sd	ra,8(sp)
	sd	s0,0(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	lla	s0,.LANCHOR0
	mv	a0,s0
	call	_ZNSt8ios_base4InitC1Ev@plt
	lla	a2,__dso_handle
	mv	a1,s0
	la	a0,_ZNSt8ios_base4InitD1Ev
	call	__cxa_atexit@plt
	ld	ra,8(sp)
	.cfi_restore 1
	ld	s0,0(sp)
	.cfi_restore 8
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE2295:
	.size	_GLOBAL__sub_I_main, .-_GLOBAL__sub_I_main
	.section	.init_array,"aw"
	.align	3
	.dword	_GLOBAL__sub_I_main
	.bss
	.align	3
	.set	.LANCHOR0,. + 0
	.type	_ZStL8__ioinit, @object
	.size	_ZStL8__ioinit, 1
_ZStL8__ioinit:
	.zero	1
	.hidden	__dso_handle
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
