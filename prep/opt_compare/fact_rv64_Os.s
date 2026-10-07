	.file	"fact.cpp"
	.option pic
	.text
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
.LFB1788:
	.cfi_startproc
	addi	sp,sp,-32
	.cfi_def_cfa_offset 32
	sd	s0,16(sp)
	.cfi_offset 8, -16
	la	s0,__stack_chk_guard
	ld	a5, 0(s0)
	sd	a5, 8(sp)
	li	a5, 0
	addi	a1,sp,4
	la	a0,_ZSt3cin
	sd	ra,24(sp)
	.cfi_offset 1, -8
	call	_ZNSirsERi@plt
	lw	a4,4(sp)
	li	a1,1
	li	a5,2
.L2:
	bge	a4,a5,.L3
	la	a0,_ZSt4cout
	call	_ZNSolsEi@plt
	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@plt
	ld	a4, 8(sp)
	ld	a5, 0(s0)
	xor	a5, a4, a5
	li	a4, 0
	beq	a5,zero,.L4
	call	__stack_chk_fail@plt
.L3:
	mulw	a1,a5,a1
	addiw	a5,a5,1
	j	.L2
.L4:
	ld	ra,24(sp)
	.cfi_restore 1
	ld	s0,16(sp)
	.cfi_restore 8
	li	a0,0
	addi	sp,sp,32
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
