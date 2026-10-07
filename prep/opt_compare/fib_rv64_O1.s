	.file	"fib.cpp"
	.option pic
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
.LFB1808:
	.cfi_startproc
	addi	sp,sp,-80
	.cfi_def_cfa_offset 80
	sd	ra,72(sp)
	sd	s0,64(sp)
	sd	s1,56(sp)
	sd	s2,48(sp)
	sd	s3,40(sp)
	sd	s4,32(sp)
	sd	s5,24(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	.cfi_offset 9, -24
	.cfi_offset 18, -32
	.cfi_offset 19, -40
	.cfi_offset 20, -48
	.cfi_offset 21, -56
	la	a5,__stack_chk_guard
	ld	a4, 0(a5)
	sd	a4, 8(sp)
	li	a4, 0
	addi	a1,sp,4
	la	a0,_ZSt3cin
	call	_ZNSirsERi@plt
	li	a1,0
	la	a0,_ZSt4cout
	call	_ZNSolsEi@plt
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@plt
	li	a1,1
	la	a0,_ZSt4cout
	call	_ZNSolsEi@plt
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@plt
	lw	a4,4(sp)
	li	a5,1
	ble	a4,a5,.L2
	li	s3,1
	li	s2,1
	li	a5,0
	la	s5,_ZSt4cout
	j	.L6
.L10:
	call	_ZSt16__throw_bad_castv@plt
.L4:
	mv	a0,s1
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@plt
	ld	a5,0(s1)
	ld	a5,48(a5)
	li	a1,10
	mv	a0,s1
	jalr	a5
	mv	a1,a0
.L5:
	mv	a0,s0
	call	_ZNSo3putEc@plt
	call	_ZNSo5flushEv@plt
	addiw	s3,s3,1
	mv	a5,s4
	lw	a4,4(sp)
	ble	a4,s3,.L2
.L6:
	mv	s4,s2
	addw	s2,s2,a5
	mv	a1,s2
	mv	a0,s5
	call	_ZNSolsEi@plt
	mv	s0,a0
	ld	a5,0(a0)
	ld	a5,-24(a5)
	add	a5,a0,a5
	ld	s1,240(a5)
	beq	s1,zero,.L10
	lbu	a5,56(s1)
	beq	a5,zero,.L4
	lbu	a1,67(s1)
	j	.L5
.L2:
	la	a5,__stack_chk_guard
	ld	a4, 8(sp)
	ld	a5, 0(a5)
	xor	a5, a4, a5
	li	a4, 0
	bne	a5,zero,.L11
	li	a0,0
	ld	ra,72(sp)
	.cfi_remember_state
	.cfi_restore 1
	ld	s0,64(sp)
	.cfi_restore 8
	ld	s1,56(sp)
	.cfi_restore 9
	ld	s2,48(sp)
	.cfi_restore 18
	ld	s3,40(sp)
	.cfi_restore 19
	ld	s4,32(sp)
	.cfi_restore 20
	ld	s5,24(sp)
	.cfi_restore 21
	addi	sp,sp,80
	.cfi_def_cfa_offset 0
	jr	ra
.L11:
	.cfi_restore_state
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
