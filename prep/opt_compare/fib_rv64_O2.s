	.file	"fib.cpp"
	.option pic
	.text
	.section	.text._ZNKSt5ctypeIcE8do_widenEc,"axG",@progbits,_ZNKSt5ctypeIcE8do_widenEc,comdat
	.align	1
	.weak	_ZNKSt5ctypeIcE8do_widenEc
	.type	_ZNKSt5ctypeIcE8do_widenEc, @function
_ZNKSt5ctypeIcE8do_widenEc:
.LFB1561:
	.cfi_startproc
	mv	a0,a1
	ret
	.cfi_endproc
.LFE1561:
	.size	_ZNKSt5ctypeIcE8do_widenEc, .-_ZNKSt5ctypeIcE8do_widenEc
	.text
	.align	1
	.type	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_.isra.0, @function
_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_.isra.0:
.LFB2298:
	.cfi_startproc
	ld	a5,0(a0)
	addi	sp,sp,-32
	.cfi_def_cfa_offset 32
	sd	s1,8(sp)
	ld	a5,-24(a5)
	sd	ra,24(sp)
	sd	s0,16(sp)
	.cfi_offset 9, -24
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	add	a5,a0,a5
	ld	s1,240(a5)
	beq	s1,zero,.L9
	lbu	a5,56(s1)
	mv	s0,a0
	beq	a5,zero,.L5
	lbu	a1,67(s1)
.L6:
	mv	a0,s0
	call	_ZNSo3putEc@plt
	ld	s0,16(sp)
	.cfi_remember_state
	.cfi_restore 8
	ld	ra,24(sp)
	.cfi_restore 1
	ld	s1,8(sp)
	.cfi_restore 9
	addi	sp,sp,32
	.cfi_def_cfa_offset 0
	tail	_ZNSo5flushEv@plt
.L5:
	.cfi_restore_state
	mv	a0,s1
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@plt
	ld	a5,0(s1)
	lla	a4,_ZNKSt5ctypeIcE8do_widenEc
	li	a1,10
	ld	a5,48(a5)
	beq	a5,a4,.L6
	mv	a0,s1
	jalr	a5
	mv	a1,a0
	j	.L6
.L9:
	call	_ZSt16__throw_bad_castv@plt
	.cfi_endproc
.LFE2298:
	.size	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_.isra.0, .-_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_.isra.0
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
.LFB1808:
	.cfi_startproc
	addi	sp,sp,-96
	.cfi_def_cfa_offset 96
	sd	s7,24(sp)
	.cfi_offset 23, -72
	la	s7,__stack_chk_guard
	ld	a5, 0(s7)
	sd	a5, 8(sp)
	li	a5, 0
	addi	a1,sp,4
	la	a0,_ZSt3cin
	sd	ra,88(sp)
	sd	s0,80(sp)
	sd	s1,72(sp)
	sd	s2,64(sp)
	sd	s3,56(sp)
	sd	s4,48(sp)
	sd	s5,40(sp)
	sd	s6,32(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	.cfi_offset 9, -24
	.cfi_offset 18, -32
	.cfi_offset 19, -40
	.cfi_offset 20, -48
	.cfi_offset 21, -56
	.cfi_offset 22, -64
	call	_ZNSirsERi@plt
	li	a1,0
	la	a0,_ZSt4cout
	call	_ZNSolsEi@plt
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_.isra.0
	li	a1,1
	la	a0,_ZSt4cout
	call	_ZNSolsEi@plt
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_.isra.0
	lw	a4,4(sp)
	li	a5,1
	ble	a4,a5,.L11
	li	s3,1
	li	s2,1
	li	a5,0
	la	s5,_ZSt4cout
	lla	s6,_ZNKSt5ctypeIcE8do_widenEc
	j	.L15
.L21:
	lbu	a1,67(s1)
.L14:
	mv	a0,s0
	call	_ZNSo3putEc@plt
	call	_ZNSo5flushEv@plt
	lw	a4,4(sp)
	addiw	s3,s3,1
	mv	a5,s4
	ble	a4,s3,.L11
.L15:
	mv	s4,s2
	addw	s2,s2,a5
	mv	a1,s2
	mv	a0,s5
	call	_ZNSolsEi@plt
	ld	a5,0(a0)
	mv	s0,a0
	ld	a5,-24(a5)
	add	a5,a0,a5
	ld	s1,240(a5)
	beq	s1,zero,.L20
	lbu	a5,56(s1)
	bne	a5,zero,.L21
	mv	a0,s1
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@plt
	ld	a5,0(s1)
	li	a1,10
	ld	a5,48(a5)
	beq	a5,s6,.L14
	mv	a0,s1
	jalr	a5
	mv	a1,a0
	j	.L14
.L11:
	ld	a4, 8(sp)
	ld	a5, 0(s7)
	xor	a5, a4, a5
	li	a4, 0
	bne	a5,zero,.L22
	ld	ra,88(sp)
	.cfi_remember_state
	.cfi_restore 1
	ld	s0,80(sp)
	.cfi_restore 8
	ld	s1,72(sp)
	.cfi_restore 9
	ld	s2,64(sp)
	.cfi_restore 18
	ld	s3,56(sp)
	.cfi_restore 19
	ld	s4,48(sp)
	.cfi_restore 20
	ld	s5,40(sp)
	.cfi_restore 21
	ld	s6,32(sp)
	.cfi_restore 22
	ld	s7,24(sp)
	.cfi_restore 23
	li	a0,0
	addi	sp,sp,96
	.cfi_def_cfa_offset 0
	jr	ra
.L20:
	.cfi_restore_state
	call	_ZSt16__throw_bad_castv@plt
.L22:
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
	sd	s0,0(sp)
	.cfi_offset 8, -16
	lla	s0,.LANCHOR0
	mv	a0,s0
	sd	ra,8(sp)
	.cfi_offset 1, -8
	call	_ZNSt8ios_base4InitC1Ev@plt
	mv	a1,s0
	ld	s0,0(sp)
	.cfi_restore 8
	ld	ra,8(sp)
	.cfi_restore 1
	lla	a2,__dso_handle
	la	a0,_ZNSt8ios_base4InitD1Ev
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	tail	__cxa_atexit@plt
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
