	.file	"fib.cpp"
	.option pic
	.text
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
.LFB1788:
	.cfi_startproc
	addi	sp,sp,-64
	.cfi_def_cfa_offset 64
	sd	s2,32(sp)
	.cfi_offset 18, -32
	la	s2,__stack_chk_guard
	ld	a5, 0(s2)
	sd	a5, 8(sp)
	li	a5, 0
	addi	a1,sp,4
	la	a0,_ZSt3cin
	sd	ra,56(sp)
	sd	s0,48(sp)
	sd	s1,40(sp)
	sd	s4,16(sp)
	sd	s3,24(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	.cfi_offset 9, -24
	.cfi_offset 20, -48
	.cfi_offset 19, -40
	call	_ZNSirsERi@plt
	li	a1,0
	la	a0,_ZSt4cout
	call	_ZNSolsEi@plt
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@plt
	li	a1,1
	la	a0,_ZSt4cout
	call	_ZNSolsEi@plt
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@plt
	li	s0,1
	li	s1,1
	li	a5,0
	la	s4,_ZSt4cout
.L2:
	lw	a4,4(sp)
	bgt	a4,s0,.L3
	ld	a4, 8(sp)
	ld	a5, 0(s2)
	xor	a5, a4, a5
	li	a4, 0
	beq	a5,zero,.L4
	call	__stack_chk_fail@plt
.L3:
	addw	s3,a5,s1
	mv	a1,s3
	mv	a0,s4
	call	_ZNSolsEi@plt
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@plt
	mv	a5,s1
	addiw	s0,s0,1
	mv	s1,s3
	j	.L2
.L4:
	ld	ra,56(sp)
	.cfi_restore 1
	ld	s0,48(sp)
	.cfi_restore 8
	ld	s1,40(sp)
	.cfi_restore 9
	ld	s2,32(sp)
	.cfi_restore 18
	ld	s3,24(sp)
	.cfi_restore 19
	ld	s4,16(sp)
	.cfi_restore 20
	li	a0,0
	addi	sp,sp,64
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE1788:
	.size	main, .-main
	.align	1
	.type	_GLOBAL__sub_I_main, @function
_GLOBAL__sub_I_main:
.LFB2275:
	.cfi_startproc
	lla	a1,.LANCHOR0
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	mv	a0,a1
	sd	ra,8(sp)
	.cfi_offset 1, -8
	call	_ZNSt8ios_base4InitC1Ev@plt
	ld	ra,8(sp)
	.cfi_restore 1
	lla	a2,__dso_handle
	lla	a1,.LANCHOR0
	la	a0,_ZNSt8ios_base4InitD1Ev
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	tail	__cxa_atexit@plt
	.cfi_endproc
.LFE2275:
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
