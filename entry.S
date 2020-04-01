#define LOADADDR       0x8000
#define BOOTADDR       0x1000

    .extern _cstart
    .extern _edata, _end

    .text
    .globl _entry
_entry:
    mov r0, #LOADADDR
    mov r1, #BOOTADDR
	ldr r2, =_end
	sub r2, r2, #BOOTADDR
copy:
    ldmia r0!, {r3}
    stmia r1!, {r3}
	sub r2, r2, #4
	cmp r2, #0
	bne copy

	bl trampoline

	@zeroify bss
	ldr r0, =_edata
	ldr r1, =_end
	ldr r2, =0x0
zeroify:
	cmp		r1, r0
	ble		zeroify.1
	stmia	r0!, {r2}
	b		zeroify
zeroify.1:

    mov sp, #BOOTADDR
    b _cstart

trampoline:
	sub lr, lr, #(LOADADDR-BOOTADDR)
	bx lr