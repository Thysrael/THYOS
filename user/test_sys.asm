
test_sys.elf:     file format elf64-littleaarch64
test_sys.elf


Disassembly of section .text.boot:

0000000000400000 <_start>:
_start():
  400000:	d10043ff 	sub	sp, sp, #0x10
  400004:	f94003e0 	ldr	x0, [sp]
  400008:	f94007e1 	ldr	x1, [sp, #8]
  40000c:	9400017a 	bl	4005f4 <libmain>

Disassembly of section .text:

0000000000400010 <umain>:
umain():
  400010:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
  400014:	910003fd 	mov	x29, sp
  400018:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  40001c:	91018000 	add	x0, x0, #0x60
  400020:	9400065e 	bl	401998 <writef>
  400024:	d503201f 	nop
  400028:	a8c17bfd 	ldp	x29, x30, [sp], #16
  40002c:	d65f03c0 	ret

0000000000400030 <__asm_pgfault_handler>:
__asm_pgfault_handler():
  400030:	f9408be0 	ldr	x0, [sp, #272]
  400034:	58010770 	ldr	x16, 402120 <__pgfault_handler>
  400038:	d63f0200 	blr	x16
  40003c:	a94007e0 	ldp	x0, x1, [sp]
  400040:	a9410fe2 	ldp	x2, x3, [sp, #16]
  400044:	a94217e4 	ldp	x4, x5, [sp, #32]
  400048:	a9431fe6 	ldp	x6, x7, [sp, #48]
  40004c:	a94427e8 	ldp	x8, x9, [sp, #64]
  400050:	a9452fea 	ldp	x10, x11, [sp, #80]
  400054:	a94637ec 	ldp	x12, x13, [sp, #96]
  400058:	a9473fee 	ldp	x14, x15, [sp, #112]
  40005c:	a94847f0 	ldp	x16, x17, [sp, #128]
  400060:	a9494ff2 	ldp	x18, x19, [sp, #144]
  400064:	a94a57f4 	ldp	x20, x21, [sp, #160]
  400068:	a94b5ff6 	ldp	x22, x23, [sp, #176]
  40006c:	a94c67f8 	ldp	x24, x25, [sp, #192]
  400070:	a94d6ffa 	ldp	x26, x27, [sp, #208]
  400074:	a94e77fc 	ldp	x28, x29, [sp, #224]
  400078:	f9407bfe 	ldr	x30, [sp, #240]
  40007c:	f94087f1 	ldr	x17, [sp, #264]
  400080:	f9407ff0 	ldr	x16, [sp, #248]
  400084:	d5184110 	msr	sp_el0, x16
  400088:	d61f0220 	br	x17

000000000040008c <pgfault>:
pgfault():
  40008c:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
  400090:	910003fd 	mov	x29, sp
  400094:	f9000fe0 	str	x0, [sp, #24]
  400098:	b27347e0 	mov	x0, #0x7fffe000            	// #2147475456
  40009c:	f2c007e0 	movk	x0, #0x3f, lsl #32
  4000a0:	f90017e0 	str	x0, [sp, #40]
  4000a4:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  4000a8:	9100e000 	add	x0, x0, #0x38
  4000ac:	f9400001 	ldr	x1, [x0]
  4000b0:	f9400fe0 	ldr	x0, [sp, #24]
  4000b4:	d34cfc00 	lsr	x0, x0, #12
  4000b8:	d37df000 	lsl	x0, x0, #3
  4000bc:	8b000020 	add	x0, x1, x0
  4000c0:	f9400000 	ldr	x0, [x0]
  4000c4:	92402c00 	and	x0, x0, #0xfff
  4000c8:	f90013e0 	str	x0, [sp, #32]
  4000cc:	f94013e0 	ldr	x0, [sp, #32]
  4000d0:	92790000 	and	x0, x0, #0x80
  4000d4:	f100001f 	cmp	x0, #0x0
  4000d8:	540000e1 	b.ne	4000f4 <pgfault+0x68>  // b.any
  4000dc:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  4000e0:	9101c002 	add	x2, x0, #0x70
  4000e4:	52800361 	mov	w1, #0x1b                  	// #27
  4000e8:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  4000ec:	91024000 	add	x0, x0, #0x90
  4000f0:	94000656 	bl	401a48 <_user_panic>
  4000f4:	f94013e0 	ldr	x0, [sp, #32]
  4000f8:	d1020000 	sub	x0, x0, #0x80
  4000fc:	f90013e0 	str	x0, [sp, #32]
  400100:	f94013e2 	ldr	x2, [sp, #32]
  400104:	f94017e1 	ldr	x1, [sp, #40]
  400108:	52800000 	mov	w0, #0x0                   	// #0
  40010c:	9400073c 	bl	401dfc <syscall_mem_alloc>
  400110:	f9400fe0 	ldr	x0, [sp, #24]
  400114:	9274cc00 	and	x0, x0, #0xfffffffffffff000
  400118:	aa0003e3 	mov	x3, x0
  40011c:	f94017e0 	ldr	x0, [sp, #40]
  400120:	52820002 	mov	w2, #0x1000                	// #4096
  400124:	aa0003e1 	mov	x1, x0
  400128:	aa0303e0 	mov	x0, x3
  40012c:	940000f1 	bl	4004f0 <user_bcopy>
  400130:	f94013e4 	ldr	x4, [sp, #32]
  400134:	f9400fe3 	ldr	x3, [sp, #24]
  400138:	52800002 	mov	w2, #0x0                   	// #0
  40013c:	f94017e1 	ldr	x1, [sp, #40]
  400140:	52800000 	mov	w0, #0x0                   	// #0
  400144:	9400073d 	bl	401e38 <syscall_mem_map>
  400148:	f94017e1 	ldr	x1, [sp, #40]
  40014c:	52800000 	mov	w0, #0x0                   	// #0
  400150:	9400074c 	bl	401e80 <syscall_mem_unmap>
  400154:	d503201f 	nop
  400158:	a8c37bfd 	ldp	x29, x30, [sp], #48
  40015c:	d65f03c0 	ret

0000000000400160 <duppage>:
duppage():
  400160:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
  400164:	910003fd 	mov	x29, sp
  400168:	b9001fe0 	str	w0, [sp, #28]
  40016c:	f9000be1 	str	x1, [sp, #16]
  400170:	f9400be0 	ldr	x0, [sp, #16]
  400174:	d374cc00 	lsl	x0, x0, #12
  400178:	f9001fe0 	str	x0, [sp, #56]
  40017c:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  400180:	9100e000 	add	x0, x0, #0x38
  400184:	f9400001 	ldr	x1, [x0]
  400188:	f9400be0 	ldr	x0, [sp, #16]
  40018c:	d37df000 	lsl	x0, x0, #3
  400190:	8b000020 	add	x0, x1, x0
  400194:	f9400000 	ldr	x0, [x0]
  400198:	92402c00 	and	x0, x0, #0xfff
  40019c:	f9001be0 	str	x0, [sp, #48]
  4001a0:	b9002fff 	str	wzr, [sp, #44]
  4001a4:	f9401be4 	ldr	x4, [sp, #48]
  4001a8:	f9401fe3 	ldr	x3, [sp, #56]
  4001ac:	b9401fe2 	ldr	w2, [sp, #28]
  4001b0:	f9401fe1 	ldr	x1, [sp, #56]
  4001b4:	52800000 	mov	w0, #0x0                   	// #0
  4001b8:	94000720 	bl	401e38 <syscall_mem_map>
  4001bc:	b9402fe0 	ldr	w0, [sp, #44]
  4001c0:	7100001f 	cmp	w0, #0x0
  4001c4:	540000e0 	b.eq	4001e0 <duppage+0x80>  // b.none
  4001c8:	f9401be4 	ldr	x4, [sp, #48]
  4001cc:	f9401fe3 	ldr	x3, [sp, #56]
  4001d0:	52800002 	mov	w2, #0x0                   	// #0
  4001d4:	f9401fe1 	ldr	x1, [sp, #56]
  4001d8:	52800000 	mov	w0, #0x0                   	// #0
  4001dc:	94000717 	bl	401e38 <syscall_mem_map>
  4001e0:	d503201f 	nop
  4001e4:	a8c47bfd 	ldp	x29, x30, [sp], #64
  4001e8:	d65f03c0 	ret

00000000004001ec <fork>:
fork():
  4001ec:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
  4001f0:	910003fd 	mov	x29, sp
  4001f4:	f9000bf3 	str	x19, [sp, #16]
  4001f8:	90000000 	adrp	x0, 400000 <_start>
  4001fc:	91023000 	add	x0, x0, #0x8c
  400200:	94000057 	bl	40035c <set_pgfault_handler>
  400204:	9400072d 	bl	401eb8 <syscall_env_alloc>
  400208:	b90027e0 	str	w0, [sp, #36]
  40020c:	b94027e0 	ldr	w0, [sp, #36]
  400210:	7100001f 	cmp	w0, #0x0
  400214:	54000261 	b.ne	400260 <fork+0x74>  // b.any
  400218:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  40021c:	91016000 	add	x0, x0, #0x58
  400220:	f9400013 	ldr	x19, [x0]
  400224:	940006c2 	bl	401d2c <syscall_getenvid>
  400228:	2a0003e0 	mov	w0, w0
  40022c:	92402401 	and	x1, x0, #0x3ff
  400230:	aa0103e0 	mov	x0, x1
  400234:	d37ff800 	lsl	x0, x0, #1
  400238:	8b010000 	add	x0, x0, x1
  40023c:	d37cec01 	lsl	x1, x0, #4
  400240:	8b010000 	add	x0, x0, x1
  400244:	d37df000 	lsl	x0, x0, #3
  400248:	8b000261 	add	x1, x19, x0
  40024c:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  400250:	9104a000 	add	x0, x0, #0x128
  400254:	f9000001 	str	x1, [x0]
  400258:	52800000 	mov	w0, #0x0                   	// #0
  40025c:	1400003d 	b	400350 <fork+0x164>
  400260:	f90017ff 	str	xzr, [sp, #40]
  400264:	14000027 	b	400300 <fork+0x114>
  400268:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  40026c:	91012000 	add	x0, x0, #0x48
  400270:	f9400001 	ldr	x1, [x0]
  400274:	f94017e0 	ldr	x0, [sp, #40]
  400278:	d352fc00 	lsr	x0, x0, #18
  40027c:	d37df000 	lsl	x0, x0, #3
  400280:	8b000020 	add	x0, x1, x0
  400284:	f9400000 	ldr	x0, [x0]
  400288:	92400000 	and	x0, x0, #0x1
  40028c:	f100001f 	cmp	x0, #0x0
  400290:	54000320 	b.eq	4002f4 <fork+0x108>  // b.none
  400294:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  400298:	91010000 	add	x0, x0, #0x40
  40029c:	f9400001 	ldr	x1, [x0]
  4002a0:	f94017e0 	ldr	x0, [sp, #40]
  4002a4:	d349fc00 	lsr	x0, x0, #9
  4002a8:	d37df000 	lsl	x0, x0, #3
  4002ac:	8b000020 	add	x0, x1, x0
  4002b0:	f9400000 	ldr	x0, [x0]
  4002b4:	92400000 	and	x0, x0, #0x1
  4002b8:	f100001f 	cmp	x0, #0x0
  4002bc:	540001c0 	b.eq	4002f4 <fork+0x108>  // b.none
  4002c0:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  4002c4:	9100e000 	add	x0, x0, #0x38
  4002c8:	f9400001 	ldr	x1, [x0]
  4002cc:	f94017e0 	ldr	x0, [sp, #40]
  4002d0:	d37df000 	lsl	x0, x0, #3
  4002d4:	8b000020 	add	x0, x1, x0
  4002d8:	f9400000 	ldr	x0, [x0]
  4002dc:	92400000 	and	x0, x0, #0x1
  4002e0:	f100001f 	cmp	x0, #0x0
  4002e4:	54000080 	b.eq	4002f4 <fork+0x108>  // b.none
  4002e8:	f94017e1 	ldr	x1, [sp, #40]
  4002ec:	b94027e0 	ldr	w0, [sp, #36]
  4002f0:	97ffff9c 	bl	400160 <duppage>
  4002f4:	f94017e0 	ldr	x0, [sp, #40]
  4002f8:	91000400 	add	x0, x0, #0x1
  4002fc:	f90017e0 	str	x0, [sp, #40]
  400300:	f94017e1 	ldr	x1, [sp, #40]
  400304:	d29fffa0 	mov	x0, #0xfffd                	// #65533
  400308:	f2a07ee0 	movk	x0, #0x3f7, lsl #16
  40030c:	eb00003f 	cmp	x1, x0
  400310:	54fffac9 	b.ls	400268 <fork+0x7c>  // b.plast
  400314:	d280e822 	mov	x2, #0x741                 	// #1857
  400318:	b2744be1 	mov	x1, #0x7ffff000            	// #2147479552
  40031c:	f2c007e1 	movk	x1, #0x3f, lsl #32
  400320:	b94027e0 	ldr	w0, [sp, #36]
  400324:	940006b6 	bl	401dfc <syscall_mem_alloc>
  400328:	90000000 	adrp	x0, 400000 <_start>
  40032c:	9100c000 	add	x0, x0, #0x30
  400330:	b2611be2 	mov	x2, #0x3f80000000          	// #272730423296
  400334:	aa0003e1 	mov	x1, x0
  400338:	b94027e0 	ldr	w0, [sp, #36]
  40033c:	940006a1 	bl	401dc0 <syscall_set_pgfault_handler>
  400340:	52800021 	mov	w1, #0x1                   	// #1
  400344:	b94027e0 	ldr	w0, [sp, #36]
  400348:	940006e7 	bl	401ee4 <syscall_set_env_status>
  40034c:	b94027e0 	ldr	w0, [sp, #36]
  400350:	f9400bf3 	ldr	x19, [sp, #16]
  400354:	a8c37bfd 	ldp	x29, x30, [sp], #48
  400358:	d65f03c0 	ret

000000000040035c <set_pgfault_handler>:
set_pgfault_handler():
  40035c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
  400360:	910003fd 	mov	x29, sp
  400364:	f9000fe0 	str	x0, [sp, #24]
  400368:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  40036c:	91048000 	add	x0, x0, #0x120
  400370:	f9400000 	ldr	x0, [x0]
  400374:	f100001f 	cmp	x0, #0x0
  400378:	54000281 	b.ne	4003c8 <set_pgfault_handler+0x6c>  // b.any
  40037c:	d280e822 	mov	x2, #0x741                 	// #1857
  400380:	b2744be1 	mov	x1, #0x7ffff000            	// #2147479552
  400384:	f2c007e1 	movk	x1, #0x3f, lsl #32
  400388:	52800000 	mov	w0, #0x0                   	// #0
  40038c:	9400069c 	bl	401dfc <syscall_mem_alloc>
  400390:	7100001f 	cmp	w0, #0x0
  400394:	5400012b 	b.lt	4003b8 <set_pgfault_handler+0x5c>  // b.tstop
  400398:	90000000 	adrp	x0, 400000 <_start>
  40039c:	9100c000 	add	x0, x0, #0x30
  4003a0:	b2611be2 	mov	x2, #0x3f80000000          	// #272730423296
  4003a4:	aa0003e1 	mov	x1, x0
  4003a8:	52800000 	mov	w0, #0x0                   	// #0
  4003ac:	94000685 	bl	401dc0 <syscall_set_pgfault_handler>
  4003b0:	7100001f 	cmp	w0, #0x0
  4003b4:	540000aa 	b.ge	4003c8 <set_pgfault_handler+0x6c>  // b.tcont
  4003b8:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  4003bc:	91026000 	add	x0, x0, #0x98
  4003c0:	94000576 	bl	401998 <writef>
  4003c4:	14000005 	b	4003d8 <set_pgfault_handler+0x7c>
  4003c8:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  4003cc:	91048000 	add	x0, x0, #0x120
  4003d0:	f9400fe1 	ldr	x1, [sp, #24]
  4003d4:	f9000001 	str	x1, [x0]
  4003d8:	a8c27bfd 	ldp	x29, x30, [sp], #32
  4003dc:	d65f03c0 	ret

00000000004003e0 <ipc_send>:
ipc_send():
  4003e0:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
  4003e4:	910003fd 	mov	x29, sp
  4003e8:	b9002fe0 	str	w0, [sp, #44]
  4003ec:	b9002be1 	str	w1, [sp, #40]
  4003f0:	f90013e2 	str	x2, [sp, #32]
  4003f4:	f9000fe3 	str	x3, [sp, #24]
  4003f8:	14000002 	b	400400 <ipc_send+0x20>
  4003fc:	94000657 	bl	401d58 <syscall_yield>
  400400:	f9400fe3 	ldr	x3, [sp, #24]
  400404:	f94013e2 	ldr	x2, [sp, #32]
  400408:	b9402be1 	ldr	w1, [sp, #40]
  40040c:	b9402fe0 	ldr	w0, [sp, #44]
  400410:	940006e1 	bl	401f94 <syscall_ipc_can_send>
  400414:	b9003fe0 	str	w0, [sp, #60]
  400418:	b9403fe0 	ldr	w0, [sp, #60]
  40041c:	3100181f 	cmn	w0, #0x6
  400420:	54fffee0 	b.eq	4003fc <ipc_send+0x1c>  // b.none
  400424:	b9403fe0 	ldr	w0, [sp, #60]
  400428:	7100001f 	cmp	w0, #0x0
  40042c:	54000100 	b.eq	40044c <ipc_send+0x6c>  // b.none
  400430:	b9403fe3 	ldr	w3, [sp, #60]
  400434:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  400438:	9102e002 	add	x2, x0, #0xb8
  40043c:	528003c1 	mov	w1, #0x1e                  	// #30
  400440:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  400444:	91034000 	add	x0, x0, #0xd0
  400448:	94000580 	bl	401a48 <_user_panic>
  40044c:	d503201f 	nop
  400450:	a8c47bfd 	ldp	x29, x30, [sp], #64
  400454:	d65f03c0 	ret

0000000000400458 <ipc_recv>:
ipc_recv():
  400458:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
  40045c:	910003fd 	mov	x29, sp
  400460:	f90017e0 	str	x0, [sp, #40]
  400464:	f90013e1 	str	x1, [sp, #32]
  400468:	f9000fe2 	str	x2, [sp, #24]
  40046c:	f94013e0 	ldr	x0, [sp, #32]
  400470:	940006da 	bl	401fd8 <syscall_ipc_recv>
  400474:	f94017e0 	ldr	x0, [sp, #40]
  400478:	f100001f 	cmp	x0, #0x0
  40047c:	540000e0 	b.eq	400498 <ipc_recv+0x40>  // b.none
  400480:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  400484:	9104a000 	add	x0, x0, #0x128
  400488:	f9400000 	ldr	x0, [x0]
  40048c:	b9416801 	ldr	w1, [x0, #360]
  400490:	f94017e0 	ldr	x0, [sp, #40]
  400494:	b9000001 	str	w1, [x0]
  400498:	f9400fe0 	ldr	x0, [sp, #24]
  40049c:	f100001f 	cmp	x0, #0x0
  4004a0:	540000e0 	b.eq	4004bc <ipc_recv+0x64>  // b.none
  4004a4:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  4004a8:	9104a000 	add	x0, x0, #0x128
  4004ac:	f9400000 	ldr	x0, [x0]
  4004b0:	f940bc01 	ldr	x1, [x0, #376]
  4004b4:	f9400fe0 	ldr	x0, [sp, #24]
  4004b8:	f9000001 	str	x1, [x0]
  4004bc:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  4004c0:	9104a000 	add	x0, x0, #0x128
  4004c4:	f9400000 	ldr	x0, [x0]
  4004c8:	b9416400 	ldr	w0, [x0, #356]
  4004cc:	a8c37bfd 	ldp	x29, x30, [sp], #48
  4004d0:	d65f03c0 	ret

00000000004004d4 <exit>:
exit():
  4004d4:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
  4004d8:	910003fd 	mov	x29, sp
  4004dc:	52800000 	mov	w0, #0x0                   	// #0
  4004e0:	9400062a 	bl	401d88 <syscall_env_destroy>
  4004e4:	d503201f 	nop
  4004e8:	a8c17bfd 	ldp	x29, x30, [sp], #16
  4004ec:	d65f03c0 	ret

00000000004004f0 <user_bcopy>:
user_bcopy():
  4004f0:	d100c3ff 	sub	sp, sp, #0x30
  4004f4:	f9000fe0 	str	x0, [sp, #24]
  4004f8:	f9000be1 	str	x1, [sp, #16]
  4004fc:	b9000fe2 	str	w2, [sp, #12]
  400500:	b9400fe0 	ldr	w0, [sp, #12]
  400504:	f9400be1 	ldr	x1, [sp, #16]
  400508:	8b000020 	add	x0, x1, x0
  40050c:	f90017e0 	str	x0, [sp, #40]
  400510:	1400000b 	b	40053c <user_bcopy+0x4c>
  400514:	f9400fe0 	ldr	x0, [sp, #24]
  400518:	b9400001 	ldr	w1, [x0]
  40051c:	f9400be0 	ldr	x0, [sp, #16]
  400520:	b9000001 	str	w1, [x0]
  400524:	f9400be0 	ldr	x0, [sp, #16]
  400528:	91001000 	add	x0, x0, #0x4
  40052c:	f9000be0 	str	x0, [sp, #16]
  400530:	f9400fe0 	ldr	x0, [sp, #24]
  400534:	91001000 	add	x0, x0, #0x4
  400538:	f9000fe0 	str	x0, [sp, #24]
  40053c:	f9400be0 	ldr	x0, [sp, #16]
  400540:	91000c00 	add	x0, x0, #0x3
  400544:	f94017e1 	ldr	x1, [sp, #40]
  400548:	eb00003f 	cmp	x1, x0
  40054c:	54fffe48 	b.hi	400514 <user_bcopy+0x24>  // b.pmore
  400550:	1400000b 	b	40057c <user_bcopy+0x8c>
  400554:	f9400fe0 	ldr	x0, [sp, #24]
  400558:	39400001 	ldrb	w1, [x0]
  40055c:	f9400be0 	ldr	x0, [sp, #16]
  400560:	39000001 	strb	w1, [x0]
  400564:	f9400be0 	ldr	x0, [sp, #16]
  400568:	91000400 	add	x0, x0, #0x1
  40056c:	f9000be0 	str	x0, [sp, #16]
  400570:	f9400fe0 	ldr	x0, [sp, #24]
  400574:	91000400 	add	x0, x0, #0x1
  400578:	f9000fe0 	str	x0, [sp, #24]
  40057c:	f9400be1 	ldr	x1, [sp, #16]
  400580:	f94017e0 	ldr	x0, [sp, #40]
  400584:	eb00003f 	cmp	x1, x0
  400588:	54fffe63 	b.cc	400554 <user_bcopy+0x64>  // b.lo, b.ul, b.last
  40058c:	d503201f 	nop
  400590:	d503201f 	nop
  400594:	9100c3ff 	add	sp, sp, #0x30
  400598:	d65f03c0 	ret

000000000040059c <user_bzero>:
user_bzero():
  40059c:	d10083ff 	sub	sp, sp, #0x20
  4005a0:	f90007e0 	str	x0, [sp, #8]
  4005a4:	b90007e1 	str	w1, [sp, #4]
  4005a8:	f94007e0 	ldr	x0, [sp, #8]
  4005ac:	f9000fe0 	str	x0, [sp, #24]
  4005b0:	b94007e0 	ldr	w0, [sp, #4]
  4005b4:	b90017e0 	str	w0, [sp, #20]
  4005b8:	14000005 	b	4005cc <user_bzero+0x30>
  4005bc:	f9400fe0 	ldr	x0, [sp, #24]
  4005c0:	91000401 	add	x1, x0, #0x1
  4005c4:	f9000fe1 	str	x1, [sp, #24]
  4005c8:	3900001f 	strb	wzr, [x0]
  4005cc:	b94017e0 	ldr	w0, [sp, #20]
  4005d0:	51000400 	sub	w0, w0, #0x1
  4005d4:	b90017e0 	str	w0, [sp, #20]
  4005d8:	b94017e0 	ldr	w0, [sp, #20]
  4005dc:	7100001f 	cmp	w0, #0x0
  4005e0:	54fffeea 	b.ge	4005bc <user_bzero+0x20>  // b.tcont
  4005e4:	d503201f 	nop
  4005e8:	d503201f 	nop
  4005ec:	910083ff 	add	sp, sp, #0x20
  4005f0:	d65f03c0 	ret

00000000004005f4 <libmain>:
libmain():
  4005f4:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
  4005f8:	910003fd 	mov	x29, sp
  4005fc:	b9001fe0 	str	w0, [sp, #28]
  400600:	f9000be1 	str	x1, [sp, #16]
  400604:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  400608:	9104a000 	add	x0, x0, #0x128
  40060c:	f900001f 	str	xzr, [x0]
  400610:	940005c7 	bl	401d2c <syscall_getenvid>
  400614:	b9002fe0 	str	w0, [sp, #44]
  400618:	b9402fe0 	ldr	w0, [sp, #44]
  40061c:	12002400 	and	w0, w0, #0x3ff
  400620:	b9002fe0 	str	w0, [sp, #44]
  400624:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  400628:	91016000 	add	x0, x0, #0x58
  40062c:	f9400002 	ldr	x2, [x0]
  400630:	b9802fe1 	ldrsw	x1, [sp, #44]
  400634:	aa0103e0 	mov	x0, x1
  400638:	d37ff800 	lsl	x0, x0, #1
  40063c:	8b010000 	add	x0, x0, x1
  400640:	d37cec01 	lsl	x1, x0, #4
  400644:	8b010000 	add	x0, x0, x1
  400648:	d37df000 	lsl	x0, x0, #3
  40064c:	8b000041 	add	x1, x2, x0
  400650:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  400654:	9104a000 	add	x0, x0, #0x128
  400658:	f9000001 	str	x1, [x0]
  40065c:	f9400be1 	ldr	x1, [sp, #16]
  400660:	b9401fe0 	ldr	w0, [sp, #28]
  400664:	97fffe6b 	bl	400010 <umain>
  400668:	97ffff9b 	bl	4004d4 <exit>
  40066c:	d503201f 	nop
  400670:	a8c37bfd 	ldp	x29, x30, [sp], #48
  400674:	d65f03c0 	ret

0000000000400678 <msyscall>:
msyscall():
  400678:	d4000001 	svc	#0x0
  40067c:	d65f03c0 	ret

0000000000400680 <user_lp_Print>:
user_lp_Print():
  400680:	d111c3ff 	sub	sp, sp, #0x470
  400684:	a9007bfd 	stp	x29, x30, [sp]
  400688:	910003fd 	mov	x29, sp
  40068c:	f9000bf3 	str	x19, [sp, #16]
  400690:	f9001fe0 	str	x0, [sp, #56]
  400694:	f9001be1 	str	x1, [sp, #48]
  400698:	f90017e2 	str	x2, [sp, #40]
  40069c:	aa0303f3 	mov	x19, x3
  4006a0:	f94017e0 	ldr	x0, [sp, #40]
  4006a4:	f90227e0 	str	x0, [sp, #1096]
  4006a8:	14000004 	b	4006b8 <user_lp_Print+0x38>
  4006ac:	f94017e0 	ldr	x0, [sp, #40]
  4006b0:	91000400 	add	x0, x0, #0x1
  4006b4:	f90017e0 	str	x0, [sp, #40]
  4006b8:	f94017e0 	ldr	x0, [sp, #40]
  4006bc:	39400000 	ldrb	w0, [x0]
  4006c0:	7100001f 	cmp	w0, #0x0
  4006c4:	540000a0 	b.eq	4006d8 <user_lp_Print+0x58>  // b.none
  4006c8:	f94017e0 	ldr	x0, [sp, #40]
  4006cc:	39400000 	ldrb	w0, [x0]
  4006d0:	7100941f 	cmp	w0, #0x25
  4006d4:	54fffec1 	b.ne	4006ac <user_lp_Print+0x2c>  // b.any
  4006d8:	f94017e1 	ldr	x1, [sp, #40]
  4006dc:	f94227e0 	ldr	x0, [sp, #1096]
  4006e0:	cb000020 	sub	x0, x1, x0
  4006e4:	f100001f 	cmp	x0, #0x0
  4006e8:	540000cb 	b.lt	400700 <user_lp_Print+0x80>  // b.tstop
  4006ec:	f94017e1 	ldr	x1, [sp, #40]
  4006f0:	f94227e0 	ldr	x0, [sp, #1096]
  4006f4:	cb000020 	sub	x0, x1, x0
  4006f8:	f10fa01f 	cmp	x0, #0x3e8
  4006fc:	5400010d 	b.le	40071c <user_lp_Print+0x9c>
  400700:	f9401fe3 	ldr	x3, [sp, #56]
  400704:	528003a2 	mov	w2, #0x1d                  	// #29
  400708:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  40070c:	91036001 	add	x1, x0, #0xd8
  400710:	f9401be0 	ldr	x0, [sp, #48]
  400714:	d63f0060 	blr	x3
  400718:	14000000 	b	400718 <user_lp_Print+0x98>
  40071c:	f94017e1 	ldr	x1, [sp, #40]
  400720:	f94227e0 	ldr	x0, [sp, #1096]
  400724:	cb000020 	sub	x0, x1, x0
  400728:	f9401fe3 	ldr	x3, [sp, #56]
  40072c:	2a0003e2 	mov	w2, w0
  400730:	f94227e1 	ldr	x1, [sp, #1096]
  400734:	f9401be0 	ldr	x0, [sp, #48]
  400738:	d63f0060 	blr	x3
  40073c:	f94017e1 	ldr	x1, [sp, #40]
  400740:	f94227e0 	ldr	x0, [sp, #1096]
  400744:	cb000020 	sub	x0, x1, x0
  400748:	aa0003e1 	mov	x1, x0
  40074c:	f9401be0 	ldr	x0, [sp, #48]
  400750:	8b010000 	add	x0, x0, x1
  400754:	f9001be0 	str	x0, [sp, #48]
  400758:	f94017e0 	ldr	x0, [sp, #40]
  40075c:	39400000 	ldrb	w0, [x0]
  400760:	7100001f 	cmp	w0, #0x0
  400764:	540061a0 	b.eq	401398 <user_lp_Print+0xd18>  // b.none
  400768:	f94017e0 	ldr	x0, [sp, #40]
  40076c:	91000400 	add	x0, x0, #0x1
  400770:	f90017e0 	str	x0, [sp, #40]
  400774:	f94017e0 	ldr	x0, [sp, #40]
  400778:	39400000 	ldrb	w0, [x0]
  40077c:	7101b01f 	cmp	w0, #0x6c
  400780:	540000e1 	b.ne	40079c <user_lp_Print+0x11c>  // b.any
  400784:	52800020 	mov	w0, #0x1                   	// #1
  400788:	b90467e0 	str	w0, [sp, #1124]
  40078c:	f94017e0 	ldr	x0, [sp, #40]
  400790:	91000400 	add	x0, x0, #0x1
  400794:	f90017e0 	str	x0, [sp, #40]
  400798:	14000002 	b	4007a0 <user_lp_Print+0x120>
  40079c:	b90467ff 	str	wzr, [sp, #1124]
  4007a0:	b9045fff 	str	wzr, [sp, #1116]
  4007a4:	12800000 	mov	w0, #0xffffffff            	// #-1
  4007a8:	b9045be0 	str	w0, [sp, #1112]
  4007ac:	b90457ff 	str	wzr, [sp, #1108]
  4007b0:	52800400 	mov	w0, #0x20                  	// #32
  4007b4:	39114fe0 	strb	w0, [sp, #1107]
  4007b8:	f94017e0 	ldr	x0, [sp, #40]
  4007bc:	39400000 	ldrb	w0, [x0]
  4007c0:	7100b41f 	cmp	w0, #0x2d
  4007c4:	540000c1 	b.ne	4007dc <user_lp_Print+0x15c>  // b.any
  4007c8:	52800020 	mov	w0, #0x1                   	// #1
  4007cc:	b90457e0 	str	w0, [sp, #1108]
  4007d0:	f94017e0 	ldr	x0, [sp, #40]
  4007d4:	91000400 	add	x0, x0, #0x1
  4007d8:	f90017e0 	str	x0, [sp, #40]
  4007dc:	f94017e0 	ldr	x0, [sp, #40]
  4007e0:	39400000 	ldrb	w0, [x0]
  4007e4:	7100c01f 	cmp	w0, #0x30
  4007e8:	540000c1 	b.ne	400800 <user_lp_Print+0x180>  // b.any
  4007ec:	52800600 	mov	w0, #0x30                  	// #48
  4007f0:	39114fe0 	strb	w0, [sp, #1107]
  4007f4:	f94017e0 	ldr	x0, [sp, #40]
  4007f8:	91000400 	add	x0, x0, #0x1
  4007fc:	f90017e0 	str	x0, [sp, #40]
  400800:	f94017e0 	ldr	x0, [sp, #40]
  400804:	39400000 	ldrb	w0, [x0]
  400808:	7100bc1f 	cmp	w0, #0x2f
  40080c:	54000369 	b.ls	400878 <user_lp_Print+0x1f8>  // b.plast
  400810:	f94017e0 	ldr	x0, [sp, #40]
  400814:	39400000 	ldrb	w0, [x0]
  400818:	7100e41f 	cmp	w0, #0x39
  40081c:	540002e8 	b.hi	400878 <user_lp_Print+0x1f8>  // b.pmore
  400820:	1400000e 	b	400858 <user_lp_Print+0x1d8>
  400824:	b9445fe1 	ldr	w1, [sp, #1116]
  400828:	2a0103e0 	mov	w0, w1
  40082c:	531e7400 	lsl	w0, w0, #2
  400830:	0b010000 	add	w0, w0, w1
  400834:	531f7800 	lsl	w0, w0, #1
  400838:	2a0003e2 	mov	w2, w0
  40083c:	f94017e0 	ldr	x0, [sp, #40]
  400840:	91000401 	add	x1, x0, #0x1
  400844:	f90017e1 	str	x1, [sp, #40]
  400848:	39400000 	ldrb	w0, [x0]
  40084c:	5100c000 	sub	w0, w0, #0x30
  400850:	0b000040 	add	w0, w2, w0
  400854:	b9045fe0 	str	w0, [sp, #1116]
  400858:	f94017e0 	ldr	x0, [sp, #40]
  40085c:	39400000 	ldrb	w0, [x0]
  400860:	7100bc1f 	cmp	w0, #0x2f
  400864:	540000a9 	b.ls	400878 <user_lp_Print+0x1f8>  // b.plast
  400868:	f94017e0 	ldr	x0, [sp, #40]
  40086c:	39400000 	ldrb	w0, [x0]
  400870:	7100e41f 	cmp	w0, #0x39
  400874:	54fffd89 	b.ls	400824 <user_lp_Print+0x1a4>  // b.plast
  400878:	f94017e0 	ldr	x0, [sp, #40]
  40087c:	39400000 	ldrb	w0, [x0]
  400880:	7100b81f 	cmp	w0, #0x2e
  400884:	54000461 	b.ne	400910 <user_lp_Print+0x290>  // b.any
  400888:	f94017e0 	ldr	x0, [sp, #40]
  40088c:	91000400 	add	x0, x0, #0x1
  400890:	f90017e0 	str	x0, [sp, #40]
  400894:	f94017e0 	ldr	x0, [sp, #40]
  400898:	39400000 	ldrb	w0, [x0]
  40089c:	7100bc1f 	cmp	w0, #0x2f
  4008a0:	54000389 	b.ls	400910 <user_lp_Print+0x290>  // b.plast
  4008a4:	f94017e0 	ldr	x0, [sp, #40]
  4008a8:	39400000 	ldrb	w0, [x0]
  4008ac:	7100e41f 	cmp	w0, #0x39
  4008b0:	54000308 	b.hi	400910 <user_lp_Print+0x290>  // b.pmore
  4008b4:	b9045bff 	str	wzr, [sp, #1112]
  4008b8:	1400000e 	b	4008f0 <user_lp_Print+0x270>
  4008bc:	b9445be1 	ldr	w1, [sp, #1112]
  4008c0:	2a0103e0 	mov	w0, w1
  4008c4:	531e7400 	lsl	w0, w0, #2
  4008c8:	0b010000 	add	w0, w0, w1
  4008cc:	531f7800 	lsl	w0, w0, #1
  4008d0:	2a0003e2 	mov	w2, w0
  4008d4:	f94017e0 	ldr	x0, [sp, #40]
  4008d8:	91000401 	add	x1, x0, #0x1
  4008dc:	f90017e1 	str	x1, [sp, #40]
  4008e0:	39400000 	ldrb	w0, [x0]
  4008e4:	5100c000 	sub	w0, w0, #0x30
  4008e8:	0b000040 	add	w0, w2, w0
  4008ec:	b9045be0 	str	w0, [sp, #1112]
  4008f0:	f94017e0 	ldr	x0, [sp, #40]
  4008f4:	39400000 	ldrb	w0, [x0]
  4008f8:	7100bc1f 	cmp	w0, #0x2f
  4008fc:	540000a9 	b.ls	400910 <user_lp_Print+0x290>  // b.plast
  400900:	f94017e0 	ldr	x0, [sp, #40]
  400904:	39400000 	ldrb	w0, [x0]
  400908:	7100e41f 	cmp	w0, #0x39
  40090c:	54fffd89 	b.ls	4008bc <user_lp_Print+0x23c>  // b.plast
  400910:	b90463ff 	str	wzr, [sp, #1120]
  400914:	f94017e0 	ldr	x0, [sp, #40]
  400918:	39400000 	ldrb	w0, [x0]
  40091c:	7101e01f 	cmp	w0, #0x78
  400920:	54003000 	b.eq	400f20 <user_lp_Print+0x8a0>  // b.none
  400924:	7101e01f 	cmp	w0, #0x78
  400928:	5400520c 	b.gt	401368 <user_lp_Print+0xce8>
  40092c:	7101d41f 	cmp	w0, #0x75
  400930:	54002520 	b.eq	400dd4 <user_lp_Print+0x754>  // b.none
  400934:	7101d41f 	cmp	w0, #0x75
  400938:	5400518c 	b.gt	401368 <user_lp_Print+0xce8>
  40093c:	7101cc1f 	cmp	w0, #0x73
  400940:	54004a40 	b.eq	401288 <user_lp_Print+0xc08>  // b.none
  400944:	7101cc1f 	cmp	w0, #0x73
  400948:	5400510c 	b.gt	401368 <user_lp_Print+0xce8>
  40094c:	7101bc1f 	cmp	w0, #0x6f
  400950:	540019c0 	b.eq	400c88 <user_lp_Print+0x608>  // b.none
  400954:	7101bc1f 	cmp	w0, #0x6f
  400958:	5400508c 	b.gt	401368 <user_lp_Print+0xce8>
  40095c:	7101901f 	cmp	w0, #0x64
  400960:	54000de0 	b.eq	400b1c <user_lp_Print+0x49c>  // b.none
  400964:	7101901f 	cmp	w0, #0x64
  400968:	5400500c 	b.gt	401368 <user_lp_Print+0xce8>
  40096c:	71018c1f 	cmp	w0, #0x63
  400970:	54004240 	b.eq	4011b8 <user_lp_Print+0xb38>  // b.none
  400974:	71018c1f 	cmp	w0, #0x63
  400978:	54004f8c 	b.gt	401368 <user_lp_Print+0xce8>
  40097c:	7101881f 	cmp	w0, #0x62
  400980:	54000280 	b.eq	4009d0 <user_lp_Print+0x350>  // b.none
  400984:	7101881f 	cmp	w0, #0x62
  400988:	54004f0c 	b.gt	401368 <user_lp_Print+0xce8>
  40098c:	7101601f 	cmp	w0, #0x58
  400990:	540036e0 	b.eq	40106c <user_lp_Print+0x9ec>  // b.none
  400994:	7101601f 	cmp	w0, #0x58
  400998:	54004e8c 	b.gt	401368 <user_lp_Print+0xce8>
  40099c:	7101541f 	cmp	w0, #0x55
  4009a0:	540021a0 	b.eq	400dd4 <user_lp_Print+0x754>  // b.none
  4009a4:	7101541f 	cmp	w0, #0x55
  4009a8:	54004e0c 	b.gt	401368 <user_lp_Print+0xce8>
  4009ac:	71013c1f 	cmp	w0, #0x4f
  4009b0:	540016c0 	b.eq	400c88 <user_lp_Print+0x608>  // b.none
  4009b4:	71013c1f 	cmp	w0, #0x4f
  4009b8:	54004d8c 	b.gt	401368 <user_lp_Print+0xce8>
  4009bc:	7100001f 	cmp	w0, #0x0
  4009c0:	54004cc0 	b.eq	401358 <user_lp_Print+0xcd8>  // b.none
  4009c4:	7101101f 	cmp	w0, #0x44
  4009c8:	54000aa0 	b.eq	400b1c <user_lp_Print+0x49c>  // b.none
  4009cc:	14000267 	b	401368 <user_lp_Print+0xce8>
  4009d0:	b94467e0 	ldr	w0, [sp, #1124]
  4009d4:	7100001f 	cmp	w0, #0x0
  4009d8:	54000300 	b.eq	400a38 <user_lp_Print+0x3b8>  // b.none
  4009dc:	b9401a61 	ldr	w1, [x19, #24]
  4009e0:	f9400260 	ldr	x0, [x19]
  4009e4:	7100003f 	cmp	w1, #0x0
  4009e8:	540000ab 	b.lt	4009fc <user_lp_Print+0x37c>  // b.tstop
  4009ec:	91003c01 	add	x1, x0, #0xf
  4009f0:	927df021 	and	x1, x1, #0xfffffffffffffff8
  4009f4:	f9000261 	str	x1, [x19]
  4009f8:	1400000d 	b	400a2c <user_lp_Print+0x3ac>
  4009fc:	11002022 	add	w2, w1, #0x8
  400a00:	b9001a62 	str	w2, [x19, #24]
  400a04:	b9401a62 	ldr	w2, [x19, #24]
  400a08:	7100005f 	cmp	w2, #0x0
  400a0c:	540000ad 	b.le	400a20 <user_lp_Print+0x3a0>
  400a10:	91003c01 	add	x1, x0, #0xf
  400a14:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400a18:	f9000261 	str	x1, [x19]
  400a1c:	14000004 	b	400a2c <user_lp_Print+0x3ac>
  400a20:	f9400662 	ldr	x2, [x19, #8]
  400a24:	93407c20 	sxtw	x0, w1
  400a28:	8b000040 	add	x0, x2, x0
  400a2c:	f9400000 	ldr	x0, [x0]
  400a30:	f90237e0 	str	x0, [sp, #1128]
  400a34:	14000018 	b	400a94 <user_lp_Print+0x414>
  400a38:	b9401a61 	ldr	w1, [x19, #24]
  400a3c:	f9400260 	ldr	x0, [x19]
  400a40:	7100003f 	cmp	w1, #0x0
  400a44:	540000ab 	b.lt	400a58 <user_lp_Print+0x3d8>  // b.tstop
  400a48:	91002c01 	add	x1, x0, #0xb
  400a4c:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400a50:	f9000261 	str	x1, [x19]
  400a54:	1400000d 	b	400a88 <user_lp_Print+0x408>
  400a58:	11002022 	add	w2, w1, #0x8
  400a5c:	b9001a62 	str	w2, [x19, #24]
  400a60:	b9401a62 	ldr	w2, [x19, #24]
  400a64:	7100005f 	cmp	w2, #0x0
  400a68:	540000ad 	b.le	400a7c <user_lp_Print+0x3fc>
  400a6c:	91002c01 	add	x1, x0, #0xb
  400a70:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400a74:	f9000261 	str	x1, [x19]
  400a78:	14000004 	b	400a88 <user_lp_Print+0x408>
  400a7c:	f9400662 	ldr	x2, [x19, #8]
  400a80:	93407c20 	sxtw	x0, w1
  400a84:	8b000040 	add	x0, x2, x0
  400a88:	b9400000 	ldr	w0, [x0]
  400a8c:	93407c00 	sxtw	x0, w0
  400a90:	f90237e0 	str	x0, [sp, #1128]
  400a94:	f94237e1 	ldr	x1, [sp, #1128]
  400a98:	910123e0 	add	x0, sp, #0x48
  400a9c:	52800007 	mov	w7, #0x0                   	// #0
  400aa0:	39514fe6 	ldrb	w6, [sp, #1107]
  400aa4:	b94457e5 	ldr	w5, [sp, #1108]
  400aa8:	b9445fe4 	ldr	w4, [sp, #1116]
  400aac:	52800003 	mov	w3, #0x0                   	// #0
  400ab0:	52800042 	mov	w2, #0x2                   	// #2
  400ab4:	940002e8 	bl	401654 <user_PrintNum>
  400ab8:	b90447e0 	str	w0, [sp, #1092]
  400abc:	b94447e0 	ldr	w0, [sp, #1092]
  400ac0:	7100001f 	cmp	w0, #0x0
  400ac4:	5400008b 	b.lt	400ad4 <user_lp_Print+0x454>  // b.tstop
  400ac8:	b94447e0 	ldr	w0, [sp, #1092]
  400acc:	710fa01f 	cmp	w0, #0x3e8
  400ad0:	5400010d 	b.le	400af0 <user_lp_Print+0x470>
  400ad4:	f9401fe3 	ldr	x3, [sp, #56]
  400ad8:	528003a2 	mov	w2, #0x1d                  	// #29
  400adc:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  400ae0:	91036001 	add	x1, x0, #0xd8
  400ae4:	f9401be0 	ldr	x0, [sp, #48]
  400ae8:	d63f0060 	blr	x3
  400aec:	14000000 	b	400aec <user_lp_Print+0x46c>
  400af0:	910123e0 	add	x0, sp, #0x48
  400af4:	f9401fe3 	ldr	x3, [sp, #56]
  400af8:	b94447e2 	ldr	w2, [sp, #1092]
  400afc:	aa0003e1 	mov	x1, x0
  400b00:	f9401be0 	ldr	x0, [sp, #48]
  400b04:	d63f0060 	blr	x3
  400b08:	b98447e0 	ldrsw	x0, [sp, #1092]
  400b0c:	f9401be1 	ldr	x1, [sp, #48]
  400b10:	8b000020 	add	x0, x1, x0
  400b14:	f9001be0 	str	x0, [sp, #48]
  400b18:	1400021c 	b	401388 <user_lp_Print+0xd08>
  400b1c:	b94467e0 	ldr	w0, [sp, #1124]
  400b20:	7100001f 	cmp	w0, #0x0
  400b24:	54000300 	b.eq	400b84 <user_lp_Print+0x504>  // b.none
  400b28:	b9401a61 	ldr	w1, [x19, #24]
  400b2c:	f9400260 	ldr	x0, [x19]
  400b30:	7100003f 	cmp	w1, #0x0
  400b34:	540000ab 	b.lt	400b48 <user_lp_Print+0x4c8>  // b.tstop
  400b38:	91003c01 	add	x1, x0, #0xf
  400b3c:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400b40:	f9000261 	str	x1, [x19]
  400b44:	1400000d 	b	400b78 <user_lp_Print+0x4f8>
  400b48:	11002022 	add	w2, w1, #0x8
  400b4c:	b9001a62 	str	w2, [x19, #24]
  400b50:	b9401a62 	ldr	w2, [x19, #24]
  400b54:	7100005f 	cmp	w2, #0x0
  400b58:	540000ad 	b.le	400b6c <user_lp_Print+0x4ec>
  400b5c:	91003c01 	add	x1, x0, #0xf
  400b60:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400b64:	f9000261 	str	x1, [x19]
  400b68:	14000004 	b	400b78 <user_lp_Print+0x4f8>
  400b6c:	f9400662 	ldr	x2, [x19, #8]
  400b70:	93407c20 	sxtw	x0, w1
  400b74:	8b000040 	add	x0, x2, x0
  400b78:	f9400000 	ldr	x0, [x0]
  400b7c:	f90237e0 	str	x0, [sp, #1128]
  400b80:	14000018 	b	400be0 <user_lp_Print+0x560>
  400b84:	b9401a61 	ldr	w1, [x19, #24]
  400b88:	f9400260 	ldr	x0, [x19]
  400b8c:	7100003f 	cmp	w1, #0x0
  400b90:	540000ab 	b.lt	400ba4 <user_lp_Print+0x524>  // b.tstop
  400b94:	91002c01 	add	x1, x0, #0xb
  400b98:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400b9c:	f9000261 	str	x1, [x19]
  400ba0:	1400000d 	b	400bd4 <user_lp_Print+0x554>
  400ba4:	11002022 	add	w2, w1, #0x8
  400ba8:	b9001a62 	str	w2, [x19, #24]
  400bac:	b9401a62 	ldr	w2, [x19, #24]
  400bb0:	7100005f 	cmp	w2, #0x0
  400bb4:	540000ad 	b.le	400bc8 <user_lp_Print+0x548>
  400bb8:	91002c01 	add	x1, x0, #0xb
  400bbc:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400bc0:	f9000261 	str	x1, [x19]
  400bc4:	14000004 	b	400bd4 <user_lp_Print+0x554>
  400bc8:	f9400662 	ldr	x2, [x19, #8]
  400bcc:	93407c20 	sxtw	x0, w1
  400bd0:	8b000040 	add	x0, x2, x0
  400bd4:	b9400000 	ldr	w0, [x0]
  400bd8:	93407c00 	sxtw	x0, w0
  400bdc:	f90237e0 	str	x0, [sp, #1128]
  400be0:	f94237e0 	ldr	x0, [sp, #1128]
  400be4:	f100001f 	cmp	x0, #0x0
  400be8:	540000ca 	b.ge	400c00 <user_lp_Print+0x580>  // b.tcont
  400bec:	f94237e0 	ldr	x0, [sp, #1128]
  400bf0:	cb0003e0 	neg	x0, x0
  400bf4:	f90237e0 	str	x0, [sp, #1128]
  400bf8:	52800020 	mov	w0, #0x1                   	// #1
  400bfc:	b90463e0 	str	w0, [sp, #1120]
  400c00:	f94237e1 	ldr	x1, [sp, #1128]
  400c04:	910123e0 	add	x0, sp, #0x48
  400c08:	52800007 	mov	w7, #0x0                   	// #0
  400c0c:	39514fe6 	ldrb	w6, [sp, #1107]
  400c10:	b94457e5 	ldr	w5, [sp, #1108]
  400c14:	b9445fe4 	ldr	w4, [sp, #1116]
  400c18:	b94463e3 	ldr	w3, [sp, #1120]
  400c1c:	52800142 	mov	w2, #0xa                   	// #10
  400c20:	9400028d 	bl	401654 <user_PrintNum>
  400c24:	b90447e0 	str	w0, [sp, #1092]
  400c28:	b94447e0 	ldr	w0, [sp, #1092]
  400c2c:	7100001f 	cmp	w0, #0x0
  400c30:	5400008b 	b.lt	400c40 <user_lp_Print+0x5c0>  // b.tstop
  400c34:	b94447e0 	ldr	w0, [sp, #1092]
  400c38:	710fa01f 	cmp	w0, #0x3e8
  400c3c:	5400010d 	b.le	400c5c <user_lp_Print+0x5dc>
  400c40:	f9401fe3 	ldr	x3, [sp, #56]
  400c44:	528003a2 	mov	w2, #0x1d                  	// #29
  400c48:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  400c4c:	91036001 	add	x1, x0, #0xd8
  400c50:	f9401be0 	ldr	x0, [sp, #48]
  400c54:	d63f0060 	blr	x3
  400c58:	14000000 	b	400c58 <user_lp_Print+0x5d8>
  400c5c:	910123e0 	add	x0, sp, #0x48
  400c60:	f9401fe3 	ldr	x3, [sp, #56]
  400c64:	b94447e2 	ldr	w2, [sp, #1092]
  400c68:	aa0003e1 	mov	x1, x0
  400c6c:	f9401be0 	ldr	x0, [sp, #48]
  400c70:	d63f0060 	blr	x3
  400c74:	b98447e0 	ldrsw	x0, [sp, #1092]
  400c78:	f9401be1 	ldr	x1, [sp, #48]
  400c7c:	8b000020 	add	x0, x1, x0
  400c80:	f9001be0 	str	x0, [sp, #48]
  400c84:	140001c1 	b	401388 <user_lp_Print+0xd08>
  400c88:	b94467e0 	ldr	w0, [sp, #1124]
  400c8c:	7100001f 	cmp	w0, #0x0
  400c90:	54000300 	b.eq	400cf0 <user_lp_Print+0x670>  // b.none
  400c94:	b9401a61 	ldr	w1, [x19, #24]
  400c98:	f9400260 	ldr	x0, [x19]
  400c9c:	7100003f 	cmp	w1, #0x0
  400ca0:	540000ab 	b.lt	400cb4 <user_lp_Print+0x634>  // b.tstop
  400ca4:	91003c01 	add	x1, x0, #0xf
  400ca8:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400cac:	f9000261 	str	x1, [x19]
  400cb0:	1400000d 	b	400ce4 <user_lp_Print+0x664>
  400cb4:	11002022 	add	w2, w1, #0x8
  400cb8:	b9001a62 	str	w2, [x19, #24]
  400cbc:	b9401a62 	ldr	w2, [x19, #24]
  400cc0:	7100005f 	cmp	w2, #0x0
  400cc4:	540000ad 	b.le	400cd8 <user_lp_Print+0x658>
  400cc8:	91003c01 	add	x1, x0, #0xf
  400ccc:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400cd0:	f9000261 	str	x1, [x19]
  400cd4:	14000004 	b	400ce4 <user_lp_Print+0x664>
  400cd8:	f9400662 	ldr	x2, [x19, #8]
  400cdc:	93407c20 	sxtw	x0, w1
  400ce0:	8b000040 	add	x0, x2, x0
  400ce4:	f9400000 	ldr	x0, [x0]
  400ce8:	f90237e0 	str	x0, [sp, #1128]
  400cec:	14000018 	b	400d4c <user_lp_Print+0x6cc>
  400cf0:	b9401a61 	ldr	w1, [x19, #24]
  400cf4:	f9400260 	ldr	x0, [x19]
  400cf8:	7100003f 	cmp	w1, #0x0
  400cfc:	540000ab 	b.lt	400d10 <user_lp_Print+0x690>  // b.tstop
  400d00:	91002c01 	add	x1, x0, #0xb
  400d04:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400d08:	f9000261 	str	x1, [x19]
  400d0c:	1400000d 	b	400d40 <user_lp_Print+0x6c0>
  400d10:	11002022 	add	w2, w1, #0x8
  400d14:	b9001a62 	str	w2, [x19, #24]
  400d18:	b9401a62 	ldr	w2, [x19, #24]
  400d1c:	7100005f 	cmp	w2, #0x0
  400d20:	540000ad 	b.le	400d34 <user_lp_Print+0x6b4>
  400d24:	91002c01 	add	x1, x0, #0xb
  400d28:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400d2c:	f9000261 	str	x1, [x19]
  400d30:	14000004 	b	400d40 <user_lp_Print+0x6c0>
  400d34:	f9400662 	ldr	x2, [x19, #8]
  400d38:	93407c20 	sxtw	x0, w1
  400d3c:	8b000040 	add	x0, x2, x0
  400d40:	b9400000 	ldr	w0, [x0]
  400d44:	93407c00 	sxtw	x0, w0
  400d48:	f90237e0 	str	x0, [sp, #1128]
  400d4c:	f94237e1 	ldr	x1, [sp, #1128]
  400d50:	910123e0 	add	x0, sp, #0x48
  400d54:	52800007 	mov	w7, #0x0                   	// #0
  400d58:	39514fe6 	ldrb	w6, [sp, #1107]
  400d5c:	b94457e5 	ldr	w5, [sp, #1108]
  400d60:	b9445fe4 	ldr	w4, [sp, #1116]
  400d64:	52800003 	mov	w3, #0x0                   	// #0
  400d68:	52800102 	mov	w2, #0x8                   	// #8
  400d6c:	9400023a 	bl	401654 <user_PrintNum>
  400d70:	b90447e0 	str	w0, [sp, #1092]
  400d74:	b94447e0 	ldr	w0, [sp, #1092]
  400d78:	7100001f 	cmp	w0, #0x0
  400d7c:	5400008b 	b.lt	400d8c <user_lp_Print+0x70c>  // b.tstop
  400d80:	b94447e0 	ldr	w0, [sp, #1092]
  400d84:	710fa01f 	cmp	w0, #0x3e8
  400d88:	5400010d 	b.le	400da8 <user_lp_Print+0x728>
  400d8c:	f9401fe3 	ldr	x3, [sp, #56]
  400d90:	528003a2 	mov	w2, #0x1d                  	// #29
  400d94:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  400d98:	91036001 	add	x1, x0, #0xd8
  400d9c:	f9401be0 	ldr	x0, [sp, #48]
  400da0:	d63f0060 	blr	x3
  400da4:	14000000 	b	400da4 <user_lp_Print+0x724>
  400da8:	910123e0 	add	x0, sp, #0x48
  400dac:	f9401fe3 	ldr	x3, [sp, #56]
  400db0:	b94447e2 	ldr	w2, [sp, #1092]
  400db4:	aa0003e1 	mov	x1, x0
  400db8:	f9401be0 	ldr	x0, [sp, #48]
  400dbc:	d63f0060 	blr	x3
  400dc0:	b98447e0 	ldrsw	x0, [sp, #1092]
  400dc4:	f9401be1 	ldr	x1, [sp, #48]
  400dc8:	8b000020 	add	x0, x1, x0
  400dcc:	f9001be0 	str	x0, [sp, #48]
  400dd0:	1400016e 	b	401388 <user_lp_Print+0xd08>
  400dd4:	b94467e0 	ldr	w0, [sp, #1124]
  400dd8:	7100001f 	cmp	w0, #0x0
  400ddc:	54000300 	b.eq	400e3c <user_lp_Print+0x7bc>  // b.none
  400de0:	b9401a61 	ldr	w1, [x19, #24]
  400de4:	f9400260 	ldr	x0, [x19]
  400de8:	7100003f 	cmp	w1, #0x0
  400dec:	540000ab 	b.lt	400e00 <user_lp_Print+0x780>  // b.tstop
  400df0:	91003c01 	add	x1, x0, #0xf
  400df4:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400df8:	f9000261 	str	x1, [x19]
  400dfc:	1400000d 	b	400e30 <user_lp_Print+0x7b0>
  400e00:	11002022 	add	w2, w1, #0x8
  400e04:	b9001a62 	str	w2, [x19, #24]
  400e08:	b9401a62 	ldr	w2, [x19, #24]
  400e0c:	7100005f 	cmp	w2, #0x0
  400e10:	540000ad 	b.le	400e24 <user_lp_Print+0x7a4>
  400e14:	91003c01 	add	x1, x0, #0xf
  400e18:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400e1c:	f9000261 	str	x1, [x19]
  400e20:	14000004 	b	400e30 <user_lp_Print+0x7b0>
  400e24:	f9400662 	ldr	x2, [x19, #8]
  400e28:	93407c20 	sxtw	x0, w1
  400e2c:	8b000040 	add	x0, x2, x0
  400e30:	f9400000 	ldr	x0, [x0]
  400e34:	f90237e0 	str	x0, [sp, #1128]
  400e38:	14000018 	b	400e98 <user_lp_Print+0x818>
  400e3c:	b9401a61 	ldr	w1, [x19, #24]
  400e40:	f9400260 	ldr	x0, [x19]
  400e44:	7100003f 	cmp	w1, #0x0
  400e48:	540000ab 	b.lt	400e5c <user_lp_Print+0x7dc>  // b.tstop
  400e4c:	91002c01 	add	x1, x0, #0xb
  400e50:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400e54:	f9000261 	str	x1, [x19]
  400e58:	1400000d 	b	400e8c <user_lp_Print+0x80c>
  400e5c:	11002022 	add	w2, w1, #0x8
  400e60:	b9001a62 	str	w2, [x19, #24]
  400e64:	b9401a62 	ldr	w2, [x19, #24]
  400e68:	7100005f 	cmp	w2, #0x0
  400e6c:	540000ad 	b.le	400e80 <user_lp_Print+0x800>
  400e70:	91002c01 	add	x1, x0, #0xb
  400e74:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400e78:	f9000261 	str	x1, [x19]
  400e7c:	14000004 	b	400e8c <user_lp_Print+0x80c>
  400e80:	f9400662 	ldr	x2, [x19, #8]
  400e84:	93407c20 	sxtw	x0, w1
  400e88:	8b000040 	add	x0, x2, x0
  400e8c:	b9400000 	ldr	w0, [x0]
  400e90:	93407c00 	sxtw	x0, w0
  400e94:	f90237e0 	str	x0, [sp, #1128]
  400e98:	f94237e1 	ldr	x1, [sp, #1128]
  400e9c:	910123e0 	add	x0, sp, #0x48
  400ea0:	52800007 	mov	w7, #0x0                   	// #0
  400ea4:	39514fe6 	ldrb	w6, [sp, #1107]
  400ea8:	b94457e5 	ldr	w5, [sp, #1108]
  400eac:	b9445fe4 	ldr	w4, [sp, #1116]
  400eb0:	52800003 	mov	w3, #0x0                   	// #0
  400eb4:	52800142 	mov	w2, #0xa                   	// #10
  400eb8:	940001e7 	bl	401654 <user_PrintNum>
  400ebc:	b90447e0 	str	w0, [sp, #1092]
  400ec0:	b94447e0 	ldr	w0, [sp, #1092]
  400ec4:	7100001f 	cmp	w0, #0x0
  400ec8:	5400008b 	b.lt	400ed8 <user_lp_Print+0x858>  // b.tstop
  400ecc:	b94447e0 	ldr	w0, [sp, #1092]
  400ed0:	710fa01f 	cmp	w0, #0x3e8
  400ed4:	5400010d 	b.le	400ef4 <user_lp_Print+0x874>
  400ed8:	f9401fe3 	ldr	x3, [sp, #56]
  400edc:	528003a2 	mov	w2, #0x1d                  	// #29
  400ee0:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  400ee4:	91036001 	add	x1, x0, #0xd8
  400ee8:	f9401be0 	ldr	x0, [sp, #48]
  400eec:	d63f0060 	blr	x3
  400ef0:	14000000 	b	400ef0 <user_lp_Print+0x870>
  400ef4:	910123e0 	add	x0, sp, #0x48
  400ef8:	f9401fe3 	ldr	x3, [sp, #56]
  400efc:	b94447e2 	ldr	w2, [sp, #1092]
  400f00:	aa0003e1 	mov	x1, x0
  400f04:	f9401be0 	ldr	x0, [sp, #48]
  400f08:	d63f0060 	blr	x3
  400f0c:	b98447e0 	ldrsw	x0, [sp, #1092]
  400f10:	f9401be1 	ldr	x1, [sp, #48]
  400f14:	8b000020 	add	x0, x1, x0
  400f18:	f9001be0 	str	x0, [sp, #48]
  400f1c:	1400011b 	b	401388 <user_lp_Print+0xd08>
  400f20:	b94467e0 	ldr	w0, [sp, #1124]
  400f24:	7100001f 	cmp	w0, #0x0
  400f28:	54000300 	b.eq	400f88 <user_lp_Print+0x908>  // b.none
  400f2c:	b9401a61 	ldr	w1, [x19, #24]
  400f30:	f9400260 	ldr	x0, [x19]
  400f34:	7100003f 	cmp	w1, #0x0
  400f38:	540000ab 	b.lt	400f4c <user_lp_Print+0x8cc>  // b.tstop
  400f3c:	91003c01 	add	x1, x0, #0xf
  400f40:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400f44:	f9000261 	str	x1, [x19]
  400f48:	1400000d 	b	400f7c <user_lp_Print+0x8fc>
  400f4c:	11002022 	add	w2, w1, #0x8
  400f50:	b9001a62 	str	w2, [x19, #24]
  400f54:	b9401a62 	ldr	w2, [x19, #24]
  400f58:	7100005f 	cmp	w2, #0x0
  400f5c:	540000ad 	b.le	400f70 <user_lp_Print+0x8f0>
  400f60:	91003c01 	add	x1, x0, #0xf
  400f64:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400f68:	f9000261 	str	x1, [x19]
  400f6c:	14000004 	b	400f7c <user_lp_Print+0x8fc>
  400f70:	f9400662 	ldr	x2, [x19, #8]
  400f74:	93407c20 	sxtw	x0, w1
  400f78:	8b000040 	add	x0, x2, x0
  400f7c:	f9400000 	ldr	x0, [x0]
  400f80:	f90237e0 	str	x0, [sp, #1128]
  400f84:	14000018 	b	400fe4 <user_lp_Print+0x964>
  400f88:	b9401a61 	ldr	w1, [x19, #24]
  400f8c:	f9400260 	ldr	x0, [x19]
  400f90:	7100003f 	cmp	w1, #0x0
  400f94:	540000ab 	b.lt	400fa8 <user_lp_Print+0x928>  // b.tstop
  400f98:	91002c01 	add	x1, x0, #0xb
  400f9c:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400fa0:	f9000261 	str	x1, [x19]
  400fa4:	1400000d 	b	400fd8 <user_lp_Print+0x958>
  400fa8:	11002022 	add	w2, w1, #0x8
  400fac:	b9001a62 	str	w2, [x19, #24]
  400fb0:	b9401a62 	ldr	w2, [x19, #24]
  400fb4:	7100005f 	cmp	w2, #0x0
  400fb8:	540000ad 	b.le	400fcc <user_lp_Print+0x94c>
  400fbc:	91002c01 	add	x1, x0, #0xb
  400fc0:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400fc4:	f9000261 	str	x1, [x19]
  400fc8:	14000004 	b	400fd8 <user_lp_Print+0x958>
  400fcc:	f9400662 	ldr	x2, [x19, #8]
  400fd0:	93407c20 	sxtw	x0, w1
  400fd4:	8b000040 	add	x0, x2, x0
  400fd8:	b9400000 	ldr	w0, [x0]
  400fdc:	93407c00 	sxtw	x0, w0
  400fe0:	f90237e0 	str	x0, [sp, #1128]
  400fe4:	f94237e1 	ldr	x1, [sp, #1128]
  400fe8:	910123e0 	add	x0, sp, #0x48
  400fec:	52800007 	mov	w7, #0x0                   	// #0
  400ff0:	39514fe6 	ldrb	w6, [sp, #1107]
  400ff4:	b94457e5 	ldr	w5, [sp, #1108]
  400ff8:	b9445fe4 	ldr	w4, [sp, #1116]
  400ffc:	52800003 	mov	w3, #0x0                   	// #0
  401000:	52800202 	mov	w2, #0x10                  	// #16
  401004:	94000194 	bl	401654 <user_PrintNum>
  401008:	b90447e0 	str	w0, [sp, #1092]
  40100c:	b94447e0 	ldr	w0, [sp, #1092]
  401010:	7100001f 	cmp	w0, #0x0
  401014:	5400008b 	b.lt	401024 <user_lp_Print+0x9a4>  // b.tstop
  401018:	b94447e0 	ldr	w0, [sp, #1092]
  40101c:	710fa01f 	cmp	w0, #0x3e8
  401020:	5400010d 	b.le	401040 <user_lp_Print+0x9c0>
  401024:	f9401fe3 	ldr	x3, [sp, #56]
  401028:	528003a2 	mov	w2, #0x1d                  	// #29
  40102c:	b0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  401030:	91036001 	add	x1, x0, #0xd8
  401034:	f9401be0 	ldr	x0, [sp, #48]
  401038:	d63f0060 	blr	x3
  40103c:	14000000 	b	40103c <user_lp_Print+0x9bc>
  401040:	910123e0 	add	x0, sp, #0x48
  401044:	f9401fe3 	ldr	x3, [sp, #56]
  401048:	b94447e2 	ldr	w2, [sp, #1092]
  40104c:	aa0003e1 	mov	x1, x0
  401050:	f9401be0 	ldr	x0, [sp, #48]
  401054:	d63f0060 	blr	x3
  401058:	b98447e0 	ldrsw	x0, [sp, #1092]
  40105c:	f9401be1 	ldr	x1, [sp, #48]
  401060:	8b000020 	add	x0, x1, x0
  401064:	f9001be0 	str	x0, [sp, #48]
  401068:	140000c8 	b	401388 <user_lp_Print+0xd08>
  40106c:	b94467e0 	ldr	w0, [sp, #1124]
  401070:	7100001f 	cmp	w0, #0x0
  401074:	54000300 	b.eq	4010d4 <user_lp_Print+0xa54>  // b.none
  401078:	b9401a61 	ldr	w1, [x19, #24]
  40107c:	f9400260 	ldr	x0, [x19]
  401080:	7100003f 	cmp	w1, #0x0
  401084:	540000ab 	b.lt	401098 <user_lp_Print+0xa18>  // b.tstop
  401088:	91003c01 	add	x1, x0, #0xf
  40108c:	927df021 	and	x1, x1, #0xfffffffffffffff8
  401090:	f9000261 	str	x1, [x19]
  401094:	1400000d 	b	4010c8 <user_lp_Print+0xa48>
  401098:	11002022 	add	w2, w1, #0x8
  40109c:	b9001a62 	str	w2, [x19, #24]
  4010a0:	b9401a62 	ldr	w2, [x19, #24]
  4010a4:	7100005f 	cmp	w2, #0x0
  4010a8:	540000ad 	b.le	4010bc <user_lp_Print+0xa3c>
  4010ac:	91003c01 	add	x1, x0, #0xf
  4010b0:	927df021 	and	x1, x1, #0xfffffffffffffff8
  4010b4:	f9000261 	str	x1, [x19]
  4010b8:	14000004 	b	4010c8 <user_lp_Print+0xa48>
  4010bc:	f9400662 	ldr	x2, [x19, #8]
  4010c0:	93407c20 	sxtw	x0, w1
  4010c4:	8b000040 	add	x0, x2, x0
  4010c8:	f9400000 	ldr	x0, [x0]
  4010cc:	f90237e0 	str	x0, [sp, #1128]
  4010d0:	14000018 	b	401130 <user_lp_Print+0xab0>
  4010d4:	b9401a61 	ldr	w1, [x19, #24]
  4010d8:	f9400260 	ldr	x0, [x19]
  4010dc:	7100003f 	cmp	w1, #0x0
  4010e0:	540000ab 	b.lt	4010f4 <user_lp_Print+0xa74>  // b.tstop
  4010e4:	91002c01 	add	x1, x0, #0xb
  4010e8:	927df021 	and	x1, x1, #0xfffffffffffffff8
  4010ec:	f9000261 	str	x1, [x19]
  4010f0:	1400000d 	b	401124 <user_lp_Print+0xaa4>
  4010f4:	11002022 	add	w2, w1, #0x8
  4010f8:	b9001a62 	str	w2, [x19, #24]
  4010fc:	b9401a62 	ldr	w2, [x19, #24]
  401100:	7100005f 	cmp	w2, #0x0
  401104:	540000ad 	b.le	401118 <user_lp_Print+0xa98>
  401108:	91002c01 	add	x1, x0, #0xb
  40110c:	927df021 	and	x1, x1, #0xfffffffffffffff8
  401110:	f9000261 	str	x1, [x19]
  401114:	14000004 	b	401124 <user_lp_Print+0xaa4>
  401118:	f9400662 	ldr	x2, [x19, #8]
  40111c:	93407c20 	sxtw	x0, w1
  401120:	8b000040 	add	x0, x2, x0
  401124:	b9400000 	ldr	w0, [x0]
  401128:	93407c00 	sxtw	x0, w0
  40112c:	f90237e0 	str	x0, [sp, #1128]
  401130:	f94237e1 	ldr	x1, [sp, #1128]
  401134:	910123e0 	add	x0, sp, #0x48
  401138:	52800027 	mov	w7, #0x1                   	// #1
  40113c:	39514fe6 	ldrb	w6, [sp, #1107]
  401140:	b94457e5 	ldr	w5, [sp, #1108]
  401144:	b9445fe4 	ldr	w4, [sp, #1116]
  401148:	52800003 	mov	w3, #0x0                   	// #0
  40114c:	52800202 	mov	w2, #0x10                  	// #16
  401150:	94000141 	bl	401654 <user_PrintNum>
  401154:	b90447e0 	str	w0, [sp, #1092]
  401158:	b94447e0 	ldr	w0, [sp, #1092]
  40115c:	7100001f 	cmp	w0, #0x0
  401160:	5400008b 	b.lt	401170 <user_lp_Print+0xaf0>  // b.tstop
  401164:	b94447e0 	ldr	w0, [sp, #1092]
  401168:	710fa01f 	cmp	w0, #0x3e8
  40116c:	5400010d 	b.le	40118c <user_lp_Print+0xb0c>
  401170:	f9401fe3 	ldr	x3, [sp, #56]
  401174:	528003a2 	mov	w2, #0x1d                  	// #29
  401178:	b0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  40117c:	91036001 	add	x1, x0, #0xd8
  401180:	f9401be0 	ldr	x0, [sp, #48]
  401184:	d63f0060 	blr	x3
  401188:	14000000 	b	401188 <user_lp_Print+0xb08>
  40118c:	910123e0 	add	x0, sp, #0x48
  401190:	f9401fe3 	ldr	x3, [sp, #56]
  401194:	b94447e2 	ldr	w2, [sp, #1092]
  401198:	aa0003e1 	mov	x1, x0
  40119c:	f9401be0 	ldr	x0, [sp, #48]
  4011a0:	d63f0060 	blr	x3
  4011a4:	b98447e0 	ldrsw	x0, [sp, #1092]
  4011a8:	f9401be1 	ldr	x1, [sp, #48]
  4011ac:	8b000020 	add	x0, x1, x0
  4011b0:	f9001be0 	str	x0, [sp, #48]
  4011b4:	14000075 	b	401388 <user_lp_Print+0xd08>
  4011b8:	b9401a61 	ldr	w1, [x19, #24]
  4011bc:	f9400260 	ldr	x0, [x19]
  4011c0:	7100003f 	cmp	w1, #0x0
  4011c4:	540000ab 	b.lt	4011d8 <user_lp_Print+0xb58>  // b.tstop
  4011c8:	91002c01 	add	x1, x0, #0xb
  4011cc:	927df021 	and	x1, x1, #0xfffffffffffffff8
  4011d0:	f9000261 	str	x1, [x19]
  4011d4:	1400000d 	b	401208 <user_lp_Print+0xb88>
  4011d8:	11002022 	add	w2, w1, #0x8
  4011dc:	b9001a62 	str	w2, [x19, #24]
  4011e0:	b9401a62 	ldr	w2, [x19, #24]
  4011e4:	7100005f 	cmp	w2, #0x0
  4011e8:	540000ad 	b.le	4011fc <user_lp_Print+0xb7c>
  4011ec:	91002c01 	add	x1, x0, #0xb
  4011f0:	927df021 	and	x1, x1, #0xfffffffffffffff8
  4011f4:	f9000261 	str	x1, [x19]
  4011f8:	14000004 	b	401208 <user_lp_Print+0xb88>
  4011fc:	f9400662 	ldr	x2, [x19, #8]
  401200:	93407c20 	sxtw	x0, w1
  401204:	8b000040 	add	x0, x2, x0
  401208:	b9400000 	ldr	w0, [x0]
  40120c:	3910dfe0 	strb	w0, [sp, #1079]
  401210:	910123e0 	add	x0, sp, #0x48
  401214:	b94457e3 	ldr	w3, [sp, #1108]
  401218:	b9445fe2 	ldr	w2, [sp, #1116]
  40121c:	3950dfe1 	ldrb	w1, [sp, #1079]
  401220:	9400006d 	bl	4013d4 <user_PrintChar>
  401224:	b90447e0 	str	w0, [sp, #1092]
  401228:	b94447e0 	ldr	w0, [sp, #1092]
  40122c:	7100001f 	cmp	w0, #0x0
  401230:	5400008b 	b.lt	401240 <user_lp_Print+0xbc0>  // b.tstop
  401234:	b94447e0 	ldr	w0, [sp, #1092]
  401238:	710fa01f 	cmp	w0, #0x3e8
  40123c:	5400010d 	b.le	40125c <user_lp_Print+0xbdc>
  401240:	f9401fe3 	ldr	x3, [sp, #56]
  401244:	528003a2 	mov	w2, #0x1d                  	// #29
  401248:	b0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  40124c:	91036001 	add	x1, x0, #0xd8
  401250:	f9401be0 	ldr	x0, [sp, #48]
  401254:	d63f0060 	blr	x3
  401258:	14000000 	b	401258 <user_lp_Print+0xbd8>
  40125c:	910123e0 	add	x0, sp, #0x48
  401260:	f9401fe3 	ldr	x3, [sp, #56]
  401264:	b94447e2 	ldr	w2, [sp, #1092]
  401268:	aa0003e1 	mov	x1, x0
  40126c:	f9401be0 	ldr	x0, [sp, #48]
  401270:	d63f0060 	blr	x3
  401274:	b98447e0 	ldrsw	x0, [sp, #1092]
  401278:	f9401be1 	ldr	x1, [sp, #48]
  40127c:	8b000020 	add	x0, x1, x0
  401280:	f9001be0 	str	x0, [sp, #48]
  401284:	14000041 	b	401388 <user_lp_Print+0xd08>
  401288:	b9401a61 	ldr	w1, [x19, #24]
  40128c:	f9400260 	ldr	x0, [x19]
  401290:	7100003f 	cmp	w1, #0x0
  401294:	540000ab 	b.lt	4012a8 <user_lp_Print+0xc28>  // b.tstop
  401298:	91003c01 	add	x1, x0, #0xf
  40129c:	927df021 	and	x1, x1, #0xfffffffffffffff8
  4012a0:	f9000261 	str	x1, [x19]
  4012a4:	1400000d 	b	4012d8 <user_lp_Print+0xc58>
  4012a8:	11002022 	add	w2, w1, #0x8
  4012ac:	b9001a62 	str	w2, [x19, #24]
  4012b0:	b9401a62 	ldr	w2, [x19, #24]
  4012b4:	7100005f 	cmp	w2, #0x0
  4012b8:	540000ad 	b.le	4012cc <user_lp_Print+0xc4c>
  4012bc:	91003c01 	add	x1, x0, #0xf
  4012c0:	927df021 	and	x1, x1, #0xfffffffffffffff8
  4012c4:	f9000261 	str	x1, [x19]
  4012c8:	14000004 	b	4012d8 <user_lp_Print+0xc58>
  4012cc:	f9400662 	ldr	x2, [x19, #8]
  4012d0:	93407c20 	sxtw	x0, w1
  4012d4:	8b000040 	add	x0, x2, x0
  4012d8:	f9400000 	ldr	x0, [x0]
  4012dc:	f9021fe0 	str	x0, [sp, #1080]
  4012e0:	910123e0 	add	x0, sp, #0x48
  4012e4:	b94457e3 	ldr	w3, [sp, #1108]
  4012e8:	b9445fe2 	ldr	w2, [sp, #1116]
  4012ec:	f9421fe1 	ldr	x1, [sp, #1080]
  4012f0:	94000071 	bl	4014b4 <user_PrintString>
  4012f4:	b90447e0 	str	w0, [sp, #1092]
  4012f8:	b94447e0 	ldr	w0, [sp, #1092]
  4012fc:	7100001f 	cmp	w0, #0x0
  401300:	5400008b 	b.lt	401310 <user_lp_Print+0xc90>  // b.tstop
  401304:	b94447e0 	ldr	w0, [sp, #1092]
  401308:	710fa01f 	cmp	w0, #0x3e8
  40130c:	5400010d 	b.le	40132c <user_lp_Print+0xcac>
  401310:	f9401fe3 	ldr	x3, [sp, #56]
  401314:	528003a2 	mov	w2, #0x1d                  	// #29
  401318:	b0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  40131c:	91036001 	add	x1, x0, #0xd8
  401320:	f9401be0 	ldr	x0, [sp, #48]
  401324:	d63f0060 	blr	x3
  401328:	14000000 	b	401328 <user_lp_Print+0xca8>
  40132c:	910123e0 	add	x0, sp, #0x48
  401330:	f9401fe3 	ldr	x3, [sp, #56]
  401334:	b94447e2 	ldr	w2, [sp, #1092]
  401338:	aa0003e1 	mov	x1, x0
  40133c:	f9401be0 	ldr	x0, [sp, #48]
  401340:	d63f0060 	blr	x3
  401344:	b98447e0 	ldrsw	x0, [sp, #1092]
  401348:	f9401be1 	ldr	x1, [sp, #48]
  40134c:	8b000020 	add	x0, x1, x0
  401350:	f9001be0 	str	x0, [sp, #48]
  401354:	1400000d 	b	401388 <user_lp_Print+0xd08>
  401358:	f94017e0 	ldr	x0, [sp, #40]
  40135c:	d1000400 	sub	x0, x0, #0x1
  401360:	f90017e0 	str	x0, [sp, #40]
  401364:	14000009 	b	401388 <user_lp_Print+0xd08>
  401368:	f9401fe3 	ldr	x3, [sp, #56]
  40136c:	52800022 	mov	w2, #0x1                   	// #1
  401370:	f94017e1 	ldr	x1, [sp, #40]
  401374:	f9401be0 	ldr	x0, [sp, #48]
  401378:	d63f0060 	blr	x3
  40137c:	f9401be0 	ldr	x0, [sp, #48]
  401380:	91000400 	add	x0, x0, #0x1
  401384:	f9001be0 	str	x0, [sp, #48]
  401388:	f94017e0 	ldr	x0, [sp, #40]
  40138c:	91000400 	add	x0, x0, #0x1
  401390:	f90017e0 	str	x0, [sp, #40]
  401394:	17fffcc3 	b	4006a0 <user_lp_Print+0x20>
  401398:	d503201f 	nop
  40139c:	f9401fe3 	ldr	x3, [sp, #56]
  4013a0:	52800022 	mov	w2, #0x1                   	// #1
  4013a4:	b0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  4013a8:	9103e001 	add	x1, x0, #0xf8
  4013ac:	f9401be0 	ldr	x0, [sp, #48]
  4013b0:	d63f0060 	blr	x3
  4013b4:	f9401be0 	ldr	x0, [sp, #48]
  4013b8:	91000400 	add	x0, x0, #0x1
  4013bc:	f9001be0 	str	x0, [sp, #48]
  4013c0:	d503201f 	nop
  4013c4:	f9400bf3 	ldr	x19, [sp, #16]
  4013c8:	a9407bfd 	ldp	x29, x30, [sp]
  4013cc:	9111c3ff 	add	sp, sp, #0x470
  4013d0:	d65f03c0 	ret

00000000004013d4 <user_PrintChar>:
user_PrintChar():
  4013d4:	d100c3ff 	sub	sp, sp, #0x30
  4013d8:	f9000fe0 	str	x0, [sp, #24]
  4013dc:	39005fe1 	strb	w1, [sp, #23]
  4013e0:	b90013e2 	str	w2, [sp, #16]
  4013e4:	b9000fe3 	str	w3, [sp, #12]
  4013e8:	b94013e0 	ldr	w0, [sp, #16]
  4013ec:	7100001f 	cmp	w0, #0x0
  4013f0:	5400006c 	b.gt	4013fc <user_PrintChar+0x28>
  4013f4:	52800020 	mov	w0, #0x1                   	// #1
  4013f8:	b90013e0 	str	w0, [sp, #16]
  4013fc:	b9400fe0 	ldr	w0, [sp, #12]
  401400:	7100001f 	cmp	w0, #0x0
  401404:	54000280 	b.eq	401454 <user_PrintChar+0x80>  // b.none
  401408:	f9400fe0 	ldr	x0, [sp, #24]
  40140c:	39405fe1 	ldrb	w1, [sp, #23]
  401410:	39000001 	strb	w1, [x0]
  401414:	52800020 	mov	w0, #0x1                   	// #1
  401418:	b9002fe0 	str	w0, [sp, #44]
  40141c:	14000009 	b	401440 <user_PrintChar+0x6c>
  401420:	b9802fe0 	ldrsw	x0, [sp, #44]
  401424:	f9400fe1 	ldr	x1, [sp, #24]
  401428:	8b000020 	add	x0, x1, x0
  40142c:	52800401 	mov	w1, #0x20                  	// #32
  401430:	39000001 	strb	w1, [x0]
  401434:	b9402fe0 	ldr	w0, [sp, #44]
  401438:	11000400 	add	w0, w0, #0x1
  40143c:	b9002fe0 	str	w0, [sp, #44]
  401440:	b9402fe1 	ldr	w1, [sp, #44]
  401444:	b94013e0 	ldr	w0, [sp, #16]
  401448:	6b00003f 	cmp	w1, w0
  40144c:	54fffeab 	b.lt	401420 <user_PrintChar+0x4c>  // b.tstop
  401450:	14000016 	b	4014a8 <user_PrintChar+0xd4>
  401454:	b9002fff 	str	wzr, [sp, #44]
  401458:	14000009 	b	40147c <user_PrintChar+0xa8>
  40145c:	b9802fe0 	ldrsw	x0, [sp, #44]
  401460:	f9400fe1 	ldr	x1, [sp, #24]
  401464:	8b000020 	add	x0, x1, x0
  401468:	52800401 	mov	w1, #0x20                  	// #32
  40146c:	39000001 	strb	w1, [x0]
  401470:	b9402fe0 	ldr	w0, [sp, #44]
  401474:	11000400 	add	w0, w0, #0x1
  401478:	b9002fe0 	str	w0, [sp, #44]
  40147c:	b94013e0 	ldr	w0, [sp, #16]
  401480:	51000400 	sub	w0, w0, #0x1
  401484:	b9402fe1 	ldr	w1, [sp, #44]
  401488:	6b00003f 	cmp	w1, w0
  40148c:	54fffe8b 	b.lt	40145c <user_PrintChar+0x88>  // b.tstop
  401490:	b98013e0 	ldrsw	x0, [sp, #16]
  401494:	d1000400 	sub	x0, x0, #0x1
  401498:	f9400fe1 	ldr	x1, [sp, #24]
  40149c:	8b000020 	add	x0, x1, x0
  4014a0:	39405fe1 	ldrb	w1, [sp, #23]
  4014a4:	39000001 	strb	w1, [x0]
  4014a8:	b94013e0 	ldr	w0, [sp, #16]
  4014ac:	9100c3ff 	add	sp, sp, #0x30
  4014b0:	d65f03c0 	ret

00000000004014b4 <user_PrintString>:
user_PrintString():
  4014b4:	d100c3ff 	sub	sp, sp, #0x30
  4014b8:	f9000fe0 	str	x0, [sp, #24]
  4014bc:	f9000be1 	str	x1, [sp, #16]
  4014c0:	b9000fe2 	str	w2, [sp, #12]
  4014c4:	b9000be3 	str	w3, [sp, #8]
  4014c8:	b9002bff 	str	wzr, [sp, #40]
  4014cc:	f9400be0 	ldr	x0, [sp, #16]
  4014d0:	f90013e0 	str	x0, [sp, #32]
  4014d4:	14000004 	b	4014e4 <user_PrintString+0x30>
  4014d8:	b9402be0 	ldr	w0, [sp, #40]
  4014dc:	11000400 	add	w0, w0, #0x1
  4014e0:	b9002be0 	str	w0, [sp, #40]
  4014e4:	f94013e0 	ldr	x0, [sp, #32]
  4014e8:	91000401 	add	x1, x0, #0x1
  4014ec:	f90013e1 	str	x1, [sp, #32]
  4014f0:	39400000 	ldrb	w0, [x0]
  4014f4:	7100001f 	cmp	w0, #0x0
  4014f8:	54ffff01 	b.ne	4014d8 <user_PrintString+0x24>  // b.any
  4014fc:	b9400fe1 	ldr	w1, [sp, #12]
  401500:	b9402be0 	ldr	w0, [sp, #40]
  401504:	6b00003f 	cmp	w1, w0
  401508:	5400006a 	b.ge	401514 <user_PrintString+0x60>  // b.tcont
  40150c:	b9402be0 	ldr	w0, [sp, #40]
  401510:	b9000fe0 	str	w0, [sp, #12]
  401514:	b9400be0 	ldr	w0, [sp, #8]
  401518:	7100001f 	cmp	w0, #0x0
  40151c:	54000440 	b.eq	4015a4 <user_PrintString+0xf0>  // b.none
  401520:	b9002fff 	str	wzr, [sp, #44]
  401524:	1400000c 	b	401554 <user_PrintString+0xa0>
  401528:	b9802fe0 	ldrsw	x0, [sp, #44]
  40152c:	f9400be1 	ldr	x1, [sp, #16]
  401530:	8b000021 	add	x1, x1, x0
  401534:	b9802fe0 	ldrsw	x0, [sp, #44]
  401538:	f9400fe2 	ldr	x2, [sp, #24]
  40153c:	8b000040 	add	x0, x2, x0
  401540:	39400021 	ldrb	w1, [x1]
  401544:	39000001 	strb	w1, [x0]
  401548:	b9402fe0 	ldr	w0, [sp, #44]
  40154c:	11000400 	add	w0, w0, #0x1
  401550:	b9002fe0 	str	w0, [sp, #44]
  401554:	b9402fe1 	ldr	w1, [sp, #44]
  401558:	b9402be0 	ldr	w0, [sp, #40]
  40155c:	6b00003f 	cmp	w1, w0
  401560:	54fffe4b 	b.lt	401528 <user_PrintString+0x74>  // b.tstop
  401564:	b9402be0 	ldr	w0, [sp, #40]
  401568:	b9002fe0 	str	w0, [sp, #44]
  40156c:	14000009 	b	401590 <user_PrintString+0xdc>
  401570:	b9802fe0 	ldrsw	x0, [sp, #44]
  401574:	f9400fe1 	ldr	x1, [sp, #24]
  401578:	8b000020 	add	x0, x1, x0
  40157c:	52800401 	mov	w1, #0x20                  	// #32
  401580:	39000001 	strb	w1, [x0]
  401584:	b9402fe0 	ldr	w0, [sp, #44]
  401588:	11000400 	add	w0, w0, #0x1
  40158c:	b9002fe0 	str	w0, [sp, #44]
  401590:	b9402fe1 	ldr	w1, [sp, #44]
  401594:	b9400fe0 	ldr	w0, [sp, #12]
  401598:	6b00003f 	cmp	w1, w0
  40159c:	54fffeab 	b.lt	401570 <user_PrintString+0xbc>  // b.tstop
  4015a0:	1400002a 	b	401648 <user_PrintString+0x194>
  4015a4:	b9002fff 	str	wzr, [sp, #44]
  4015a8:	14000009 	b	4015cc <user_PrintString+0x118>
  4015ac:	b9802fe0 	ldrsw	x0, [sp, #44]
  4015b0:	f9400fe1 	ldr	x1, [sp, #24]
  4015b4:	8b000020 	add	x0, x1, x0
  4015b8:	52800401 	mov	w1, #0x20                  	// #32
  4015bc:	39000001 	strb	w1, [x0]
  4015c0:	b9402fe0 	ldr	w0, [sp, #44]
  4015c4:	11000400 	add	w0, w0, #0x1
  4015c8:	b9002fe0 	str	w0, [sp, #44]
  4015cc:	b9400fe1 	ldr	w1, [sp, #12]
  4015d0:	b9402be0 	ldr	w0, [sp, #40]
  4015d4:	4b000020 	sub	w0, w1, w0
  4015d8:	b9402fe1 	ldr	w1, [sp, #44]
  4015dc:	6b00003f 	cmp	w1, w0
  4015e0:	54fffe6b 	b.lt	4015ac <user_PrintString+0xf8>  // b.tstop
  4015e4:	b9400fe1 	ldr	w1, [sp, #12]
  4015e8:	b9402be0 	ldr	w0, [sp, #40]
  4015ec:	4b000020 	sub	w0, w1, w0
  4015f0:	b9002fe0 	str	w0, [sp, #44]
  4015f4:	14000011 	b	401638 <user_PrintString+0x184>
  4015f8:	b9402fe1 	ldr	w1, [sp, #44]
  4015fc:	b9400fe0 	ldr	w0, [sp, #12]
  401600:	4b000021 	sub	w1, w1, w0
  401604:	b9402be0 	ldr	w0, [sp, #40]
  401608:	0b000020 	add	w0, w1, w0
  40160c:	93407c00 	sxtw	x0, w0
  401610:	f9400be1 	ldr	x1, [sp, #16]
  401614:	8b000021 	add	x1, x1, x0
  401618:	b9802fe0 	ldrsw	x0, [sp, #44]
  40161c:	f9400fe2 	ldr	x2, [sp, #24]
  401620:	8b000040 	add	x0, x2, x0
  401624:	39400021 	ldrb	w1, [x1]
  401628:	39000001 	strb	w1, [x0]
  40162c:	b9402fe0 	ldr	w0, [sp, #44]
  401630:	11000400 	add	w0, w0, #0x1
  401634:	b9002fe0 	str	w0, [sp, #44]
  401638:	b9402fe1 	ldr	w1, [sp, #44]
  40163c:	b9400fe0 	ldr	w0, [sp, #12]
  401640:	6b00003f 	cmp	w1, w0
  401644:	54fffdab 	b.lt	4015f8 <user_PrintString+0x144>  // b.tstop
  401648:	b9400fe0 	ldr	w0, [sp, #12]
  40164c:	9100c3ff 	add	sp, sp, #0x30
  401650:	d65f03c0 	ret

0000000000401654 <user_PrintNum>:
user_PrintNum():
  401654:	d10143ff 	sub	sp, sp, #0x50
  401658:	f90017e0 	str	x0, [sp, #40]
  40165c:	f90013e1 	str	x1, [sp, #32]
  401660:	b9001fe2 	str	w2, [sp, #28]
  401664:	b9001be3 	str	w3, [sp, #24]
  401668:	b90017e4 	str	w4, [sp, #20]
  40166c:	b90013e5 	str	w5, [sp, #16]
  401670:	39003fe6 	strb	w6, [sp, #15]
  401674:	b9000be7 	str	w7, [sp, #8]
  401678:	b9003bff 	str	wzr, [sp, #56]
  40167c:	f94017e0 	ldr	x0, [sp, #40]
  401680:	f90027e0 	str	x0, [sp, #72]
  401684:	b9801fe1 	ldrsw	x1, [sp, #28]
  401688:	f94013e0 	ldr	x0, [sp, #32]
  40168c:	9ac10802 	udiv	x2, x0, x1
  401690:	9b017c41 	mul	x1, x2, x1
  401694:	cb010000 	sub	x0, x0, x1
  401698:	b90037e0 	str	w0, [sp, #52]
  40169c:	b94037e0 	ldr	w0, [sp, #52]
  4016a0:	7100241f 	cmp	w0, #0x9
  4016a4:	5400014c 	b.gt	4016cc <user_PrintNum+0x78>
  4016a8:	b94037e0 	ldr	w0, [sp, #52]
  4016ac:	12001c01 	and	w1, w0, #0xff
  4016b0:	f94027e0 	ldr	x0, [sp, #72]
  4016b4:	91000402 	add	x2, x0, #0x1
  4016b8:	f90027e2 	str	x2, [sp, #72]
  4016bc:	1100c021 	add	w1, w1, #0x30
  4016c0:	12001c21 	and	w1, w1, #0xff
  4016c4:	39000001 	strb	w1, [x0]
  4016c8:	14000015 	b	40171c <user_PrintNum+0xc8>
  4016cc:	b9400be0 	ldr	w0, [sp, #8]
  4016d0:	7100001f 	cmp	w0, #0x0
  4016d4:	54000140 	b.eq	4016fc <user_PrintNum+0xa8>  // b.none
  4016d8:	b94037e0 	ldr	w0, [sp, #52]
  4016dc:	12001c01 	and	w1, w0, #0xff
  4016e0:	f94027e0 	ldr	x0, [sp, #72]
  4016e4:	91000402 	add	x2, x0, #0x1
  4016e8:	f90027e2 	str	x2, [sp, #72]
  4016ec:	1100dc21 	add	w1, w1, #0x37
  4016f0:	12001c21 	and	w1, w1, #0xff
  4016f4:	39000001 	strb	w1, [x0]
  4016f8:	14000009 	b	40171c <user_PrintNum+0xc8>
  4016fc:	b94037e0 	ldr	w0, [sp, #52]
  401700:	12001c01 	and	w1, w0, #0xff
  401704:	f94027e0 	ldr	x0, [sp, #72]
  401708:	91000402 	add	x2, x0, #0x1
  40170c:	f90027e2 	str	x2, [sp, #72]
  401710:	11015c21 	add	w1, w1, #0x57
  401714:	12001c21 	and	w1, w1, #0xff
  401718:	39000001 	strb	w1, [x0]
  40171c:	b9801fe0 	ldrsw	x0, [sp, #28]
  401720:	f94013e1 	ldr	x1, [sp, #32]
  401724:	9ac00820 	udiv	x0, x1, x0
  401728:	f90013e0 	str	x0, [sp, #32]
  40172c:	f94013e0 	ldr	x0, [sp, #32]
  401730:	f100001f 	cmp	x0, #0x0
  401734:	54fffa81 	b.ne	401684 <user_PrintNum+0x30>  // b.any
  401738:	b9401be0 	ldr	w0, [sp, #24]
  40173c:	7100001f 	cmp	w0, #0x0
  401740:	540000c0 	b.eq	401758 <user_PrintNum+0x104>  // b.none
  401744:	f94027e0 	ldr	x0, [sp, #72]
  401748:	91000401 	add	x1, x0, #0x1
  40174c:	f90027e1 	str	x1, [sp, #72]
  401750:	528005a1 	mov	w1, #0x2d                  	// #45
  401754:	39000001 	strb	w1, [x0]
  401758:	f94027e1 	ldr	x1, [sp, #72]
  40175c:	f94017e0 	ldr	x0, [sp, #40]
  401760:	cb000020 	sub	x0, x1, x0
  401764:	b9003be0 	str	w0, [sp, #56]
  401768:	b94017e1 	ldr	w1, [sp, #20]
  40176c:	b9403be0 	ldr	w0, [sp, #56]
  401770:	6b00003f 	cmp	w1, w0
  401774:	5400006a 	b.ge	401780 <user_PrintNum+0x12c>  // b.tcont
  401778:	b9403be0 	ldr	w0, [sp, #56]
  40177c:	b90017e0 	str	w0, [sp, #20]
  401780:	b94013e0 	ldr	w0, [sp, #16]
  401784:	7100001f 	cmp	w0, #0x0
  401788:	54000060 	b.eq	401794 <user_PrintNum+0x140>  // b.none
  40178c:	52800400 	mov	w0, #0x20                  	// #32
  401790:	39003fe0 	strb	w0, [sp, #15]
  401794:	b9401be0 	ldr	w0, [sp, #24]
  401798:	7100001f 	cmp	w0, #0x0
  40179c:	540003e0 	b.eq	401818 <user_PrintNum+0x1c4>  // b.none
  4017a0:	b94013e0 	ldr	w0, [sp, #16]
  4017a4:	7100001f 	cmp	w0, #0x0
  4017a8:	54000381 	b.ne	401818 <user_PrintNum+0x1c4>  // b.any
  4017ac:	39403fe0 	ldrb	w0, [sp, #15]
  4017b0:	7100c01f 	cmp	w0, #0x30
  4017b4:	54000321 	b.ne	401818 <user_PrintNum+0x1c4>  // b.any
  4017b8:	b9403be0 	ldr	w0, [sp, #56]
  4017bc:	51000400 	sub	w0, w0, #0x1
  4017c0:	b90047e0 	str	w0, [sp, #68]
  4017c4:	14000009 	b	4017e8 <user_PrintNum+0x194>
  4017c8:	b98047e0 	ldrsw	x0, [sp, #68]
  4017cc:	f94017e1 	ldr	x1, [sp, #40]
  4017d0:	8b000020 	add	x0, x1, x0
  4017d4:	39403fe1 	ldrb	w1, [sp, #15]
  4017d8:	39000001 	strb	w1, [x0]
  4017dc:	b94047e0 	ldr	w0, [sp, #68]
  4017e0:	11000400 	add	w0, w0, #0x1
  4017e4:	b90047e0 	str	w0, [sp, #68]
  4017e8:	b94017e0 	ldr	w0, [sp, #20]
  4017ec:	51000400 	sub	w0, w0, #0x1
  4017f0:	b94047e1 	ldr	w1, [sp, #68]
  4017f4:	6b00003f 	cmp	w1, w0
  4017f8:	54fffe8b 	b.lt	4017c8 <user_PrintNum+0x174>  // b.tstop
  4017fc:	b98017e0 	ldrsw	x0, [sp, #20]
  401800:	d1000400 	sub	x0, x0, #0x1
  401804:	f94017e1 	ldr	x1, [sp, #40]
  401808:	8b000020 	add	x0, x1, x0
  40180c:	528005a1 	mov	w1, #0x2d                  	// #45
  401810:	39000001 	strb	w1, [x0]
  401814:	14000010 	b	401854 <user_PrintNum+0x200>
  401818:	b9403be0 	ldr	w0, [sp, #56]
  40181c:	b90047e0 	str	w0, [sp, #68]
  401820:	14000009 	b	401844 <user_PrintNum+0x1f0>
  401824:	b98047e0 	ldrsw	x0, [sp, #68]
  401828:	f94017e1 	ldr	x1, [sp, #40]
  40182c:	8b000020 	add	x0, x1, x0
  401830:	39403fe1 	ldrb	w1, [sp, #15]
  401834:	39000001 	strb	w1, [x0]
  401838:	b94047e0 	ldr	w0, [sp, #68]
  40183c:	11000400 	add	w0, w0, #0x1
  401840:	b90047e0 	str	w0, [sp, #68]
  401844:	b94047e1 	ldr	w1, [sp, #68]
  401848:	b94017e0 	ldr	w0, [sp, #20]
  40184c:	6b00003f 	cmp	w1, w0
  401850:	54fffeab 	b.lt	401824 <user_PrintNum+0x1d0>  // b.tstop
  401854:	b90043ff 	str	wzr, [sp, #64]
  401858:	b94013e0 	ldr	w0, [sp, #16]
  40185c:	7100001f 	cmp	w0, #0x0
  401860:	540000a0 	b.eq	401874 <user_PrintNum+0x220>  // b.none
  401864:	b9403be0 	ldr	w0, [sp, #56]
  401868:	51000400 	sub	w0, w0, #0x1
  40186c:	b9003fe0 	str	w0, [sp, #60]
  401870:	1400001d 	b	4018e4 <user_PrintNum+0x290>
  401874:	b94017e0 	ldr	w0, [sp, #20]
  401878:	51000400 	sub	w0, w0, #0x1
  40187c:	b9003fe0 	str	w0, [sp, #60]
  401880:	14000019 	b	4018e4 <user_PrintNum+0x290>
  401884:	b98043e0 	ldrsw	x0, [sp, #64]
  401888:	f94017e1 	ldr	x1, [sp, #40]
  40188c:	8b000020 	add	x0, x1, x0
  401890:	39400000 	ldrb	w0, [x0]
  401894:	3900cfe0 	strb	w0, [sp, #51]
  401898:	b9803fe0 	ldrsw	x0, [sp, #60]
  40189c:	f94017e1 	ldr	x1, [sp, #40]
  4018a0:	8b000021 	add	x1, x1, x0
  4018a4:	b98043e0 	ldrsw	x0, [sp, #64]
  4018a8:	f94017e2 	ldr	x2, [sp, #40]
  4018ac:	8b000040 	add	x0, x2, x0
  4018b0:	39400021 	ldrb	w1, [x1]
  4018b4:	39000001 	strb	w1, [x0]
  4018b8:	b9803fe0 	ldrsw	x0, [sp, #60]
  4018bc:	f94017e1 	ldr	x1, [sp, #40]
  4018c0:	8b000020 	add	x0, x1, x0
  4018c4:	3940cfe1 	ldrb	w1, [sp, #51]
  4018c8:	39000001 	strb	w1, [x0]
  4018cc:	b94043e0 	ldr	w0, [sp, #64]
  4018d0:	11000400 	add	w0, w0, #0x1
  4018d4:	b90043e0 	str	w0, [sp, #64]
  4018d8:	b9403fe0 	ldr	w0, [sp, #60]
  4018dc:	51000400 	sub	w0, w0, #0x1
  4018e0:	b9003fe0 	str	w0, [sp, #60]
  4018e4:	b9403fe1 	ldr	w1, [sp, #60]
  4018e8:	b94043e0 	ldr	w0, [sp, #64]
  4018ec:	6b00003f 	cmp	w1, w0
  4018f0:	54fffcac 	b.gt	401884 <user_PrintNum+0x230>
  4018f4:	b94017e0 	ldr	w0, [sp, #20]
  4018f8:	910143ff 	add	sp, sp, #0x50
  4018fc:	d65f03c0 	ret

0000000000401900 <user_myoutput>:
user_myoutput():
  401900:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
  401904:	910003fd 	mov	x29, sp
  401908:	f90017e0 	str	x0, [sp, #40]
  40190c:	f90013e1 	str	x1, [sp, #32]
  401910:	b9001fe2 	str	w2, [sp, #28]
  401914:	b9401fe0 	ldr	w0, [sp, #28]
  401918:	7100041f 	cmp	w0, #0x1
  40191c:	540000a1 	b.ne	401930 <user_myoutput+0x30>  // b.any
  401920:	f94013e0 	ldr	x0, [sp, #32]
  401924:	39400000 	ldrb	w0, [x0]
  401928:	7100001f 	cmp	w0, #0x0
  40192c:	54000300 	b.eq	40198c <user_myoutput+0x8c>  // b.none
  401930:	b9003fff 	str	wzr, [sp, #60]
  401934:	14000011 	b	401978 <user_myoutput+0x78>
  401938:	b9803fe0 	ldrsw	x0, [sp, #60]
  40193c:	f94013e1 	ldr	x1, [sp, #32]
  401940:	8b000020 	add	x0, x1, x0
  401944:	39400000 	ldrb	w0, [x0]
  401948:	940000ec 	bl	401cf8 <syscall_putchar>
  40194c:	b9803fe0 	ldrsw	x0, [sp, #60]
  401950:	f94013e1 	ldr	x1, [sp, #32]
  401954:	8b000020 	add	x0, x1, x0
  401958:	39400000 	ldrb	w0, [x0]
  40195c:	7100281f 	cmp	w0, #0xa
  401960:	54000061 	b.ne	40196c <user_myoutput+0x6c>  // b.any
  401964:	52800140 	mov	w0, #0xa                   	// #10
  401968:	940000e4 	bl	401cf8 <syscall_putchar>
  40196c:	b9403fe0 	ldr	w0, [sp, #60]
  401970:	11000400 	add	w0, w0, #0x1
  401974:	b9003fe0 	str	w0, [sp, #60]
  401978:	b9403fe1 	ldr	w1, [sp, #60]
  40197c:	b9401fe0 	ldr	w0, [sp, #28]
  401980:	6b00003f 	cmp	w1, w0
  401984:	54fffdab 	b.lt	401938 <user_myoutput+0x38>  // b.tstop
  401988:	14000002 	b	401990 <user_myoutput+0x90>
  40198c:	d503201f 	nop
  401990:	a8c47bfd 	ldp	x29, x30, [sp], #64
  401994:	d65f03c0 	ret

0000000000401998 <writef>:
writef():
  401998:	a9ae7bfd 	stp	x29, x30, [sp, #-288]!
  40199c:	910003fd 	mov	x29, sp
  4019a0:	f9001fe0 	str	x0, [sp, #56]
  4019a4:	f90077e1 	str	x1, [sp, #232]
  4019a8:	f9007be2 	str	x2, [sp, #240]
  4019ac:	f9007fe3 	str	x3, [sp, #248]
  4019b0:	f90083e4 	str	x4, [sp, #256]
  4019b4:	f90087e5 	str	x5, [sp, #264]
  4019b8:	f9008be6 	str	x6, [sp, #272]
  4019bc:	f9008fe7 	str	x7, [sp, #280]
  4019c0:	3d801be0 	str	q0, [sp, #96]
  4019c4:	3d801fe1 	str	q1, [sp, #112]
  4019c8:	3d8023e2 	str	q2, [sp, #128]
  4019cc:	3d8027e3 	str	q3, [sp, #144]
  4019d0:	3d802be4 	str	q4, [sp, #160]
  4019d4:	3d802fe5 	str	q5, [sp, #176]
  4019d8:	3d8033e6 	str	q6, [sp, #192]
  4019dc:	3d8037e7 	str	q7, [sp, #208]
  4019e0:	910483e0 	add	x0, sp, #0x120
  4019e4:	f90023e0 	str	x0, [sp, #64]
  4019e8:	910483e0 	add	x0, sp, #0x120
  4019ec:	f90027e0 	str	x0, [sp, #72]
  4019f0:	910383e0 	add	x0, sp, #0xe0
  4019f4:	f9002be0 	str	x0, [sp, #80]
  4019f8:	128006e0 	mov	w0, #0xffffffc8            	// #-56
  4019fc:	b9005be0 	str	w0, [sp, #88]
  401a00:	12800fe0 	mov	w0, #0xffffff80            	// #-128
  401a04:	b9005fe0 	str	w0, [sp, #92]
  401a08:	910043e2 	add	x2, sp, #0x10
  401a0c:	910103e3 	add	x3, sp, #0x40
  401a10:	a9400460 	ldp	x0, x1, [x3]
  401a14:	a9000440 	stp	x0, x1, [x2]
  401a18:	a9410460 	ldp	x0, x1, [x3, #16]
  401a1c:	a9010440 	stp	x0, x1, [x2, #16]
  401a20:	910043e0 	add	x0, sp, #0x10
  401a24:	aa0003e3 	mov	x3, x0
  401a28:	f9401fe2 	ldr	x2, [sp, #56]
  401a2c:	d2800001 	mov	x1, #0x0                   	// #0
  401a30:	90000000 	adrp	x0, 401000 <user_lp_Print+0x980>
  401a34:	91240000 	add	x0, x0, #0x900
  401a38:	97fffb12 	bl	400680 <user_lp_Print>
  401a3c:	d503201f 	nop
  401a40:	a8d27bfd 	ldp	x29, x30, [sp], #288
  401a44:	d65f03c0 	ret

0000000000401a48 <_user_panic>:
_user_panic():
  401a48:	a9ae7bfd 	stp	x29, x30, [sp, #-288]!
  401a4c:	910003fd 	mov	x29, sp
  401a50:	f90027e0 	str	x0, [sp, #72]
  401a54:	b90047e1 	str	w1, [sp, #68]
  401a58:	f9001fe2 	str	x2, [sp, #56]
  401a5c:	f9007fe3 	str	x3, [sp, #248]
  401a60:	f90083e4 	str	x4, [sp, #256]
  401a64:	f90087e5 	str	x5, [sp, #264]
  401a68:	f9008be6 	str	x6, [sp, #272]
  401a6c:	f9008fe7 	str	x7, [sp, #280]
  401a70:	3d801fe0 	str	q0, [sp, #112]
  401a74:	3d8023e1 	str	q1, [sp, #128]
  401a78:	3d8027e2 	str	q2, [sp, #144]
  401a7c:	3d802be3 	str	q3, [sp, #160]
  401a80:	3d802fe4 	str	q4, [sp, #176]
  401a84:	3d8033e5 	str	q5, [sp, #192]
  401a88:	3d8037e6 	str	q6, [sp, #208]
  401a8c:	3d803be7 	str	q7, [sp, #224]
  401a90:	910483e0 	add	x0, sp, #0x120
  401a94:	f9002be0 	str	x0, [sp, #80]
  401a98:	910483e0 	add	x0, sp, #0x120
  401a9c:	f9002fe0 	str	x0, [sp, #88]
  401aa0:	9103c3e0 	add	x0, sp, #0xf0
  401aa4:	f90033e0 	str	x0, [sp, #96]
  401aa8:	128004e0 	mov	w0, #0xffffffd8            	// #-40
  401aac:	b9006be0 	str	w0, [sp, #104]
  401ab0:	12800fe0 	mov	w0, #0xffffff80            	// #-128
  401ab4:	b9006fe0 	str	w0, [sp, #108]
  401ab8:	b94047e2 	ldr	w2, [sp, #68]
  401abc:	f94027e1 	ldr	x1, [sp, #72]
  401ac0:	b0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  401ac4:	91040000 	add	x0, x0, #0x100
  401ac8:	97ffffb4 	bl	401998 <writef>
  401acc:	910043e2 	add	x2, sp, #0x10
  401ad0:	910143e3 	add	x3, sp, #0x50
  401ad4:	a9400460 	ldp	x0, x1, [x3]
  401ad8:	a9000440 	stp	x0, x1, [x2]
  401adc:	a9410460 	ldp	x0, x1, [x3, #16]
  401ae0:	a9010440 	stp	x0, x1, [x2, #16]
  401ae4:	910043e0 	add	x0, sp, #0x10
  401ae8:	aa0003e3 	mov	x3, x0
  401aec:	f9401fe2 	ldr	x2, [sp, #56]
  401af0:	d2800001 	mov	x1, #0x0                   	// #0
  401af4:	90000000 	adrp	x0, 401000 <user_lp_Print+0x980>
  401af8:	91240000 	add	x0, x0, #0x900
  401afc:	97fffae1 	bl	400680 <user_lp_Print>
  401b00:	b0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x28>
  401b04:	91046000 	add	x0, x0, #0x118
  401b08:	97ffffa4 	bl	401998 <writef>
  401b0c:	14000000 	b	401b0c <_user_panic+0xc4>

0000000000401b10 <strlen>:
strlen():
  401b10:	d10083ff 	sub	sp, sp, #0x20
  401b14:	f90007e0 	str	x0, [sp, #8]
  401b18:	b9001fff 	str	wzr, [sp, #28]
  401b1c:	14000007 	b	401b38 <strlen+0x28>
  401b20:	b9401fe0 	ldr	w0, [sp, #28]
  401b24:	11000400 	add	w0, w0, #0x1
  401b28:	b9001fe0 	str	w0, [sp, #28]
  401b2c:	f94007e0 	ldr	x0, [sp, #8]
  401b30:	91000400 	add	x0, x0, #0x1
  401b34:	f90007e0 	str	x0, [sp, #8]
  401b38:	f94007e0 	ldr	x0, [sp, #8]
  401b3c:	39400000 	ldrb	w0, [x0]
  401b40:	7100001f 	cmp	w0, #0x0
  401b44:	54fffee1 	b.ne	401b20 <strlen+0x10>  // b.any
  401b48:	b9401fe0 	ldr	w0, [sp, #28]
  401b4c:	910083ff 	add	sp, sp, #0x20
  401b50:	d65f03c0 	ret

0000000000401b54 <strcpy>:
strcpy():
  401b54:	d10083ff 	sub	sp, sp, #0x20
  401b58:	f90007e0 	str	x0, [sp, #8]
  401b5c:	f90003e1 	str	x1, [sp]
  401b60:	f94007e0 	ldr	x0, [sp, #8]
  401b64:	f9000fe0 	str	x0, [sp, #24]
  401b68:	d503201f 	nop
  401b6c:	f94003e1 	ldr	x1, [sp]
  401b70:	91000420 	add	x0, x1, #0x1
  401b74:	f90003e0 	str	x0, [sp]
  401b78:	f94007e0 	ldr	x0, [sp, #8]
  401b7c:	91000402 	add	x2, x0, #0x1
  401b80:	f90007e2 	str	x2, [sp, #8]
  401b84:	39400021 	ldrb	w1, [x1]
  401b88:	39000001 	strb	w1, [x0]
  401b8c:	39400000 	ldrb	w0, [x0]
  401b90:	7100001f 	cmp	w0, #0x0
  401b94:	54fffec1 	b.ne	401b6c <strcpy+0x18>  // b.any
  401b98:	f9400fe0 	ldr	x0, [sp, #24]
  401b9c:	910083ff 	add	sp, sp, #0x20
  401ba0:	d65f03c0 	ret

0000000000401ba4 <strchr>:
strchr():
  401ba4:	d10043ff 	sub	sp, sp, #0x10
  401ba8:	f90007e0 	str	x0, [sp, #8]
  401bac:	39001fe1 	strb	w1, [sp, #7]
  401bb0:	1400000b 	b	401bdc <strchr+0x38>
  401bb4:	f94007e0 	ldr	x0, [sp, #8]
  401bb8:	39400000 	ldrb	w0, [x0]
  401bbc:	39401fe1 	ldrb	w1, [sp, #7]
  401bc0:	6b00003f 	cmp	w1, w0
  401bc4:	54000061 	b.ne	401bd0 <strchr+0x2c>  // b.any
  401bc8:	f94007e0 	ldr	x0, [sp, #8]
  401bcc:	14000009 	b	401bf0 <strchr+0x4c>
  401bd0:	f94007e0 	ldr	x0, [sp, #8]
  401bd4:	91000400 	add	x0, x0, #0x1
  401bd8:	f90007e0 	str	x0, [sp, #8]
  401bdc:	f94007e0 	ldr	x0, [sp, #8]
  401be0:	39400000 	ldrb	w0, [x0]
  401be4:	7100001f 	cmp	w0, #0x0
  401be8:	54fffe61 	b.ne	401bb4 <strchr+0x10>  // b.any
  401bec:	d2800000 	mov	x0, #0x0                   	// #0
  401bf0:	910043ff 	add	sp, sp, #0x10
  401bf4:	d65f03c0 	ret

0000000000401bf8 <memcpy>:
memcpy():
  401bf8:	d100c3ff 	sub	sp, sp, #0x30
  401bfc:	f9000fe0 	str	x0, [sp, #24]
  401c00:	f9000be1 	str	x1, [sp, #16]
  401c04:	b9000fe2 	str	w2, [sp, #12]
  401c08:	f9400fe0 	ldr	x0, [sp, #24]
  401c0c:	f90017e0 	str	x0, [sp, #40]
  401c10:	f9400be0 	ldr	x0, [sp, #16]
  401c14:	f90013e0 	str	x0, [sp, #32]
  401c18:	14000009 	b	401c3c <memcpy+0x44>
  401c1c:	f94013e1 	ldr	x1, [sp, #32]
  401c20:	91000420 	add	x0, x1, #0x1
  401c24:	f90013e0 	str	x0, [sp, #32]
  401c28:	f94017e0 	ldr	x0, [sp, #40]
  401c2c:	91000402 	add	x2, x0, #0x1
  401c30:	f90017e2 	str	x2, [sp, #40]
  401c34:	39400021 	ldrb	w1, [x1]
  401c38:	39000001 	strb	w1, [x0]
  401c3c:	b9400fe0 	ldr	w0, [sp, #12]
  401c40:	51000401 	sub	w1, w0, #0x1
  401c44:	b9000fe1 	str	w1, [sp, #12]
  401c48:	7100001f 	cmp	w0, #0x0
  401c4c:	54fffe81 	b.ne	401c1c <memcpy+0x24>  // b.any
  401c50:	f9400fe0 	ldr	x0, [sp, #24]
  401c54:	9100c3ff 	add	sp, sp, #0x30
  401c58:	d65f03c0 	ret

0000000000401c5c <strcmp>:
strcmp():
  401c5c:	d10043ff 	sub	sp, sp, #0x10
  401c60:	f90007e0 	str	x0, [sp, #8]
  401c64:	f90003e1 	str	x1, [sp]
  401c68:	14000007 	b	401c84 <strcmp+0x28>
  401c6c:	f94007e0 	ldr	x0, [sp, #8]
  401c70:	91000400 	add	x0, x0, #0x1
  401c74:	f90007e0 	str	x0, [sp, #8]
  401c78:	f94003e0 	ldr	x0, [sp]
  401c7c:	91000400 	add	x0, x0, #0x1
  401c80:	f90003e0 	str	x0, [sp]
  401c84:	f94007e0 	ldr	x0, [sp, #8]
  401c88:	39400000 	ldrb	w0, [x0]
  401c8c:	7100001f 	cmp	w0, #0x0
  401c90:	540000e0 	b.eq	401cac <strcmp+0x50>  // b.none
  401c94:	f94007e0 	ldr	x0, [sp, #8]
  401c98:	39400001 	ldrb	w1, [x0]
  401c9c:	f94003e0 	ldr	x0, [sp]
  401ca0:	39400000 	ldrb	w0, [x0]
  401ca4:	6b00003f 	cmp	w1, w0
  401ca8:	54fffe20 	b.eq	401c6c <strcmp+0x10>  // b.none
  401cac:	f94007e0 	ldr	x0, [sp, #8]
  401cb0:	39400001 	ldrb	w1, [x0]
  401cb4:	f94003e0 	ldr	x0, [sp]
  401cb8:	39400000 	ldrb	w0, [x0]
  401cbc:	6b00003f 	cmp	w1, w0
  401cc0:	54000062 	b.cs	401ccc <strcmp+0x70>  // b.hs, b.nlast
  401cc4:	12800000 	mov	w0, #0xffffffff            	// #-1
  401cc8:	1400000a 	b	401cf0 <strcmp+0x94>
  401ccc:	f94007e0 	ldr	x0, [sp, #8]
  401cd0:	39400001 	ldrb	w1, [x0]
  401cd4:	f94003e0 	ldr	x0, [sp]
  401cd8:	39400000 	ldrb	w0, [x0]
  401cdc:	6b00003f 	cmp	w1, w0
  401ce0:	54000069 	b.ls	401cec <strcmp+0x90>  // b.plast
  401ce4:	52800020 	mov	w0, #0x1                   	// #1
  401ce8:	14000002 	b	401cf0 <strcmp+0x94>
  401cec:	52800000 	mov	w0, #0x0                   	// #0
  401cf0:	910043ff 	add	sp, sp, #0x10
  401cf4:	d65f03c0 	ret

0000000000401cf8 <syscall_putchar>:
syscall_putchar():
  401cf8:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
  401cfc:	910003fd 	mov	x29, sp
  401d00:	39007fe0 	strb	w0, [sp, #31]
  401d04:	39407fe0 	ldrb	w0, [sp, #31]
  401d08:	d2800005 	mov	x5, #0x0                   	// #0
  401d0c:	d2800004 	mov	x4, #0x0                   	// #0
  401d10:	d2800003 	mov	x3, #0x0                   	// #0
  401d14:	d2800002 	mov	x2, #0x0                   	// #0
  401d18:	aa0003e1 	mov	x1, x0
  401d1c:	d2800020 	mov	x0, #0x1                   	// #1
  401d20:	97fffa56 	bl	400678 <msyscall>
  401d24:	a8c27bfd 	ldp	x29, x30, [sp], #32
  401d28:	d65f03c0 	ret

0000000000401d2c <syscall_getenvid>:
syscall_getenvid():
  401d2c:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
  401d30:	910003fd 	mov	x29, sp
  401d34:	d2800005 	mov	x5, #0x0                   	// #0
  401d38:	d2800004 	mov	x4, #0x0                   	// #0
  401d3c:	d2800003 	mov	x3, #0x0                   	// #0
  401d40:	d2800002 	mov	x2, #0x0                   	// #0
  401d44:	d2800001 	mov	x1, #0x0                   	// #0
  401d48:	d2800040 	mov	x0, #0x2                   	// #2
  401d4c:	97fffa4b 	bl	400678 <msyscall>
  401d50:	a8c17bfd 	ldp	x29, x30, [sp], #16
  401d54:	d65f03c0 	ret

0000000000401d58 <syscall_yield>:
syscall_yield():
  401d58:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
  401d5c:	910003fd 	mov	x29, sp
  401d60:	d2800005 	mov	x5, #0x0                   	// #0
  401d64:	d2800004 	mov	x4, #0x0                   	// #0
  401d68:	d2800003 	mov	x3, #0x0                   	// #0
  401d6c:	d2800002 	mov	x2, #0x0                   	// #0
  401d70:	d2800001 	mov	x1, #0x0                   	// #0
  401d74:	d2800060 	mov	x0, #0x3                   	// #3
  401d78:	97fffa40 	bl	400678 <msyscall>
  401d7c:	d503201f 	nop
  401d80:	a8c17bfd 	ldp	x29, x30, [sp], #16
  401d84:	d65f03c0 	ret

0000000000401d88 <syscall_env_destroy>:
syscall_env_destroy():
  401d88:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
  401d8c:	910003fd 	mov	x29, sp
  401d90:	b9001fe0 	str	w0, [sp, #28]
  401d94:	b9401fe0 	ldr	w0, [sp, #28]
  401d98:	d2800005 	mov	x5, #0x0                   	// #0
  401d9c:	d2800004 	mov	x4, #0x0                   	// #0
  401da0:	d2800003 	mov	x3, #0x0                   	// #0
  401da4:	d2800002 	mov	x2, #0x0                   	// #0
  401da8:	aa0003e1 	mov	x1, x0
  401dac:	d2800080 	mov	x0, #0x4                   	// #4
  401db0:	97fffa32 	bl	400678 <msyscall>
  401db4:	d503201f 	nop
  401db8:	a8c27bfd 	ldp	x29, x30, [sp], #32
  401dbc:	d65f03c0 	ret

0000000000401dc0 <syscall_set_pgfault_handler>:
syscall_set_pgfault_handler():
  401dc0:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
  401dc4:	910003fd 	mov	x29, sp
  401dc8:	b9002fe0 	str	w0, [sp, #44]
  401dcc:	f90013e1 	str	x1, [sp, #32]
  401dd0:	f9000fe2 	str	x2, [sp, #24]
  401dd4:	b9402fe0 	ldr	w0, [sp, #44]
  401dd8:	d2800005 	mov	x5, #0x0                   	// #0
  401ddc:	d2800004 	mov	x4, #0x0                   	// #0
  401de0:	f9400fe3 	ldr	x3, [sp, #24]
  401de4:	f94013e2 	ldr	x2, [sp, #32]
  401de8:	aa0003e1 	mov	x1, x0
  401dec:	d28000a0 	mov	x0, #0x5                   	// #5
  401df0:	97fffa22 	bl	400678 <msyscall>
  401df4:	a8c37bfd 	ldp	x29, x30, [sp], #48
  401df8:	d65f03c0 	ret

0000000000401dfc <syscall_mem_alloc>:
syscall_mem_alloc():
  401dfc:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
  401e00:	910003fd 	mov	x29, sp
  401e04:	b9002fe0 	str	w0, [sp, #44]
  401e08:	f90013e1 	str	x1, [sp, #32]
  401e0c:	f9000fe2 	str	x2, [sp, #24]
  401e10:	b9402fe0 	ldr	w0, [sp, #44]
  401e14:	d2800005 	mov	x5, #0x0                   	// #0
  401e18:	d2800004 	mov	x4, #0x0                   	// #0
  401e1c:	f9400fe3 	ldr	x3, [sp, #24]
  401e20:	f94013e2 	ldr	x2, [sp, #32]
  401e24:	aa0003e1 	mov	x1, x0
  401e28:	d28000c0 	mov	x0, #0x6                   	// #6
  401e2c:	97fffa13 	bl	400678 <msyscall>
  401e30:	a8c37bfd 	ldp	x29, x30, [sp], #48
  401e34:	d65f03c0 	ret

0000000000401e38 <syscall_mem_map>:
syscall_mem_map():
  401e38:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
  401e3c:	910003fd 	mov	x29, sp
  401e40:	b9002fe0 	str	w0, [sp, #44]
  401e44:	f90013e1 	str	x1, [sp, #32]
  401e48:	b9002be2 	str	w2, [sp, #40]
  401e4c:	f9000fe3 	str	x3, [sp, #24]
  401e50:	f9000be4 	str	x4, [sp, #16]
  401e54:	b9402fe0 	ldr	w0, [sp, #44]
  401e58:	b9402be1 	ldr	w1, [sp, #40]
  401e5c:	f9400be5 	ldr	x5, [sp, #16]
  401e60:	f9400fe4 	ldr	x4, [sp, #24]
  401e64:	aa0103e3 	mov	x3, x1
  401e68:	f94013e2 	ldr	x2, [sp, #32]
  401e6c:	aa0003e1 	mov	x1, x0
  401e70:	d28000e0 	mov	x0, #0x7                   	// #7
  401e74:	97fffa01 	bl	400678 <msyscall>
  401e78:	a8c37bfd 	ldp	x29, x30, [sp], #48
  401e7c:	d65f03c0 	ret

0000000000401e80 <syscall_mem_unmap>:
syscall_mem_unmap():
  401e80:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
  401e84:	910003fd 	mov	x29, sp
  401e88:	b9001fe0 	str	w0, [sp, #28]
  401e8c:	f9000be1 	str	x1, [sp, #16]
  401e90:	b9401fe0 	ldr	w0, [sp, #28]
  401e94:	d2800005 	mov	x5, #0x0                   	// #0
  401e98:	d2800004 	mov	x4, #0x0                   	// #0
  401e9c:	d2800003 	mov	x3, #0x0                   	// #0
  401ea0:	f9400be2 	ldr	x2, [sp, #16]
  401ea4:	aa0003e1 	mov	x1, x0
  401ea8:	d2800100 	mov	x0, #0x8                   	// #8
  401eac:	97fff9f3 	bl	400678 <msyscall>
  401eb0:	a8c27bfd 	ldp	x29, x30, [sp], #32
  401eb4:	d65f03c0 	ret

0000000000401eb8 <syscall_env_alloc>:
syscall_env_alloc():
  401eb8:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
  401ebc:	910003fd 	mov	x29, sp
  401ec0:	d2800005 	mov	x5, #0x0                   	// #0
  401ec4:	d2800004 	mov	x4, #0x0                   	// #0
  401ec8:	d2800003 	mov	x3, #0x0                   	// #0
  401ecc:	d2800002 	mov	x2, #0x0                   	// #0
  401ed0:	d2800001 	mov	x1, #0x0                   	// #0
  401ed4:	d2800120 	mov	x0, #0x9                   	// #9
  401ed8:	97fff9e8 	bl	400678 <msyscall>
  401edc:	a8c17bfd 	ldp	x29, x30, [sp], #16
  401ee0:	d65f03c0 	ret

0000000000401ee4 <syscall_set_env_status>:
syscall_set_env_status():
  401ee4:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
  401ee8:	910003fd 	mov	x29, sp
  401eec:	b9001fe0 	str	w0, [sp, #28]
  401ef0:	b9001be1 	str	w1, [sp, #24]
  401ef4:	b9401fe0 	ldr	w0, [sp, #28]
  401ef8:	b9401be1 	ldr	w1, [sp, #24]
  401efc:	d2800005 	mov	x5, #0x0                   	// #0
  401f00:	d2800004 	mov	x4, #0x0                   	// #0
  401f04:	d2800003 	mov	x3, #0x0                   	// #0
  401f08:	aa0103e2 	mov	x2, x1
  401f0c:	aa0003e1 	mov	x1, x0
  401f10:	d2800140 	mov	x0, #0xa                   	// #10
  401f14:	97fff9d9 	bl	400678 <msyscall>
  401f18:	a8c27bfd 	ldp	x29, x30, [sp], #32
  401f1c:	d65f03c0 	ret

0000000000401f20 <syscall_set_trapframe>:
syscall_set_trapframe():
  401f20:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
  401f24:	910003fd 	mov	x29, sp
  401f28:	b9001fe0 	str	w0, [sp, #28]
  401f2c:	f9000be1 	str	x1, [sp, #16]
  401f30:	b9401fe0 	ldr	w0, [sp, #28]
  401f34:	f9400be1 	ldr	x1, [sp, #16]
  401f38:	d2800005 	mov	x5, #0x0                   	// #0
  401f3c:	d2800004 	mov	x4, #0x0                   	// #0
  401f40:	d2800003 	mov	x3, #0x0                   	// #0
  401f44:	aa0103e2 	mov	x2, x1
  401f48:	aa0003e1 	mov	x1, x0
  401f4c:	d2800160 	mov	x0, #0xb                   	// #11
  401f50:	97fff9ca 	bl	400678 <msyscall>
  401f54:	a8c27bfd 	ldp	x29, x30, [sp], #32
  401f58:	d65f03c0 	ret

0000000000401f5c <syscall_panic>:
syscall_panic():
  401f5c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
  401f60:	910003fd 	mov	x29, sp
  401f64:	f9000fe0 	str	x0, [sp, #24]
  401f68:	f9400fe0 	ldr	x0, [sp, #24]
  401f6c:	d2800005 	mov	x5, #0x0                   	// #0
  401f70:	d2800004 	mov	x4, #0x0                   	// #0
  401f74:	d2800003 	mov	x3, #0x0                   	// #0
  401f78:	d2800002 	mov	x2, #0x0                   	// #0
  401f7c:	aa0003e1 	mov	x1, x0
  401f80:	d2800180 	mov	x0, #0xc                   	// #12
  401f84:	97fff9bd 	bl	400678 <msyscall>
  401f88:	d503201f 	nop
  401f8c:	a8c27bfd 	ldp	x29, x30, [sp], #32
  401f90:	d65f03c0 	ret

0000000000401f94 <syscall_ipc_can_send>:
syscall_ipc_can_send():
  401f94:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
  401f98:	910003fd 	mov	x29, sp
  401f9c:	b9002fe0 	str	w0, [sp, #44]
  401fa0:	b9002be1 	str	w1, [sp, #40]
  401fa4:	f90013e2 	str	x2, [sp, #32]
  401fa8:	f9000fe3 	str	x3, [sp, #24]
  401fac:	b9402fe0 	ldr	w0, [sp, #44]
  401fb0:	b9402be1 	ldr	w1, [sp, #40]
  401fb4:	d2800005 	mov	x5, #0x0                   	// #0
  401fb8:	f9400fe4 	ldr	x4, [sp, #24]
  401fbc:	f94013e3 	ldr	x3, [sp, #32]
  401fc0:	aa0103e2 	mov	x2, x1
  401fc4:	aa0003e1 	mov	x1, x0
  401fc8:	d28001a0 	mov	x0, #0xd                   	// #13
  401fcc:	97fff9ab 	bl	400678 <msyscall>
  401fd0:	a8c37bfd 	ldp	x29, x30, [sp], #48
  401fd4:	d65f03c0 	ret

0000000000401fd8 <syscall_ipc_recv>:
syscall_ipc_recv():
  401fd8:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
  401fdc:	910003fd 	mov	x29, sp
  401fe0:	f9000fe0 	str	x0, [sp, #24]
  401fe4:	d2800005 	mov	x5, #0x0                   	// #0
  401fe8:	d2800004 	mov	x4, #0x0                   	// #0
  401fec:	d2800003 	mov	x3, #0x0                   	// #0
  401ff0:	d2800002 	mov	x2, #0x0                   	// #0
  401ff4:	f9400fe1 	ldr	x1, [sp, #24]
  401ff8:	d28001c0 	mov	x0, #0xe                   	// #14
  401ffc:	97fff99f 	bl	400678 <msyscall>
  402000:	d503201f 	nop
  402004:	a8c27bfd 	ldp	x29, x30, [sp], #32
  402008:	d65f03c0 	ret

000000000040200c <syscall_cgetc>:
syscall_cgetc():
  40200c:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
  402010:	910003fd 	mov	x29, sp
  402014:	d2800005 	mov	x5, #0x0                   	// #0
  402018:	d2800004 	mov	x4, #0x0                   	// #0
  40201c:	d2800003 	mov	x3, #0x0                   	// #0
  402020:	d2800002 	mov	x2, #0x0                   	// #0
  402024:	d2800001 	mov	x1, #0x0                   	// #0
  402028:	d28001e0 	mov	x0, #0xf                   	// #15
  40202c:	97fff993 	bl	400678 <msyscall>
  402030:	a8c17bfd 	ldp	x29, x30, [sp], #16
  402034:	d65f03c0 	ret

Disassembly of section .data:

0000000000402038 <vpt>:
  402038:	00000000 	.inst	0x00000000 ; undefined
  40203c:	00000040 	.inst	0x00000040 ; undefined

0000000000402040 <vmd>:
  402040:	20000000 	.inst	0x20000000 ; undefined
  402044:	00000040 	.inst	0x00000040 ; undefined

0000000000402048 <vud>:
  402048:	20100000 	.inst	0x20100000 ; undefined
  40204c:	00000040 	.inst	0x00000040 ; undefined

0000000000402050 <pages>:
  402050:	c0000000 	.inst	0xc0000000 ; undefined
  402054:	0000003f 	.inst	0x0000003f ; undefined

0000000000402058 <envs>:
  402058:	80000000 	.inst	0x80000000 ; undefined
  40205c:	0000003f 	.inst	0x0000003f ; undefined
  402060:	756f6c61 	.inst	0x756f6c61 ; undefined
  402064:	0a2e6168 	bic	w8, w11, w14, lsl #24
	...
  402070:	61666770 	.inst	0x61666770 ; undefined
  402074:	20746c75 	.inst	0x20746c75 ; undefined
  402078:	3a727265 	.inst	0x3a727265 ; undefined
  40207c:	574f4320 	.inst	0x574f4320 ; undefined
  402080:	746f6e20 	.inst	0x746f6e20 ; undefined
  402084:	756f6620 	.inst	0x756f6620 ; undefined
  402088:	0000646e 	.inst	0x0000646e ; undefined
  40208c:	00000000 	.inst	0x00000000 ; undefined
  402090:	6b726f66 	.inst	0x6b726f66 ; undefined
  402094:	0000632e 	.inst	0x0000632e ; undefined
  402098:	6e6e6163 	rsubhn2	v3.8h, v11.4s, v14.4s
  40209c:	7320746f 	.inst	0x7320746f ; undefined
  4020a0:	70207465 	adr	x5, 442f2f <end+0x40dff>
  4020a4:	75616667 	.inst	0x75616667 ; undefined
  4020a8:	6820746c 	.inst	0x6820746c ; undefined
  4020ac:	6c646e61 	ldnp	d1, d27, [x19, #-448]
  4020b0:	000a7265 	.inst	0x000a7265 ; undefined
  4020b4:	00000000 	.inst	0x00000000 ; undefined
  4020b8:	6f727265 	fcmla	v5.8h, v19.8h, v18.h[1], #270
  4020bc:	6e692072 	usubl2	v18.4s, v3.8h, v9.8h
  4020c0:	63706920 	.inst	0x63706920 ; undefined
  4020c4:	6e65735f 	uabdl2	v31.4s, v26.8h, v5.8h
  4020c8:	25203a64 	.inst	0x25203a64 ; undefined
  4020cc:	00000064 	.inst	0x00000064 ; undefined
  4020d0:	2e637069 	uabdl	v9.4s, v3.4h, v3.4h
  4020d4:	00000063 	.inst	0x00000063 ; undefined

00000000004020d8 <user_theFatalMsg>:
  4020d8:	61746166 	.inst	0x61746166 ; undefined
  4020dc:	7265206c 	.inst	0x7265206c ; undefined
  4020e0:	20726f72 	.inst	0x20726f72 ; undefined
  4020e4:	75206e69 	.inst	0x75206e69 ; undefined
  4020e8:	5f726573 	.inst	0x5f726573 ; undefined
  4020ec:	505f706c 	adr	x12, 4c0efa <end+0xbedca>
  4020f0:	746e6972 	.inst	0x746e6972 ; undefined
  4020f4:	00000021 	.inst	0x00000021 ; undefined
	...
  402100:	696e6170 	ldpsw	x16, x24, [x11, #-144]
  402104:	74612063 	.inst	0x74612063 ; undefined
  402108:	3a732520 	.inst	0x3a732520 ; undefined
  40210c:	203a6425 	.inst	0x203a6425 ; undefined
	...
  402118:	Address 0x0000000000402118 is out of bounds.


Disassembly of section .bss:

0000000000402120 <__pgfault_handler>:
	...

0000000000402128 <env>:
	...
