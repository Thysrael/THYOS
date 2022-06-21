
test_sys.elf:     file format elf64-littleaarch64
test_sys.elf


Disassembly of section .text.boot:

0000000000400000 <_start>:
_start():
  400000:	f94003e0 	ldr	x0, [sp]
  400004:	f9400be1 	ldr	x1, [sp, #16]
  400008:	9400017a 	bl	4005f0 <libmain>

Disassembly of section .text:

000000000040000c <umain>:
umain():
  40000c:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
  400010:	910003fd 	mov	x29, sp
  400014:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  400018:	91018000 	add	x0, x0, #0x60
  40001c:	9400065e 	bl	401994 <writef>
  400020:	d503201f 	nop
  400024:	a8c17bfd 	ldp	x29, x30, [sp], #16
  400028:	d65f03c0 	ret

000000000040002c <__asm_pgfault_handler>:
__asm_pgfault_handler():
  40002c:	f9408be0 	ldr	x0, [sp, #272]
  400030:	58010790 	ldr	x16, 402120 <__pgfault_handler>
  400034:	d63f0200 	blr	x16
  400038:	a94007e0 	ldp	x0, x1, [sp]
  40003c:	a9410fe2 	ldp	x2, x3, [sp, #16]
  400040:	a94217e4 	ldp	x4, x5, [sp, #32]
  400044:	a9431fe6 	ldp	x6, x7, [sp, #48]
  400048:	a94427e8 	ldp	x8, x9, [sp, #64]
  40004c:	a9452fea 	ldp	x10, x11, [sp, #80]
  400050:	a94637ec 	ldp	x12, x13, [sp, #96]
  400054:	a9473fee 	ldp	x14, x15, [sp, #112]
  400058:	a94847f0 	ldp	x16, x17, [sp, #128]
  40005c:	a9494ff2 	ldp	x18, x19, [sp, #144]
  400060:	a94a57f4 	ldp	x20, x21, [sp, #160]
  400064:	a94b5ff6 	ldp	x22, x23, [sp, #176]
  400068:	a94c67f8 	ldp	x24, x25, [sp, #192]
  40006c:	a94d6ffa 	ldp	x26, x27, [sp, #208]
  400070:	a94e77fc 	ldp	x28, x29, [sp, #224]
  400074:	f9407bfe 	ldr	x30, [sp, #240]
  400078:	f94087f1 	ldr	x17, [sp, #264]
  40007c:	f9407ff0 	ldr	x16, [sp, #248]
  400080:	d5184110 	msr	sp_el0, x16
  400084:	d61f0220 	br	x17

0000000000400088 <pgfault>:
pgfault():
  400088:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
  40008c:	910003fd 	mov	x29, sp
  400090:	f9000fe0 	str	x0, [sp, #24]
  400094:	b27363e0 	mov	x0, #0x3fffffe000          	// #274877898752
  400098:	f2bfefe0 	movk	x0, #0xff7f, lsl #16
  40009c:	f90017e0 	str	x0, [sp, #40]
  4000a0:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  4000a4:	9100e000 	add	x0, x0, #0x38
  4000a8:	f9400001 	ldr	x1, [x0]
  4000ac:	f9400fe0 	ldr	x0, [sp, #24]
  4000b0:	d34cfc00 	lsr	x0, x0, #12
  4000b4:	d37df000 	lsl	x0, x0, #3
  4000b8:	8b000020 	add	x0, x1, x0
  4000bc:	f9400000 	ldr	x0, [x0]
  4000c0:	92402c00 	and	x0, x0, #0xfff
  4000c4:	f90013e0 	str	x0, [sp, #32]
  4000c8:	f94013e0 	ldr	x0, [sp, #32]
  4000cc:	92790000 	and	x0, x0, #0x80
  4000d0:	f100001f 	cmp	x0, #0x0
  4000d4:	540000e1 	b.ne	4000f0 <pgfault+0x68>  // b.any
  4000d8:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  4000dc:	9101c002 	add	x2, x0, #0x70
  4000e0:	52800361 	mov	w1, #0x1b                  	// #27
  4000e4:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  4000e8:	91024000 	add	x0, x0, #0x90
  4000ec:	94000656 	bl	401a44 <_user_panic>
  4000f0:	f94013e0 	ldr	x0, [sp, #32]
  4000f4:	d1020000 	sub	x0, x0, #0x80
  4000f8:	f90013e0 	str	x0, [sp, #32]
  4000fc:	f94013e2 	ldr	x2, [sp, #32]
  400100:	f94017e1 	ldr	x1, [sp, #40]
  400104:	52800000 	mov	w0, #0x0                   	// #0
  400108:	9400073c 	bl	401df8 <syscall_mem_alloc>
  40010c:	f9400fe0 	ldr	x0, [sp, #24]
  400110:	9274cc00 	and	x0, x0, #0xfffffffffffff000
  400114:	aa0003e3 	mov	x3, x0
  400118:	f94017e0 	ldr	x0, [sp, #40]
  40011c:	52820002 	mov	w2, #0x1000                	// #4096
  400120:	aa0003e1 	mov	x1, x0
  400124:	aa0303e0 	mov	x0, x3
  400128:	940000f1 	bl	4004ec <user_bcopy>
  40012c:	f94013e4 	ldr	x4, [sp, #32]
  400130:	f9400fe3 	ldr	x3, [sp, #24]
  400134:	52800002 	mov	w2, #0x0                   	// #0
  400138:	f94017e1 	ldr	x1, [sp, #40]
  40013c:	52800000 	mov	w0, #0x0                   	// #0
  400140:	9400073d 	bl	401e34 <syscall_mem_map>
  400144:	f94017e1 	ldr	x1, [sp, #40]
  400148:	52800000 	mov	w0, #0x0                   	// #0
  40014c:	9400074c 	bl	401e7c <syscall_mem_unmap>
  400150:	d503201f 	nop
  400154:	a8c37bfd 	ldp	x29, x30, [sp], #48
  400158:	d65f03c0 	ret

000000000040015c <duppage>:
duppage():
  40015c:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
  400160:	910003fd 	mov	x29, sp
  400164:	b9001fe0 	str	w0, [sp, #28]
  400168:	f9000be1 	str	x1, [sp, #16]
  40016c:	f9400be0 	ldr	x0, [sp, #16]
  400170:	d374cc00 	lsl	x0, x0, #12
  400174:	f9001fe0 	str	x0, [sp, #56]
  400178:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  40017c:	9100e000 	add	x0, x0, #0x38
  400180:	f9400001 	ldr	x1, [x0]
  400184:	f9400be0 	ldr	x0, [sp, #16]
  400188:	d37df000 	lsl	x0, x0, #3
  40018c:	8b000020 	add	x0, x1, x0
  400190:	f9400000 	ldr	x0, [x0]
  400194:	92402c00 	and	x0, x0, #0xfff
  400198:	f9001be0 	str	x0, [sp, #48]
  40019c:	b9002fff 	str	wzr, [sp, #44]
  4001a0:	f9401be4 	ldr	x4, [sp, #48]
  4001a4:	f9401fe3 	ldr	x3, [sp, #56]
  4001a8:	b9401fe2 	ldr	w2, [sp, #28]
  4001ac:	f9401fe1 	ldr	x1, [sp, #56]
  4001b0:	52800000 	mov	w0, #0x0                   	// #0
  4001b4:	94000720 	bl	401e34 <syscall_mem_map>
  4001b8:	b9402fe0 	ldr	w0, [sp, #44]
  4001bc:	7100001f 	cmp	w0, #0x0
  4001c0:	540000e0 	b.eq	4001dc <duppage+0x80>  // b.none
  4001c4:	f9401be4 	ldr	x4, [sp, #48]
  4001c8:	f9401fe3 	ldr	x3, [sp, #56]
  4001cc:	52800002 	mov	w2, #0x0                   	// #0
  4001d0:	f9401fe1 	ldr	x1, [sp, #56]
  4001d4:	52800000 	mov	w0, #0x0                   	// #0
  4001d8:	94000717 	bl	401e34 <syscall_mem_map>
  4001dc:	d503201f 	nop
  4001e0:	a8c47bfd 	ldp	x29, x30, [sp], #64
  4001e4:	d65f03c0 	ret

00000000004001e8 <fork>:
fork():
  4001e8:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
  4001ec:	910003fd 	mov	x29, sp
  4001f0:	f9000bf3 	str	x19, [sp, #16]
  4001f4:	90000000 	adrp	x0, 400000 <_start>
  4001f8:	91022000 	add	x0, x0, #0x88
  4001fc:	94000057 	bl	400358 <set_pgfault_handler>
  400200:	9400072d 	bl	401eb4 <syscall_env_alloc>
  400204:	b90027e0 	str	w0, [sp, #36]
  400208:	b94027e0 	ldr	w0, [sp, #36]
  40020c:	7100001f 	cmp	w0, #0x0
  400210:	54000261 	b.ne	40025c <fork+0x74>  // b.any
  400214:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  400218:	91016000 	add	x0, x0, #0x58
  40021c:	f9400013 	ldr	x19, [x0]
  400220:	940006c2 	bl	401d28 <syscall_getenvid>
  400224:	2a0003e0 	mov	w0, w0
  400228:	92402401 	and	x1, x0, #0x3ff
  40022c:	aa0103e0 	mov	x0, x1
  400230:	d37ff800 	lsl	x0, x0, #1
  400234:	8b010000 	add	x0, x0, x1
  400238:	d37cec01 	lsl	x1, x0, #4
  40023c:	8b010000 	add	x0, x0, x1
  400240:	d37df000 	lsl	x0, x0, #3
  400244:	8b000261 	add	x1, x19, x0
  400248:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  40024c:	9104a000 	add	x0, x0, #0x128
  400250:	f9000001 	str	x1, [x0]
  400254:	52800000 	mov	w0, #0x0                   	// #0
  400258:	1400003d 	b	40034c <fork+0x164>
  40025c:	f90017ff 	str	xzr, [sp, #40]
  400260:	14000027 	b	4002fc <fork+0x114>
  400264:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  400268:	91012000 	add	x0, x0, #0x48
  40026c:	f9400001 	ldr	x1, [x0]
  400270:	f94017e0 	ldr	x0, [sp, #40]
  400274:	d352fc00 	lsr	x0, x0, #18
  400278:	d37df000 	lsl	x0, x0, #3
  40027c:	8b000020 	add	x0, x1, x0
  400280:	f9400000 	ldr	x0, [x0]
  400284:	92400000 	and	x0, x0, #0x1
  400288:	f100001f 	cmp	x0, #0x0
  40028c:	54000320 	b.eq	4002f0 <fork+0x108>  // b.none
  400290:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  400294:	91010000 	add	x0, x0, #0x40
  400298:	f9400001 	ldr	x1, [x0]
  40029c:	f94017e0 	ldr	x0, [sp, #40]
  4002a0:	d349fc00 	lsr	x0, x0, #9
  4002a4:	d37df000 	lsl	x0, x0, #3
  4002a8:	8b000020 	add	x0, x1, x0
  4002ac:	f9400000 	ldr	x0, [x0]
  4002b0:	92400000 	and	x0, x0, #0x1
  4002b4:	f100001f 	cmp	x0, #0x0
  4002b8:	540001c0 	b.eq	4002f0 <fork+0x108>  // b.none
  4002bc:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  4002c0:	9100e000 	add	x0, x0, #0x38
  4002c4:	f9400001 	ldr	x1, [x0]
  4002c8:	f94017e0 	ldr	x0, [sp, #40]
  4002cc:	d37df000 	lsl	x0, x0, #3
  4002d0:	8b000020 	add	x0, x1, x0
  4002d4:	f9400000 	ldr	x0, [x0]
  4002d8:	92400000 	and	x0, x0, #0x1
  4002dc:	f100001f 	cmp	x0, #0x0
  4002e0:	54000080 	b.eq	4002f0 <fork+0x108>  // b.none
  4002e4:	f94017e1 	ldr	x1, [sp, #40]
  4002e8:	b94027e0 	ldr	w0, [sp, #36]
  4002ec:	97ffff9c 	bl	40015c <duppage>
  4002f0:	f94017e0 	ldr	x0, [sp, #40]
  4002f4:	91000400 	add	x0, x0, #0x1
  4002f8:	f90017e0 	str	x0, [sp, #40]
  4002fc:	f94017e1 	ldr	x1, [sp, #40]
  400300:	d29effa0 	mov	x0, #0xf7fd                	// #63485
  400304:	f2a07fe0 	movk	x0, #0x3ff, lsl #16
  400308:	eb00003f 	cmp	x1, x0
  40030c:	54fffac9 	b.ls	400264 <fork+0x7c>  // b.plast
  400310:	d280e822 	mov	x2, #0x741                 	// #1857
  400314:	b27467e1 	mov	x1, #0x3ffffff000          	// #274877902848
  400318:	f2bfefe1 	movk	x1, #0xff7f, lsl #16
  40031c:	b94027e0 	ldr	w0, [sp, #36]
  400320:	940006b6 	bl	401df8 <syscall_mem_alloc>
  400324:	90000000 	adrp	x0, 400000 <_start>
  400328:	9100b000 	add	x0, x0, #0x2c
  40032c:	b2693be2 	mov	x2, #0x3fff800000          	// #274869518336
  400330:	aa0003e1 	mov	x1, x0
  400334:	b94027e0 	ldr	w0, [sp, #36]
  400338:	940006a1 	bl	401dbc <syscall_set_pgfault_handler>
  40033c:	52800021 	mov	w1, #0x1                   	// #1
  400340:	b94027e0 	ldr	w0, [sp, #36]
  400344:	940006e7 	bl	401ee0 <syscall_set_env_status>
  400348:	b94027e0 	ldr	w0, [sp, #36]
  40034c:	f9400bf3 	ldr	x19, [sp, #16]
  400350:	a8c37bfd 	ldp	x29, x30, [sp], #48
  400354:	d65f03c0 	ret

0000000000400358 <set_pgfault_handler>:
set_pgfault_handler():
  400358:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
  40035c:	910003fd 	mov	x29, sp
  400360:	f9000fe0 	str	x0, [sp, #24]
  400364:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  400368:	91048000 	add	x0, x0, #0x120
  40036c:	f9400000 	ldr	x0, [x0]
  400370:	f100001f 	cmp	x0, #0x0
  400374:	54000281 	b.ne	4003c4 <set_pgfault_handler+0x6c>  // b.any
  400378:	d280e822 	mov	x2, #0x741                 	// #1857
  40037c:	b27467e1 	mov	x1, #0x3ffffff000          	// #274877902848
  400380:	f2bfefe1 	movk	x1, #0xff7f, lsl #16
  400384:	52800000 	mov	w0, #0x0                   	// #0
  400388:	9400069c 	bl	401df8 <syscall_mem_alloc>
  40038c:	7100001f 	cmp	w0, #0x0
  400390:	5400012b 	b.lt	4003b4 <set_pgfault_handler+0x5c>  // b.tstop
  400394:	90000000 	adrp	x0, 400000 <_start>
  400398:	9100b000 	add	x0, x0, #0x2c
  40039c:	b2693be2 	mov	x2, #0x3fff800000          	// #274869518336
  4003a0:	aa0003e1 	mov	x1, x0
  4003a4:	52800000 	mov	w0, #0x0                   	// #0
  4003a8:	94000685 	bl	401dbc <syscall_set_pgfault_handler>
  4003ac:	7100001f 	cmp	w0, #0x0
  4003b0:	540000aa 	b.ge	4003c4 <set_pgfault_handler+0x6c>  // b.tcont
  4003b4:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  4003b8:	91026000 	add	x0, x0, #0x98
  4003bc:	94000576 	bl	401994 <writef>
  4003c0:	14000005 	b	4003d4 <set_pgfault_handler+0x7c>
  4003c4:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  4003c8:	91048000 	add	x0, x0, #0x120
  4003cc:	f9400fe1 	ldr	x1, [sp, #24]
  4003d0:	f9000001 	str	x1, [x0]
  4003d4:	a8c27bfd 	ldp	x29, x30, [sp], #32
  4003d8:	d65f03c0 	ret

00000000004003dc <ipc_send>:
ipc_send():
  4003dc:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
  4003e0:	910003fd 	mov	x29, sp
  4003e4:	b9002fe0 	str	w0, [sp, #44]
  4003e8:	b9002be1 	str	w1, [sp, #40]
  4003ec:	f90013e2 	str	x2, [sp, #32]
  4003f0:	f9000fe3 	str	x3, [sp, #24]
  4003f4:	14000002 	b	4003fc <ipc_send+0x20>
  4003f8:	94000657 	bl	401d54 <syscall_yield>
  4003fc:	f9400fe3 	ldr	x3, [sp, #24]
  400400:	f94013e2 	ldr	x2, [sp, #32]
  400404:	b9402be1 	ldr	w1, [sp, #40]
  400408:	b9402fe0 	ldr	w0, [sp, #44]
  40040c:	940006e1 	bl	401f90 <syscall_ipc_can_send>
  400410:	b9003fe0 	str	w0, [sp, #60]
  400414:	b9403fe0 	ldr	w0, [sp, #60]
  400418:	3100181f 	cmn	w0, #0x6
  40041c:	54fffee0 	b.eq	4003f8 <ipc_send+0x1c>  // b.none
  400420:	b9403fe0 	ldr	w0, [sp, #60]
  400424:	7100001f 	cmp	w0, #0x0
  400428:	54000100 	b.eq	400448 <ipc_send+0x6c>  // b.none
  40042c:	b9403fe3 	ldr	w3, [sp, #60]
  400430:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  400434:	9102e002 	add	x2, x0, #0xb8
  400438:	528003c1 	mov	w1, #0x1e                  	// #30
  40043c:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  400440:	91034000 	add	x0, x0, #0xd0
  400444:	94000580 	bl	401a44 <_user_panic>
  400448:	d503201f 	nop
  40044c:	a8c47bfd 	ldp	x29, x30, [sp], #64
  400450:	d65f03c0 	ret

0000000000400454 <ipc_recv>:
ipc_recv():
  400454:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
  400458:	910003fd 	mov	x29, sp
  40045c:	f90017e0 	str	x0, [sp, #40]
  400460:	f90013e1 	str	x1, [sp, #32]
  400464:	f9000fe2 	str	x2, [sp, #24]
  400468:	f94013e0 	ldr	x0, [sp, #32]
  40046c:	940006da 	bl	401fd4 <syscall_ipc_recv>
  400470:	f94017e0 	ldr	x0, [sp, #40]
  400474:	f100001f 	cmp	x0, #0x0
  400478:	540000e0 	b.eq	400494 <ipc_recv+0x40>  // b.none
  40047c:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  400480:	9104a000 	add	x0, x0, #0x128
  400484:	f9400000 	ldr	x0, [x0]
  400488:	b9416801 	ldr	w1, [x0, #360]
  40048c:	f94017e0 	ldr	x0, [sp, #40]
  400490:	b9000001 	str	w1, [x0]
  400494:	f9400fe0 	ldr	x0, [sp, #24]
  400498:	f100001f 	cmp	x0, #0x0
  40049c:	540000e0 	b.eq	4004b8 <ipc_recv+0x64>  // b.none
  4004a0:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  4004a4:	9104a000 	add	x0, x0, #0x128
  4004a8:	f9400000 	ldr	x0, [x0]
  4004ac:	f940bc01 	ldr	x1, [x0, #376]
  4004b0:	f9400fe0 	ldr	x0, [sp, #24]
  4004b4:	f9000001 	str	x1, [x0]
  4004b8:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  4004bc:	9104a000 	add	x0, x0, #0x128
  4004c0:	f9400000 	ldr	x0, [x0]
  4004c4:	b9416400 	ldr	w0, [x0, #356]
  4004c8:	a8c37bfd 	ldp	x29, x30, [sp], #48
  4004cc:	d65f03c0 	ret

00000000004004d0 <exit>:
exit():
  4004d0:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
  4004d4:	910003fd 	mov	x29, sp
  4004d8:	52800000 	mov	w0, #0x0                   	// #0
  4004dc:	9400062a 	bl	401d84 <syscall_env_destroy>
  4004e0:	d503201f 	nop
  4004e4:	a8c17bfd 	ldp	x29, x30, [sp], #16
  4004e8:	d65f03c0 	ret

00000000004004ec <user_bcopy>:
user_bcopy():
  4004ec:	d100c3ff 	sub	sp, sp, #0x30
  4004f0:	f9000fe0 	str	x0, [sp, #24]
  4004f4:	f9000be1 	str	x1, [sp, #16]
  4004f8:	b9000fe2 	str	w2, [sp, #12]
  4004fc:	b9400fe0 	ldr	w0, [sp, #12]
  400500:	f9400be1 	ldr	x1, [sp, #16]
  400504:	8b000020 	add	x0, x1, x0
  400508:	f90017e0 	str	x0, [sp, #40]
  40050c:	1400000b 	b	400538 <user_bcopy+0x4c>
  400510:	f9400fe0 	ldr	x0, [sp, #24]
  400514:	b9400001 	ldr	w1, [x0]
  400518:	f9400be0 	ldr	x0, [sp, #16]
  40051c:	b9000001 	str	w1, [x0]
  400520:	f9400be0 	ldr	x0, [sp, #16]
  400524:	91001000 	add	x0, x0, #0x4
  400528:	f9000be0 	str	x0, [sp, #16]
  40052c:	f9400fe0 	ldr	x0, [sp, #24]
  400530:	91001000 	add	x0, x0, #0x4
  400534:	f9000fe0 	str	x0, [sp, #24]
  400538:	f9400be0 	ldr	x0, [sp, #16]
  40053c:	91000c00 	add	x0, x0, #0x3
  400540:	f94017e1 	ldr	x1, [sp, #40]
  400544:	eb00003f 	cmp	x1, x0
  400548:	54fffe48 	b.hi	400510 <user_bcopy+0x24>  // b.pmore
  40054c:	1400000b 	b	400578 <user_bcopy+0x8c>
  400550:	f9400fe0 	ldr	x0, [sp, #24]
  400554:	39400001 	ldrb	w1, [x0]
  400558:	f9400be0 	ldr	x0, [sp, #16]
  40055c:	39000001 	strb	w1, [x0]
  400560:	f9400be0 	ldr	x0, [sp, #16]
  400564:	91000400 	add	x0, x0, #0x1
  400568:	f9000be0 	str	x0, [sp, #16]
  40056c:	f9400fe0 	ldr	x0, [sp, #24]
  400570:	91000400 	add	x0, x0, #0x1
  400574:	f9000fe0 	str	x0, [sp, #24]
  400578:	f9400be1 	ldr	x1, [sp, #16]
  40057c:	f94017e0 	ldr	x0, [sp, #40]
  400580:	eb00003f 	cmp	x1, x0
  400584:	54fffe63 	b.cc	400550 <user_bcopy+0x64>  // b.lo, b.ul, b.last
  400588:	d503201f 	nop
  40058c:	d503201f 	nop
  400590:	9100c3ff 	add	sp, sp, #0x30
  400594:	d65f03c0 	ret

0000000000400598 <user_bzero>:
user_bzero():
  400598:	d10083ff 	sub	sp, sp, #0x20
  40059c:	f90007e0 	str	x0, [sp, #8]
  4005a0:	b90007e1 	str	w1, [sp, #4]
  4005a4:	f94007e0 	ldr	x0, [sp, #8]
  4005a8:	f9000fe0 	str	x0, [sp, #24]
  4005ac:	b94007e0 	ldr	w0, [sp, #4]
  4005b0:	b90017e0 	str	w0, [sp, #20]
  4005b4:	14000005 	b	4005c8 <user_bzero+0x30>
  4005b8:	f9400fe0 	ldr	x0, [sp, #24]
  4005bc:	91000401 	add	x1, x0, #0x1
  4005c0:	f9000fe1 	str	x1, [sp, #24]
  4005c4:	3900001f 	strb	wzr, [x0]
  4005c8:	b94017e0 	ldr	w0, [sp, #20]
  4005cc:	51000400 	sub	w0, w0, #0x1
  4005d0:	b90017e0 	str	w0, [sp, #20]
  4005d4:	b94017e0 	ldr	w0, [sp, #20]
  4005d8:	7100001f 	cmp	w0, #0x0
  4005dc:	54fffeea 	b.ge	4005b8 <user_bzero+0x20>  // b.tcont
  4005e0:	d503201f 	nop
  4005e4:	d503201f 	nop
  4005e8:	910083ff 	add	sp, sp, #0x20
  4005ec:	d65f03c0 	ret

00000000004005f0 <libmain>:
libmain():
  4005f0:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
  4005f4:	910003fd 	mov	x29, sp
  4005f8:	b9001fe0 	str	w0, [sp, #28]
  4005fc:	f9000be1 	str	x1, [sp, #16]
  400600:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  400604:	9104a000 	add	x0, x0, #0x128
  400608:	f900001f 	str	xzr, [x0]
  40060c:	940005c7 	bl	401d28 <syscall_getenvid>
  400610:	b9002fe0 	str	w0, [sp, #44]
  400614:	b9402fe0 	ldr	w0, [sp, #44]
  400618:	12002400 	and	w0, w0, #0x3ff
  40061c:	b9002fe0 	str	w0, [sp, #44]
  400620:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  400624:	91016000 	add	x0, x0, #0x58
  400628:	f9400002 	ldr	x2, [x0]
  40062c:	b9802fe1 	ldrsw	x1, [sp, #44]
  400630:	aa0103e0 	mov	x0, x1
  400634:	d37ff800 	lsl	x0, x0, #1
  400638:	8b010000 	add	x0, x0, x1
  40063c:	d37cec01 	lsl	x1, x0, #4
  400640:	8b010000 	add	x0, x0, x1
  400644:	d37df000 	lsl	x0, x0, #3
  400648:	8b000041 	add	x1, x2, x0
  40064c:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  400650:	9104a000 	add	x0, x0, #0x128
  400654:	f9000001 	str	x1, [x0]
  400658:	f9400be1 	ldr	x1, [sp, #16]
  40065c:	b9401fe0 	ldr	w0, [sp, #28]
  400660:	97fffe6b 	bl	40000c <umain>
  400664:	97ffff9b 	bl	4004d0 <exit>
  400668:	d503201f 	nop
  40066c:	a8c37bfd 	ldp	x29, x30, [sp], #48
  400670:	d65f03c0 	ret

0000000000400674 <msyscall>:
msyscall():
  400674:	d4000001 	svc	#0x0
  400678:	d65f03c0 	ret

000000000040067c <user_lp_Print>:
user_lp_Print():
  40067c:	d111c3ff 	sub	sp, sp, #0x470
  400680:	a9007bfd 	stp	x29, x30, [sp]
  400684:	910003fd 	mov	x29, sp
  400688:	f9000bf3 	str	x19, [sp, #16]
  40068c:	f9001fe0 	str	x0, [sp, #56]
  400690:	f9001be1 	str	x1, [sp, #48]
  400694:	f90017e2 	str	x2, [sp, #40]
  400698:	aa0303f3 	mov	x19, x3
  40069c:	f94017e0 	ldr	x0, [sp, #40]
  4006a0:	f90227e0 	str	x0, [sp, #1096]
  4006a4:	14000004 	b	4006b4 <user_lp_Print+0x38>
  4006a8:	f94017e0 	ldr	x0, [sp, #40]
  4006ac:	91000400 	add	x0, x0, #0x1
  4006b0:	f90017e0 	str	x0, [sp, #40]
  4006b4:	f94017e0 	ldr	x0, [sp, #40]
  4006b8:	39400000 	ldrb	w0, [x0]
  4006bc:	7100001f 	cmp	w0, #0x0
  4006c0:	540000a0 	b.eq	4006d4 <user_lp_Print+0x58>  // b.none
  4006c4:	f94017e0 	ldr	x0, [sp, #40]
  4006c8:	39400000 	ldrb	w0, [x0]
  4006cc:	7100941f 	cmp	w0, #0x25
  4006d0:	54fffec1 	b.ne	4006a8 <user_lp_Print+0x2c>  // b.any
  4006d4:	f94017e1 	ldr	x1, [sp, #40]
  4006d8:	f94227e0 	ldr	x0, [sp, #1096]
  4006dc:	cb000020 	sub	x0, x1, x0
  4006e0:	f100001f 	cmp	x0, #0x0
  4006e4:	540000cb 	b.lt	4006fc <user_lp_Print+0x80>  // b.tstop
  4006e8:	f94017e1 	ldr	x1, [sp, #40]
  4006ec:	f94227e0 	ldr	x0, [sp, #1096]
  4006f0:	cb000020 	sub	x0, x1, x0
  4006f4:	f10fa01f 	cmp	x0, #0x3e8
  4006f8:	5400010d 	b.le	400718 <user_lp_Print+0x9c>
  4006fc:	f9401fe3 	ldr	x3, [sp, #56]
  400700:	528003a2 	mov	w2, #0x1d                  	// #29
  400704:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  400708:	91036001 	add	x1, x0, #0xd8
  40070c:	f9401be0 	ldr	x0, [sp, #48]
  400710:	d63f0060 	blr	x3
  400714:	14000000 	b	400714 <user_lp_Print+0x98>
  400718:	f94017e1 	ldr	x1, [sp, #40]
  40071c:	f94227e0 	ldr	x0, [sp, #1096]
  400720:	cb000020 	sub	x0, x1, x0
  400724:	f9401fe3 	ldr	x3, [sp, #56]
  400728:	2a0003e2 	mov	w2, w0
  40072c:	f94227e1 	ldr	x1, [sp, #1096]
  400730:	f9401be0 	ldr	x0, [sp, #48]
  400734:	d63f0060 	blr	x3
  400738:	f94017e1 	ldr	x1, [sp, #40]
  40073c:	f94227e0 	ldr	x0, [sp, #1096]
  400740:	cb000020 	sub	x0, x1, x0
  400744:	aa0003e1 	mov	x1, x0
  400748:	f9401be0 	ldr	x0, [sp, #48]
  40074c:	8b010000 	add	x0, x0, x1
  400750:	f9001be0 	str	x0, [sp, #48]
  400754:	f94017e0 	ldr	x0, [sp, #40]
  400758:	39400000 	ldrb	w0, [x0]
  40075c:	7100001f 	cmp	w0, #0x0
  400760:	540061a0 	b.eq	401394 <user_lp_Print+0xd18>  // b.none
  400764:	f94017e0 	ldr	x0, [sp, #40]
  400768:	91000400 	add	x0, x0, #0x1
  40076c:	f90017e0 	str	x0, [sp, #40]
  400770:	f94017e0 	ldr	x0, [sp, #40]
  400774:	39400000 	ldrb	w0, [x0]
  400778:	7101b01f 	cmp	w0, #0x6c
  40077c:	540000e1 	b.ne	400798 <user_lp_Print+0x11c>  // b.any
  400780:	52800020 	mov	w0, #0x1                   	// #1
  400784:	b90467e0 	str	w0, [sp, #1124]
  400788:	f94017e0 	ldr	x0, [sp, #40]
  40078c:	91000400 	add	x0, x0, #0x1
  400790:	f90017e0 	str	x0, [sp, #40]
  400794:	14000002 	b	40079c <user_lp_Print+0x120>
  400798:	b90467ff 	str	wzr, [sp, #1124]
  40079c:	b9045fff 	str	wzr, [sp, #1116]
  4007a0:	12800000 	mov	w0, #0xffffffff            	// #-1
  4007a4:	b9045be0 	str	w0, [sp, #1112]
  4007a8:	b90457ff 	str	wzr, [sp, #1108]
  4007ac:	52800400 	mov	w0, #0x20                  	// #32
  4007b0:	39114fe0 	strb	w0, [sp, #1107]
  4007b4:	f94017e0 	ldr	x0, [sp, #40]
  4007b8:	39400000 	ldrb	w0, [x0]
  4007bc:	7100b41f 	cmp	w0, #0x2d
  4007c0:	540000c1 	b.ne	4007d8 <user_lp_Print+0x15c>  // b.any
  4007c4:	52800020 	mov	w0, #0x1                   	// #1
  4007c8:	b90457e0 	str	w0, [sp, #1108]
  4007cc:	f94017e0 	ldr	x0, [sp, #40]
  4007d0:	91000400 	add	x0, x0, #0x1
  4007d4:	f90017e0 	str	x0, [sp, #40]
  4007d8:	f94017e0 	ldr	x0, [sp, #40]
  4007dc:	39400000 	ldrb	w0, [x0]
  4007e0:	7100c01f 	cmp	w0, #0x30
  4007e4:	540000c1 	b.ne	4007fc <user_lp_Print+0x180>  // b.any
  4007e8:	52800600 	mov	w0, #0x30                  	// #48
  4007ec:	39114fe0 	strb	w0, [sp, #1107]
  4007f0:	f94017e0 	ldr	x0, [sp, #40]
  4007f4:	91000400 	add	x0, x0, #0x1
  4007f8:	f90017e0 	str	x0, [sp, #40]
  4007fc:	f94017e0 	ldr	x0, [sp, #40]
  400800:	39400000 	ldrb	w0, [x0]
  400804:	7100bc1f 	cmp	w0, #0x2f
  400808:	54000369 	b.ls	400874 <user_lp_Print+0x1f8>  // b.plast
  40080c:	f94017e0 	ldr	x0, [sp, #40]
  400810:	39400000 	ldrb	w0, [x0]
  400814:	7100e41f 	cmp	w0, #0x39
  400818:	540002e8 	b.hi	400874 <user_lp_Print+0x1f8>  // b.pmore
  40081c:	1400000e 	b	400854 <user_lp_Print+0x1d8>
  400820:	b9445fe1 	ldr	w1, [sp, #1116]
  400824:	2a0103e0 	mov	w0, w1
  400828:	531e7400 	lsl	w0, w0, #2
  40082c:	0b010000 	add	w0, w0, w1
  400830:	531f7800 	lsl	w0, w0, #1
  400834:	2a0003e2 	mov	w2, w0
  400838:	f94017e0 	ldr	x0, [sp, #40]
  40083c:	91000401 	add	x1, x0, #0x1
  400840:	f90017e1 	str	x1, [sp, #40]
  400844:	39400000 	ldrb	w0, [x0]
  400848:	5100c000 	sub	w0, w0, #0x30
  40084c:	0b000040 	add	w0, w2, w0
  400850:	b9045fe0 	str	w0, [sp, #1116]
  400854:	f94017e0 	ldr	x0, [sp, #40]
  400858:	39400000 	ldrb	w0, [x0]
  40085c:	7100bc1f 	cmp	w0, #0x2f
  400860:	540000a9 	b.ls	400874 <user_lp_Print+0x1f8>  // b.plast
  400864:	f94017e0 	ldr	x0, [sp, #40]
  400868:	39400000 	ldrb	w0, [x0]
  40086c:	7100e41f 	cmp	w0, #0x39
  400870:	54fffd89 	b.ls	400820 <user_lp_Print+0x1a4>  // b.plast
  400874:	f94017e0 	ldr	x0, [sp, #40]
  400878:	39400000 	ldrb	w0, [x0]
  40087c:	7100b81f 	cmp	w0, #0x2e
  400880:	54000461 	b.ne	40090c <user_lp_Print+0x290>  // b.any
  400884:	f94017e0 	ldr	x0, [sp, #40]
  400888:	91000400 	add	x0, x0, #0x1
  40088c:	f90017e0 	str	x0, [sp, #40]
  400890:	f94017e0 	ldr	x0, [sp, #40]
  400894:	39400000 	ldrb	w0, [x0]
  400898:	7100bc1f 	cmp	w0, #0x2f
  40089c:	54000389 	b.ls	40090c <user_lp_Print+0x290>  // b.plast
  4008a0:	f94017e0 	ldr	x0, [sp, #40]
  4008a4:	39400000 	ldrb	w0, [x0]
  4008a8:	7100e41f 	cmp	w0, #0x39
  4008ac:	54000308 	b.hi	40090c <user_lp_Print+0x290>  // b.pmore
  4008b0:	b9045bff 	str	wzr, [sp, #1112]
  4008b4:	1400000e 	b	4008ec <user_lp_Print+0x270>
  4008b8:	b9445be1 	ldr	w1, [sp, #1112]
  4008bc:	2a0103e0 	mov	w0, w1
  4008c0:	531e7400 	lsl	w0, w0, #2
  4008c4:	0b010000 	add	w0, w0, w1
  4008c8:	531f7800 	lsl	w0, w0, #1
  4008cc:	2a0003e2 	mov	w2, w0
  4008d0:	f94017e0 	ldr	x0, [sp, #40]
  4008d4:	91000401 	add	x1, x0, #0x1
  4008d8:	f90017e1 	str	x1, [sp, #40]
  4008dc:	39400000 	ldrb	w0, [x0]
  4008e0:	5100c000 	sub	w0, w0, #0x30
  4008e4:	0b000040 	add	w0, w2, w0
  4008e8:	b9045be0 	str	w0, [sp, #1112]
  4008ec:	f94017e0 	ldr	x0, [sp, #40]
  4008f0:	39400000 	ldrb	w0, [x0]
  4008f4:	7100bc1f 	cmp	w0, #0x2f
  4008f8:	540000a9 	b.ls	40090c <user_lp_Print+0x290>  // b.plast
  4008fc:	f94017e0 	ldr	x0, [sp, #40]
  400900:	39400000 	ldrb	w0, [x0]
  400904:	7100e41f 	cmp	w0, #0x39
  400908:	54fffd89 	b.ls	4008b8 <user_lp_Print+0x23c>  // b.plast
  40090c:	b90463ff 	str	wzr, [sp, #1120]
  400910:	f94017e0 	ldr	x0, [sp, #40]
  400914:	39400000 	ldrb	w0, [x0]
  400918:	7101e01f 	cmp	w0, #0x78
  40091c:	54003000 	b.eq	400f1c <user_lp_Print+0x8a0>  // b.none
  400920:	7101e01f 	cmp	w0, #0x78
  400924:	5400520c 	b.gt	401364 <user_lp_Print+0xce8>
  400928:	7101d41f 	cmp	w0, #0x75
  40092c:	54002520 	b.eq	400dd0 <user_lp_Print+0x754>  // b.none
  400930:	7101d41f 	cmp	w0, #0x75
  400934:	5400518c 	b.gt	401364 <user_lp_Print+0xce8>
  400938:	7101cc1f 	cmp	w0, #0x73
  40093c:	54004a40 	b.eq	401284 <user_lp_Print+0xc08>  // b.none
  400940:	7101cc1f 	cmp	w0, #0x73
  400944:	5400510c 	b.gt	401364 <user_lp_Print+0xce8>
  400948:	7101bc1f 	cmp	w0, #0x6f
  40094c:	540019c0 	b.eq	400c84 <user_lp_Print+0x608>  // b.none
  400950:	7101bc1f 	cmp	w0, #0x6f
  400954:	5400508c 	b.gt	401364 <user_lp_Print+0xce8>
  400958:	7101901f 	cmp	w0, #0x64
  40095c:	54000de0 	b.eq	400b18 <user_lp_Print+0x49c>  // b.none
  400960:	7101901f 	cmp	w0, #0x64
  400964:	5400500c 	b.gt	401364 <user_lp_Print+0xce8>
  400968:	71018c1f 	cmp	w0, #0x63
  40096c:	54004240 	b.eq	4011b4 <user_lp_Print+0xb38>  // b.none
  400970:	71018c1f 	cmp	w0, #0x63
  400974:	54004f8c 	b.gt	401364 <user_lp_Print+0xce8>
  400978:	7101881f 	cmp	w0, #0x62
  40097c:	54000280 	b.eq	4009cc <user_lp_Print+0x350>  // b.none
  400980:	7101881f 	cmp	w0, #0x62
  400984:	54004f0c 	b.gt	401364 <user_lp_Print+0xce8>
  400988:	7101601f 	cmp	w0, #0x58
  40098c:	540036e0 	b.eq	401068 <user_lp_Print+0x9ec>  // b.none
  400990:	7101601f 	cmp	w0, #0x58
  400994:	54004e8c 	b.gt	401364 <user_lp_Print+0xce8>
  400998:	7101541f 	cmp	w0, #0x55
  40099c:	540021a0 	b.eq	400dd0 <user_lp_Print+0x754>  // b.none
  4009a0:	7101541f 	cmp	w0, #0x55
  4009a4:	54004e0c 	b.gt	401364 <user_lp_Print+0xce8>
  4009a8:	71013c1f 	cmp	w0, #0x4f
  4009ac:	540016c0 	b.eq	400c84 <user_lp_Print+0x608>  // b.none
  4009b0:	71013c1f 	cmp	w0, #0x4f
  4009b4:	54004d8c 	b.gt	401364 <user_lp_Print+0xce8>
  4009b8:	7100001f 	cmp	w0, #0x0
  4009bc:	54004cc0 	b.eq	401354 <user_lp_Print+0xcd8>  // b.none
  4009c0:	7101101f 	cmp	w0, #0x44
  4009c4:	54000aa0 	b.eq	400b18 <user_lp_Print+0x49c>  // b.none
  4009c8:	14000267 	b	401364 <user_lp_Print+0xce8>
  4009cc:	b94467e0 	ldr	w0, [sp, #1124]
  4009d0:	7100001f 	cmp	w0, #0x0
  4009d4:	54000300 	b.eq	400a34 <user_lp_Print+0x3b8>  // b.none
  4009d8:	b9401a61 	ldr	w1, [x19, #24]
  4009dc:	f9400260 	ldr	x0, [x19]
  4009e0:	7100003f 	cmp	w1, #0x0
  4009e4:	540000ab 	b.lt	4009f8 <user_lp_Print+0x37c>  // b.tstop
  4009e8:	91003c01 	add	x1, x0, #0xf
  4009ec:	927df021 	and	x1, x1, #0xfffffffffffffff8
  4009f0:	f9000261 	str	x1, [x19]
  4009f4:	1400000d 	b	400a28 <user_lp_Print+0x3ac>
  4009f8:	11002022 	add	w2, w1, #0x8
  4009fc:	b9001a62 	str	w2, [x19, #24]
  400a00:	b9401a62 	ldr	w2, [x19, #24]
  400a04:	7100005f 	cmp	w2, #0x0
  400a08:	540000ad 	b.le	400a1c <user_lp_Print+0x3a0>
  400a0c:	91003c01 	add	x1, x0, #0xf
  400a10:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400a14:	f9000261 	str	x1, [x19]
  400a18:	14000004 	b	400a28 <user_lp_Print+0x3ac>
  400a1c:	f9400662 	ldr	x2, [x19, #8]
  400a20:	93407c20 	sxtw	x0, w1
  400a24:	8b000040 	add	x0, x2, x0
  400a28:	f9400000 	ldr	x0, [x0]
  400a2c:	f90237e0 	str	x0, [sp, #1128]
  400a30:	14000018 	b	400a90 <user_lp_Print+0x414>
  400a34:	b9401a61 	ldr	w1, [x19, #24]
  400a38:	f9400260 	ldr	x0, [x19]
  400a3c:	7100003f 	cmp	w1, #0x0
  400a40:	540000ab 	b.lt	400a54 <user_lp_Print+0x3d8>  // b.tstop
  400a44:	91002c01 	add	x1, x0, #0xb
  400a48:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400a4c:	f9000261 	str	x1, [x19]
  400a50:	1400000d 	b	400a84 <user_lp_Print+0x408>
  400a54:	11002022 	add	w2, w1, #0x8
  400a58:	b9001a62 	str	w2, [x19, #24]
  400a5c:	b9401a62 	ldr	w2, [x19, #24]
  400a60:	7100005f 	cmp	w2, #0x0
  400a64:	540000ad 	b.le	400a78 <user_lp_Print+0x3fc>
  400a68:	91002c01 	add	x1, x0, #0xb
  400a6c:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400a70:	f9000261 	str	x1, [x19]
  400a74:	14000004 	b	400a84 <user_lp_Print+0x408>
  400a78:	f9400662 	ldr	x2, [x19, #8]
  400a7c:	93407c20 	sxtw	x0, w1
  400a80:	8b000040 	add	x0, x2, x0
  400a84:	b9400000 	ldr	w0, [x0]
  400a88:	93407c00 	sxtw	x0, w0
  400a8c:	f90237e0 	str	x0, [sp, #1128]
  400a90:	f94237e1 	ldr	x1, [sp, #1128]
  400a94:	910123e0 	add	x0, sp, #0x48
  400a98:	52800007 	mov	w7, #0x0                   	// #0
  400a9c:	39514fe6 	ldrb	w6, [sp, #1107]
  400aa0:	b94457e5 	ldr	w5, [sp, #1108]
  400aa4:	b9445fe4 	ldr	w4, [sp, #1116]
  400aa8:	52800003 	mov	w3, #0x0                   	// #0
  400aac:	52800042 	mov	w2, #0x2                   	// #2
  400ab0:	940002e8 	bl	401650 <user_PrintNum>
  400ab4:	b90447e0 	str	w0, [sp, #1092]
  400ab8:	b94447e0 	ldr	w0, [sp, #1092]
  400abc:	7100001f 	cmp	w0, #0x0
  400ac0:	5400008b 	b.lt	400ad0 <user_lp_Print+0x454>  // b.tstop
  400ac4:	b94447e0 	ldr	w0, [sp, #1092]
  400ac8:	710fa01f 	cmp	w0, #0x3e8
  400acc:	5400010d 	b.le	400aec <user_lp_Print+0x470>
  400ad0:	f9401fe3 	ldr	x3, [sp, #56]
  400ad4:	528003a2 	mov	w2, #0x1d                  	// #29
  400ad8:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  400adc:	91036001 	add	x1, x0, #0xd8
  400ae0:	f9401be0 	ldr	x0, [sp, #48]
  400ae4:	d63f0060 	blr	x3
  400ae8:	14000000 	b	400ae8 <user_lp_Print+0x46c>
  400aec:	910123e0 	add	x0, sp, #0x48
  400af0:	f9401fe3 	ldr	x3, [sp, #56]
  400af4:	b94447e2 	ldr	w2, [sp, #1092]
  400af8:	aa0003e1 	mov	x1, x0
  400afc:	f9401be0 	ldr	x0, [sp, #48]
  400b00:	d63f0060 	blr	x3
  400b04:	b98447e0 	ldrsw	x0, [sp, #1092]
  400b08:	f9401be1 	ldr	x1, [sp, #48]
  400b0c:	8b000020 	add	x0, x1, x0
  400b10:	f9001be0 	str	x0, [sp, #48]
  400b14:	1400021c 	b	401384 <user_lp_Print+0xd08>
  400b18:	b94467e0 	ldr	w0, [sp, #1124]
  400b1c:	7100001f 	cmp	w0, #0x0
  400b20:	54000300 	b.eq	400b80 <user_lp_Print+0x504>  // b.none
  400b24:	b9401a61 	ldr	w1, [x19, #24]
  400b28:	f9400260 	ldr	x0, [x19]
  400b2c:	7100003f 	cmp	w1, #0x0
  400b30:	540000ab 	b.lt	400b44 <user_lp_Print+0x4c8>  // b.tstop
  400b34:	91003c01 	add	x1, x0, #0xf
  400b38:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400b3c:	f9000261 	str	x1, [x19]
  400b40:	1400000d 	b	400b74 <user_lp_Print+0x4f8>
  400b44:	11002022 	add	w2, w1, #0x8
  400b48:	b9001a62 	str	w2, [x19, #24]
  400b4c:	b9401a62 	ldr	w2, [x19, #24]
  400b50:	7100005f 	cmp	w2, #0x0
  400b54:	540000ad 	b.le	400b68 <user_lp_Print+0x4ec>
  400b58:	91003c01 	add	x1, x0, #0xf
  400b5c:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400b60:	f9000261 	str	x1, [x19]
  400b64:	14000004 	b	400b74 <user_lp_Print+0x4f8>
  400b68:	f9400662 	ldr	x2, [x19, #8]
  400b6c:	93407c20 	sxtw	x0, w1
  400b70:	8b000040 	add	x0, x2, x0
  400b74:	f9400000 	ldr	x0, [x0]
  400b78:	f90237e0 	str	x0, [sp, #1128]
  400b7c:	14000018 	b	400bdc <user_lp_Print+0x560>
  400b80:	b9401a61 	ldr	w1, [x19, #24]
  400b84:	f9400260 	ldr	x0, [x19]
  400b88:	7100003f 	cmp	w1, #0x0
  400b8c:	540000ab 	b.lt	400ba0 <user_lp_Print+0x524>  // b.tstop
  400b90:	91002c01 	add	x1, x0, #0xb
  400b94:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400b98:	f9000261 	str	x1, [x19]
  400b9c:	1400000d 	b	400bd0 <user_lp_Print+0x554>
  400ba0:	11002022 	add	w2, w1, #0x8
  400ba4:	b9001a62 	str	w2, [x19, #24]
  400ba8:	b9401a62 	ldr	w2, [x19, #24]
  400bac:	7100005f 	cmp	w2, #0x0
  400bb0:	540000ad 	b.le	400bc4 <user_lp_Print+0x548>
  400bb4:	91002c01 	add	x1, x0, #0xb
  400bb8:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400bbc:	f9000261 	str	x1, [x19]
  400bc0:	14000004 	b	400bd0 <user_lp_Print+0x554>
  400bc4:	f9400662 	ldr	x2, [x19, #8]
  400bc8:	93407c20 	sxtw	x0, w1
  400bcc:	8b000040 	add	x0, x2, x0
  400bd0:	b9400000 	ldr	w0, [x0]
  400bd4:	93407c00 	sxtw	x0, w0
  400bd8:	f90237e0 	str	x0, [sp, #1128]
  400bdc:	f94237e0 	ldr	x0, [sp, #1128]
  400be0:	f100001f 	cmp	x0, #0x0
  400be4:	540000ca 	b.ge	400bfc <user_lp_Print+0x580>  // b.tcont
  400be8:	f94237e0 	ldr	x0, [sp, #1128]
  400bec:	cb0003e0 	neg	x0, x0
  400bf0:	f90237e0 	str	x0, [sp, #1128]
  400bf4:	52800020 	mov	w0, #0x1                   	// #1
  400bf8:	b90463e0 	str	w0, [sp, #1120]
  400bfc:	f94237e1 	ldr	x1, [sp, #1128]
  400c00:	910123e0 	add	x0, sp, #0x48
  400c04:	52800007 	mov	w7, #0x0                   	// #0
  400c08:	39514fe6 	ldrb	w6, [sp, #1107]
  400c0c:	b94457e5 	ldr	w5, [sp, #1108]
  400c10:	b9445fe4 	ldr	w4, [sp, #1116]
  400c14:	b94463e3 	ldr	w3, [sp, #1120]
  400c18:	52800142 	mov	w2, #0xa                   	// #10
  400c1c:	9400028d 	bl	401650 <user_PrintNum>
  400c20:	b90447e0 	str	w0, [sp, #1092]
  400c24:	b94447e0 	ldr	w0, [sp, #1092]
  400c28:	7100001f 	cmp	w0, #0x0
  400c2c:	5400008b 	b.lt	400c3c <user_lp_Print+0x5c0>  // b.tstop
  400c30:	b94447e0 	ldr	w0, [sp, #1092]
  400c34:	710fa01f 	cmp	w0, #0x3e8
  400c38:	5400010d 	b.le	400c58 <user_lp_Print+0x5dc>
  400c3c:	f9401fe3 	ldr	x3, [sp, #56]
  400c40:	528003a2 	mov	w2, #0x1d                  	// #29
  400c44:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  400c48:	91036001 	add	x1, x0, #0xd8
  400c4c:	f9401be0 	ldr	x0, [sp, #48]
  400c50:	d63f0060 	blr	x3
  400c54:	14000000 	b	400c54 <user_lp_Print+0x5d8>
  400c58:	910123e0 	add	x0, sp, #0x48
  400c5c:	f9401fe3 	ldr	x3, [sp, #56]
  400c60:	b94447e2 	ldr	w2, [sp, #1092]
  400c64:	aa0003e1 	mov	x1, x0
  400c68:	f9401be0 	ldr	x0, [sp, #48]
  400c6c:	d63f0060 	blr	x3
  400c70:	b98447e0 	ldrsw	x0, [sp, #1092]
  400c74:	f9401be1 	ldr	x1, [sp, #48]
  400c78:	8b000020 	add	x0, x1, x0
  400c7c:	f9001be0 	str	x0, [sp, #48]
  400c80:	140001c1 	b	401384 <user_lp_Print+0xd08>
  400c84:	b94467e0 	ldr	w0, [sp, #1124]
  400c88:	7100001f 	cmp	w0, #0x0
  400c8c:	54000300 	b.eq	400cec <user_lp_Print+0x670>  // b.none
  400c90:	b9401a61 	ldr	w1, [x19, #24]
  400c94:	f9400260 	ldr	x0, [x19]
  400c98:	7100003f 	cmp	w1, #0x0
  400c9c:	540000ab 	b.lt	400cb0 <user_lp_Print+0x634>  // b.tstop
  400ca0:	91003c01 	add	x1, x0, #0xf
  400ca4:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400ca8:	f9000261 	str	x1, [x19]
  400cac:	1400000d 	b	400ce0 <user_lp_Print+0x664>
  400cb0:	11002022 	add	w2, w1, #0x8
  400cb4:	b9001a62 	str	w2, [x19, #24]
  400cb8:	b9401a62 	ldr	w2, [x19, #24]
  400cbc:	7100005f 	cmp	w2, #0x0
  400cc0:	540000ad 	b.le	400cd4 <user_lp_Print+0x658>
  400cc4:	91003c01 	add	x1, x0, #0xf
  400cc8:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400ccc:	f9000261 	str	x1, [x19]
  400cd0:	14000004 	b	400ce0 <user_lp_Print+0x664>
  400cd4:	f9400662 	ldr	x2, [x19, #8]
  400cd8:	93407c20 	sxtw	x0, w1
  400cdc:	8b000040 	add	x0, x2, x0
  400ce0:	f9400000 	ldr	x0, [x0]
  400ce4:	f90237e0 	str	x0, [sp, #1128]
  400ce8:	14000018 	b	400d48 <user_lp_Print+0x6cc>
  400cec:	b9401a61 	ldr	w1, [x19, #24]
  400cf0:	f9400260 	ldr	x0, [x19]
  400cf4:	7100003f 	cmp	w1, #0x0
  400cf8:	540000ab 	b.lt	400d0c <user_lp_Print+0x690>  // b.tstop
  400cfc:	91002c01 	add	x1, x0, #0xb
  400d00:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400d04:	f9000261 	str	x1, [x19]
  400d08:	1400000d 	b	400d3c <user_lp_Print+0x6c0>
  400d0c:	11002022 	add	w2, w1, #0x8
  400d10:	b9001a62 	str	w2, [x19, #24]
  400d14:	b9401a62 	ldr	w2, [x19, #24]
  400d18:	7100005f 	cmp	w2, #0x0
  400d1c:	540000ad 	b.le	400d30 <user_lp_Print+0x6b4>
  400d20:	91002c01 	add	x1, x0, #0xb
  400d24:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400d28:	f9000261 	str	x1, [x19]
  400d2c:	14000004 	b	400d3c <user_lp_Print+0x6c0>
  400d30:	f9400662 	ldr	x2, [x19, #8]
  400d34:	93407c20 	sxtw	x0, w1
  400d38:	8b000040 	add	x0, x2, x0
  400d3c:	b9400000 	ldr	w0, [x0]
  400d40:	93407c00 	sxtw	x0, w0
  400d44:	f90237e0 	str	x0, [sp, #1128]
  400d48:	f94237e1 	ldr	x1, [sp, #1128]
  400d4c:	910123e0 	add	x0, sp, #0x48
  400d50:	52800007 	mov	w7, #0x0                   	// #0
  400d54:	39514fe6 	ldrb	w6, [sp, #1107]
  400d58:	b94457e5 	ldr	w5, [sp, #1108]
  400d5c:	b9445fe4 	ldr	w4, [sp, #1116]
  400d60:	52800003 	mov	w3, #0x0                   	// #0
  400d64:	52800102 	mov	w2, #0x8                   	// #8
  400d68:	9400023a 	bl	401650 <user_PrintNum>
  400d6c:	b90447e0 	str	w0, [sp, #1092]
  400d70:	b94447e0 	ldr	w0, [sp, #1092]
  400d74:	7100001f 	cmp	w0, #0x0
  400d78:	5400008b 	b.lt	400d88 <user_lp_Print+0x70c>  // b.tstop
  400d7c:	b94447e0 	ldr	w0, [sp, #1092]
  400d80:	710fa01f 	cmp	w0, #0x3e8
  400d84:	5400010d 	b.le	400da4 <user_lp_Print+0x728>
  400d88:	f9401fe3 	ldr	x3, [sp, #56]
  400d8c:	528003a2 	mov	w2, #0x1d                  	// #29
  400d90:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  400d94:	91036001 	add	x1, x0, #0xd8
  400d98:	f9401be0 	ldr	x0, [sp, #48]
  400d9c:	d63f0060 	blr	x3
  400da0:	14000000 	b	400da0 <user_lp_Print+0x724>
  400da4:	910123e0 	add	x0, sp, #0x48
  400da8:	f9401fe3 	ldr	x3, [sp, #56]
  400dac:	b94447e2 	ldr	w2, [sp, #1092]
  400db0:	aa0003e1 	mov	x1, x0
  400db4:	f9401be0 	ldr	x0, [sp, #48]
  400db8:	d63f0060 	blr	x3
  400dbc:	b98447e0 	ldrsw	x0, [sp, #1092]
  400dc0:	f9401be1 	ldr	x1, [sp, #48]
  400dc4:	8b000020 	add	x0, x1, x0
  400dc8:	f9001be0 	str	x0, [sp, #48]
  400dcc:	1400016e 	b	401384 <user_lp_Print+0xd08>
  400dd0:	b94467e0 	ldr	w0, [sp, #1124]
  400dd4:	7100001f 	cmp	w0, #0x0
  400dd8:	54000300 	b.eq	400e38 <user_lp_Print+0x7bc>  // b.none
  400ddc:	b9401a61 	ldr	w1, [x19, #24]
  400de0:	f9400260 	ldr	x0, [x19]
  400de4:	7100003f 	cmp	w1, #0x0
  400de8:	540000ab 	b.lt	400dfc <user_lp_Print+0x780>  // b.tstop
  400dec:	91003c01 	add	x1, x0, #0xf
  400df0:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400df4:	f9000261 	str	x1, [x19]
  400df8:	1400000d 	b	400e2c <user_lp_Print+0x7b0>
  400dfc:	11002022 	add	w2, w1, #0x8
  400e00:	b9001a62 	str	w2, [x19, #24]
  400e04:	b9401a62 	ldr	w2, [x19, #24]
  400e08:	7100005f 	cmp	w2, #0x0
  400e0c:	540000ad 	b.le	400e20 <user_lp_Print+0x7a4>
  400e10:	91003c01 	add	x1, x0, #0xf
  400e14:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400e18:	f9000261 	str	x1, [x19]
  400e1c:	14000004 	b	400e2c <user_lp_Print+0x7b0>
  400e20:	f9400662 	ldr	x2, [x19, #8]
  400e24:	93407c20 	sxtw	x0, w1
  400e28:	8b000040 	add	x0, x2, x0
  400e2c:	f9400000 	ldr	x0, [x0]
  400e30:	f90237e0 	str	x0, [sp, #1128]
  400e34:	14000018 	b	400e94 <user_lp_Print+0x818>
  400e38:	b9401a61 	ldr	w1, [x19, #24]
  400e3c:	f9400260 	ldr	x0, [x19]
  400e40:	7100003f 	cmp	w1, #0x0
  400e44:	540000ab 	b.lt	400e58 <user_lp_Print+0x7dc>  // b.tstop
  400e48:	91002c01 	add	x1, x0, #0xb
  400e4c:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400e50:	f9000261 	str	x1, [x19]
  400e54:	1400000d 	b	400e88 <user_lp_Print+0x80c>
  400e58:	11002022 	add	w2, w1, #0x8
  400e5c:	b9001a62 	str	w2, [x19, #24]
  400e60:	b9401a62 	ldr	w2, [x19, #24]
  400e64:	7100005f 	cmp	w2, #0x0
  400e68:	540000ad 	b.le	400e7c <user_lp_Print+0x800>
  400e6c:	91002c01 	add	x1, x0, #0xb
  400e70:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400e74:	f9000261 	str	x1, [x19]
  400e78:	14000004 	b	400e88 <user_lp_Print+0x80c>
  400e7c:	f9400662 	ldr	x2, [x19, #8]
  400e80:	93407c20 	sxtw	x0, w1
  400e84:	8b000040 	add	x0, x2, x0
  400e88:	b9400000 	ldr	w0, [x0]
  400e8c:	93407c00 	sxtw	x0, w0
  400e90:	f90237e0 	str	x0, [sp, #1128]
  400e94:	f94237e1 	ldr	x1, [sp, #1128]
  400e98:	910123e0 	add	x0, sp, #0x48
  400e9c:	52800007 	mov	w7, #0x0                   	// #0
  400ea0:	39514fe6 	ldrb	w6, [sp, #1107]
  400ea4:	b94457e5 	ldr	w5, [sp, #1108]
  400ea8:	b9445fe4 	ldr	w4, [sp, #1116]
  400eac:	52800003 	mov	w3, #0x0                   	// #0
  400eb0:	52800142 	mov	w2, #0xa                   	// #10
  400eb4:	940001e7 	bl	401650 <user_PrintNum>
  400eb8:	b90447e0 	str	w0, [sp, #1092]
  400ebc:	b94447e0 	ldr	w0, [sp, #1092]
  400ec0:	7100001f 	cmp	w0, #0x0
  400ec4:	5400008b 	b.lt	400ed4 <user_lp_Print+0x858>  // b.tstop
  400ec8:	b94447e0 	ldr	w0, [sp, #1092]
  400ecc:	710fa01f 	cmp	w0, #0x3e8
  400ed0:	5400010d 	b.le	400ef0 <user_lp_Print+0x874>
  400ed4:	f9401fe3 	ldr	x3, [sp, #56]
  400ed8:	528003a2 	mov	w2, #0x1d                  	// #29
  400edc:	d0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  400ee0:	91036001 	add	x1, x0, #0xd8
  400ee4:	f9401be0 	ldr	x0, [sp, #48]
  400ee8:	d63f0060 	blr	x3
  400eec:	14000000 	b	400eec <user_lp_Print+0x870>
  400ef0:	910123e0 	add	x0, sp, #0x48
  400ef4:	f9401fe3 	ldr	x3, [sp, #56]
  400ef8:	b94447e2 	ldr	w2, [sp, #1092]
  400efc:	aa0003e1 	mov	x1, x0
  400f00:	f9401be0 	ldr	x0, [sp, #48]
  400f04:	d63f0060 	blr	x3
  400f08:	b98447e0 	ldrsw	x0, [sp, #1092]
  400f0c:	f9401be1 	ldr	x1, [sp, #48]
  400f10:	8b000020 	add	x0, x1, x0
  400f14:	f9001be0 	str	x0, [sp, #48]
  400f18:	1400011b 	b	401384 <user_lp_Print+0xd08>
  400f1c:	b94467e0 	ldr	w0, [sp, #1124]
  400f20:	7100001f 	cmp	w0, #0x0
  400f24:	54000300 	b.eq	400f84 <user_lp_Print+0x908>  // b.none
  400f28:	b9401a61 	ldr	w1, [x19, #24]
  400f2c:	f9400260 	ldr	x0, [x19]
  400f30:	7100003f 	cmp	w1, #0x0
  400f34:	540000ab 	b.lt	400f48 <user_lp_Print+0x8cc>  // b.tstop
  400f38:	91003c01 	add	x1, x0, #0xf
  400f3c:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400f40:	f9000261 	str	x1, [x19]
  400f44:	1400000d 	b	400f78 <user_lp_Print+0x8fc>
  400f48:	11002022 	add	w2, w1, #0x8
  400f4c:	b9001a62 	str	w2, [x19, #24]
  400f50:	b9401a62 	ldr	w2, [x19, #24]
  400f54:	7100005f 	cmp	w2, #0x0
  400f58:	540000ad 	b.le	400f6c <user_lp_Print+0x8f0>
  400f5c:	91003c01 	add	x1, x0, #0xf
  400f60:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400f64:	f9000261 	str	x1, [x19]
  400f68:	14000004 	b	400f78 <user_lp_Print+0x8fc>
  400f6c:	f9400662 	ldr	x2, [x19, #8]
  400f70:	93407c20 	sxtw	x0, w1
  400f74:	8b000040 	add	x0, x2, x0
  400f78:	f9400000 	ldr	x0, [x0]
  400f7c:	f90237e0 	str	x0, [sp, #1128]
  400f80:	14000018 	b	400fe0 <user_lp_Print+0x964>
  400f84:	b9401a61 	ldr	w1, [x19, #24]
  400f88:	f9400260 	ldr	x0, [x19]
  400f8c:	7100003f 	cmp	w1, #0x0
  400f90:	540000ab 	b.lt	400fa4 <user_lp_Print+0x928>  // b.tstop
  400f94:	91002c01 	add	x1, x0, #0xb
  400f98:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400f9c:	f9000261 	str	x1, [x19]
  400fa0:	1400000d 	b	400fd4 <user_lp_Print+0x958>
  400fa4:	11002022 	add	w2, w1, #0x8
  400fa8:	b9001a62 	str	w2, [x19, #24]
  400fac:	b9401a62 	ldr	w2, [x19, #24]
  400fb0:	7100005f 	cmp	w2, #0x0
  400fb4:	540000ad 	b.le	400fc8 <user_lp_Print+0x94c>
  400fb8:	91002c01 	add	x1, x0, #0xb
  400fbc:	927df021 	and	x1, x1, #0xfffffffffffffff8
  400fc0:	f9000261 	str	x1, [x19]
  400fc4:	14000004 	b	400fd4 <user_lp_Print+0x958>
  400fc8:	f9400662 	ldr	x2, [x19, #8]
  400fcc:	93407c20 	sxtw	x0, w1
  400fd0:	8b000040 	add	x0, x2, x0
  400fd4:	b9400000 	ldr	w0, [x0]
  400fd8:	93407c00 	sxtw	x0, w0
  400fdc:	f90237e0 	str	x0, [sp, #1128]
  400fe0:	f94237e1 	ldr	x1, [sp, #1128]
  400fe4:	910123e0 	add	x0, sp, #0x48
  400fe8:	52800007 	mov	w7, #0x0                   	// #0
  400fec:	39514fe6 	ldrb	w6, [sp, #1107]
  400ff0:	b94457e5 	ldr	w5, [sp, #1108]
  400ff4:	b9445fe4 	ldr	w4, [sp, #1116]
  400ff8:	52800003 	mov	w3, #0x0                   	// #0
  400ffc:	52800202 	mov	w2, #0x10                  	// #16
  401000:	94000194 	bl	401650 <user_PrintNum>
  401004:	b90447e0 	str	w0, [sp, #1092]
  401008:	b94447e0 	ldr	w0, [sp, #1092]
  40100c:	7100001f 	cmp	w0, #0x0
  401010:	5400008b 	b.lt	401020 <user_lp_Print+0x9a4>  // b.tstop
  401014:	b94447e0 	ldr	w0, [sp, #1092]
  401018:	710fa01f 	cmp	w0, #0x3e8
  40101c:	5400010d 	b.le	40103c <user_lp_Print+0x9c0>
  401020:	f9401fe3 	ldr	x3, [sp, #56]
  401024:	528003a2 	mov	w2, #0x1d                  	// #29
  401028:	b0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  40102c:	91036001 	add	x1, x0, #0xd8
  401030:	f9401be0 	ldr	x0, [sp, #48]
  401034:	d63f0060 	blr	x3
  401038:	14000000 	b	401038 <user_lp_Print+0x9bc>
  40103c:	910123e0 	add	x0, sp, #0x48
  401040:	f9401fe3 	ldr	x3, [sp, #56]
  401044:	b94447e2 	ldr	w2, [sp, #1092]
  401048:	aa0003e1 	mov	x1, x0
  40104c:	f9401be0 	ldr	x0, [sp, #48]
  401050:	d63f0060 	blr	x3
  401054:	b98447e0 	ldrsw	x0, [sp, #1092]
  401058:	f9401be1 	ldr	x1, [sp, #48]
  40105c:	8b000020 	add	x0, x1, x0
  401060:	f9001be0 	str	x0, [sp, #48]
  401064:	140000c8 	b	401384 <user_lp_Print+0xd08>
  401068:	b94467e0 	ldr	w0, [sp, #1124]
  40106c:	7100001f 	cmp	w0, #0x0
  401070:	54000300 	b.eq	4010d0 <user_lp_Print+0xa54>  // b.none
  401074:	b9401a61 	ldr	w1, [x19, #24]
  401078:	f9400260 	ldr	x0, [x19]
  40107c:	7100003f 	cmp	w1, #0x0
  401080:	540000ab 	b.lt	401094 <user_lp_Print+0xa18>  // b.tstop
  401084:	91003c01 	add	x1, x0, #0xf
  401088:	927df021 	and	x1, x1, #0xfffffffffffffff8
  40108c:	f9000261 	str	x1, [x19]
  401090:	1400000d 	b	4010c4 <user_lp_Print+0xa48>
  401094:	11002022 	add	w2, w1, #0x8
  401098:	b9001a62 	str	w2, [x19, #24]
  40109c:	b9401a62 	ldr	w2, [x19, #24]
  4010a0:	7100005f 	cmp	w2, #0x0
  4010a4:	540000ad 	b.le	4010b8 <user_lp_Print+0xa3c>
  4010a8:	91003c01 	add	x1, x0, #0xf
  4010ac:	927df021 	and	x1, x1, #0xfffffffffffffff8
  4010b0:	f9000261 	str	x1, [x19]
  4010b4:	14000004 	b	4010c4 <user_lp_Print+0xa48>
  4010b8:	f9400662 	ldr	x2, [x19, #8]
  4010bc:	93407c20 	sxtw	x0, w1
  4010c0:	8b000040 	add	x0, x2, x0
  4010c4:	f9400000 	ldr	x0, [x0]
  4010c8:	f90237e0 	str	x0, [sp, #1128]
  4010cc:	14000018 	b	40112c <user_lp_Print+0xab0>
  4010d0:	b9401a61 	ldr	w1, [x19, #24]
  4010d4:	f9400260 	ldr	x0, [x19]
  4010d8:	7100003f 	cmp	w1, #0x0
  4010dc:	540000ab 	b.lt	4010f0 <user_lp_Print+0xa74>  // b.tstop
  4010e0:	91002c01 	add	x1, x0, #0xb
  4010e4:	927df021 	and	x1, x1, #0xfffffffffffffff8
  4010e8:	f9000261 	str	x1, [x19]
  4010ec:	1400000d 	b	401120 <user_lp_Print+0xaa4>
  4010f0:	11002022 	add	w2, w1, #0x8
  4010f4:	b9001a62 	str	w2, [x19, #24]
  4010f8:	b9401a62 	ldr	w2, [x19, #24]
  4010fc:	7100005f 	cmp	w2, #0x0
  401100:	540000ad 	b.le	401114 <user_lp_Print+0xa98>
  401104:	91002c01 	add	x1, x0, #0xb
  401108:	927df021 	and	x1, x1, #0xfffffffffffffff8
  40110c:	f9000261 	str	x1, [x19]
  401110:	14000004 	b	401120 <user_lp_Print+0xaa4>
  401114:	f9400662 	ldr	x2, [x19, #8]
  401118:	93407c20 	sxtw	x0, w1
  40111c:	8b000040 	add	x0, x2, x0
  401120:	b9400000 	ldr	w0, [x0]
  401124:	93407c00 	sxtw	x0, w0
  401128:	f90237e0 	str	x0, [sp, #1128]
  40112c:	f94237e1 	ldr	x1, [sp, #1128]
  401130:	910123e0 	add	x0, sp, #0x48
  401134:	52800027 	mov	w7, #0x1                   	// #1
  401138:	39514fe6 	ldrb	w6, [sp, #1107]
  40113c:	b94457e5 	ldr	w5, [sp, #1108]
  401140:	b9445fe4 	ldr	w4, [sp, #1116]
  401144:	52800003 	mov	w3, #0x0                   	// #0
  401148:	52800202 	mov	w2, #0x10                  	// #16
  40114c:	94000141 	bl	401650 <user_PrintNum>
  401150:	b90447e0 	str	w0, [sp, #1092]
  401154:	b94447e0 	ldr	w0, [sp, #1092]
  401158:	7100001f 	cmp	w0, #0x0
  40115c:	5400008b 	b.lt	40116c <user_lp_Print+0xaf0>  // b.tstop
  401160:	b94447e0 	ldr	w0, [sp, #1092]
  401164:	710fa01f 	cmp	w0, #0x3e8
  401168:	5400010d 	b.le	401188 <user_lp_Print+0xb0c>
  40116c:	f9401fe3 	ldr	x3, [sp, #56]
  401170:	528003a2 	mov	w2, #0x1d                  	// #29
  401174:	b0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  401178:	91036001 	add	x1, x0, #0xd8
  40117c:	f9401be0 	ldr	x0, [sp, #48]
  401180:	d63f0060 	blr	x3
  401184:	14000000 	b	401184 <user_lp_Print+0xb08>
  401188:	910123e0 	add	x0, sp, #0x48
  40118c:	f9401fe3 	ldr	x3, [sp, #56]
  401190:	b94447e2 	ldr	w2, [sp, #1092]
  401194:	aa0003e1 	mov	x1, x0
  401198:	f9401be0 	ldr	x0, [sp, #48]
  40119c:	d63f0060 	blr	x3
  4011a0:	b98447e0 	ldrsw	x0, [sp, #1092]
  4011a4:	f9401be1 	ldr	x1, [sp, #48]
  4011a8:	8b000020 	add	x0, x1, x0
  4011ac:	f9001be0 	str	x0, [sp, #48]
  4011b0:	14000075 	b	401384 <user_lp_Print+0xd08>
  4011b4:	b9401a61 	ldr	w1, [x19, #24]
  4011b8:	f9400260 	ldr	x0, [x19]
  4011bc:	7100003f 	cmp	w1, #0x0
  4011c0:	540000ab 	b.lt	4011d4 <user_lp_Print+0xb58>  // b.tstop
  4011c4:	91002c01 	add	x1, x0, #0xb
  4011c8:	927df021 	and	x1, x1, #0xfffffffffffffff8
  4011cc:	f9000261 	str	x1, [x19]
  4011d0:	1400000d 	b	401204 <user_lp_Print+0xb88>
  4011d4:	11002022 	add	w2, w1, #0x8
  4011d8:	b9001a62 	str	w2, [x19, #24]
  4011dc:	b9401a62 	ldr	w2, [x19, #24]
  4011e0:	7100005f 	cmp	w2, #0x0
  4011e4:	540000ad 	b.le	4011f8 <user_lp_Print+0xb7c>
  4011e8:	91002c01 	add	x1, x0, #0xb
  4011ec:	927df021 	and	x1, x1, #0xfffffffffffffff8
  4011f0:	f9000261 	str	x1, [x19]
  4011f4:	14000004 	b	401204 <user_lp_Print+0xb88>
  4011f8:	f9400662 	ldr	x2, [x19, #8]
  4011fc:	93407c20 	sxtw	x0, w1
  401200:	8b000040 	add	x0, x2, x0
  401204:	b9400000 	ldr	w0, [x0]
  401208:	3910dfe0 	strb	w0, [sp, #1079]
  40120c:	910123e0 	add	x0, sp, #0x48
  401210:	b94457e3 	ldr	w3, [sp, #1108]
  401214:	b9445fe2 	ldr	w2, [sp, #1116]
  401218:	3950dfe1 	ldrb	w1, [sp, #1079]
  40121c:	9400006d 	bl	4013d0 <user_PrintChar>
  401220:	b90447e0 	str	w0, [sp, #1092]
  401224:	b94447e0 	ldr	w0, [sp, #1092]
  401228:	7100001f 	cmp	w0, #0x0
  40122c:	5400008b 	b.lt	40123c <user_lp_Print+0xbc0>  // b.tstop
  401230:	b94447e0 	ldr	w0, [sp, #1092]
  401234:	710fa01f 	cmp	w0, #0x3e8
  401238:	5400010d 	b.le	401258 <user_lp_Print+0xbdc>
  40123c:	f9401fe3 	ldr	x3, [sp, #56]
  401240:	528003a2 	mov	w2, #0x1d                  	// #29
  401244:	b0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  401248:	91036001 	add	x1, x0, #0xd8
  40124c:	f9401be0 	ldr	x0, [sp, #48]
  401250:	d63f0060 	blr	x3
  401254:	14000000 	b	401254 <user_lp_Print+0xbd8>
  401258:	910123e0 	add	x0, sp, #0x48
  40125c:	f9401fe3 	ldr	x3, [sp, #56]
  401260:	b94447e2 	ldr	w2, [sp, #1092]
  401264:	aa0003e1 	mov	x1, x0
  401268:	f9401be0 	ldr	x0, [sp, #48]
  40126c:	d63f0060 	blr	x3
  401270:	b98447e0 	ldrsw	x0, [sp, #1092]
  401274:	f9401be1 	ldr	x1, [sp, #48]
  401278:	8b000020 	add	x0, x1, x0
  40127c:	f9001be0 	str	x0, [sp, #48]
  401280:	14000041 	b	401384 <user_lp_Print+0xd08>
  401284:	b9401a61 	ldr	w1, [x19, #24]
  401288:	f9400260 	ldr	x0, [x19]
  40128c:	7100003f 	cmp	w1, #0x0
  401290:	540000ab 	b.lt	4012a4 <user_lp_Print+0xc28>  // b.tstop
  401294:	91003c01 	add	x1, x0, #0xf
  401298:	927df021 	and	x1, x1, #0xfffffffffffffff8
  40129c:	f9000261 	str	x1, [x19]
  4012a0:	1400000d 	b	4012d4 <user_lp_Print+0xc58>
  4012a4:	11002022 	add	w2, w1, #0x8
  4012a8:	b9001a62 	str	w2, [x19, #24]
  4012ac:	b9401a62 	ldr	w2, [x19, #24]
  4012b0:	7100005f 	cmp	w2, #0x0
  4012b4:	540000ad 	b.le	4012c8 <user_lp_Print+0xc4c>
  4012b8:	91003c01 	add	x1, x0, #0xf
  4012bc:	927df021 	and	x1, x1, #0xfffffffffffffff8
  4012c0:	f9000261 	str	x1, [x19]
  4012c4:	14000004 	b	4012d4 <user_lp_Print+0xc58>
  4012c8:	f9400662 	ldr	x2, [x19, #8]
  4012cc:	93407c20 	sxtw	x0, w1
  4012d0:	8b000040 	add	x0, x2, x0
  4012d4:	f9400000 	ldr	x0, [x0]
  4012d8:	f9021fe0 	str	x0, [sp, #1080]
  4012dc:	910123e0 	add	x0, sp, #0x48
  4012e0:	b94457e3 	ldr	w3, [sp, #1108]
  4012e4:	b9445fe2 	ldr	w2, [sp, #1116]
  4012e8:	f9421fe1 	ldr	x1, [sp, #1080]
  4012ec:	94000071 	bl	4014b0 <user_PrintString>
  4012f0:	b90447e0 	str	w0, [sp, #1092]
  4012f4:	b94447e0 	ldr	w0, [sp, #1092]
  4012f8:	7100001f 	cmp	w0, #0x0
  4012fc:	5400008b 	b.lt	40130c <user_lp_Print+0xc90>  // b.tstop
  401300:	b94447e0 	ldr	w0, [sp, #1092]
  401304:	710fa01f 	cmp	w0, #0x3e8
  401308:	5400010d 	b.le	401328 <user_lp_Print+0xcac>
  40130c:	f9401fe3 	ldr	x3, [sp, #56]
  401310:	528003a2 	mov	w2, #0x1d                  	// #29
  401314:	b0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  401318:	91036001 	add	x1, x0, #0xd8
  40131c:	f9401be0 	ldr	x0, [sp, #48]
  401320:	d63f0060 	blr	x3
  401324:	14000000 	b	401324 <user_lp_Print+0xca8>
  401328:	910123e0 	add	x0, sp, #0x48
  40132c:	f9401fe3 	ldr	x3, [sp, #56]
  401330:	b94447e2 	ldr	w2, [sp, #1092]
  401334:	aa0003e1 	mov	x1, x0
  401338:	f9401be0 	ldr	x0, [sp, #48]
  40133c:	d63f0060 	blr	x3
  401340:	b98447e0 	ldrsw	x0, [sp, #1092]
  401344:	f9401be1 	ldr	x1, [sp, #48]
  401348:	8b000020 	add	x0, x1, x0
  40134c:	f9001be0 	str	x0, [sp, #48]
  401350:	1400000d 	b	401384 <user_lp_Print+0xd08>
  401354:	f94017e0 	ldr	x0, [sp, #40]
  401358:	d1000400 	sub	x0, x0, #0x1
  40135c:	f90017e0 	str	x0, [sp, #40]
  401360:	14000009 	b	401384 <user_lp_Print+0xd08>
  401364:	f9401fe3 	ldr	x3, [sp, #56]
  401368:	52800022 	mov	w2, #0x1                   	// #1
  40136c:	f94017e1 	ldr	x1, [sp, #40]
  401370:	f9401be0 	ldr	x0, [sp, #48]
  401374:	d63f0060 	blr	x3
  401378:	f9401be0 	ldr	x0, [sp, #48]
  40137c:	91000400 	add	x0, x0, #0x1
  401380:	f9001be0 	str	x0, [sp, #48]
  401384:	f94017e0 	ldr	x0, [sp, #40]
  401388:	91000400 	add	x0, x0, #0x1
  40138c:	f90017e0 	str	x0, [sp, #40]
  401390:	17fffcc3 	b	40069c <user_lp_Print+0x20>
  401394:	d503201f 	nop
  401398:	f9401fe3 	ldr	x3, [sp, #56]
  40139c:	52800022 	mov	w2, #0x1                   	// #1
  4013a0:	b0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  4013a4:	9103e001 	add	x1, x0, #0xf8
  4013a8:	f9401be0 	ldr	x0, [sp, #48]
  4013ac:	d63f0060 	blr	x3
  4013b0:	f9401be0 	ldr	x0, [sp, #48]
  4013b4:	91000400 	add	x0, x0, #0x1
  4013b8:	f9001be0 	str	x0, [sp, #48]
  4013bc:	d503201f 	nop
  4013c0:	f9400bf3 	ldr	x19, [sp, #16]
  4013c4:	a9407bfd 	ldp	x29, x30, [sp]
  4013c8:	9111c3ff 	add	sp, sp, #0x470
  4013cc:	d65f03c0 	ret

00000000004013d0 <user_PrintChar>:
user_PrintChar():
  4013d0:	d100c3ff 	sub	sp, sp, #0x30
  4013d4:	f9000fe0 	str	x0, [sp, #24]
  4013d8:	39005fe1 	strb	w1, [sp, #23]
  4013dc:	b90013e2 	str	w2, [sp, #16]
  4013e0:	b9000fe3 	str	w3, [sp, #12]
  4013e4:	b94013e0 	ldr	w0, [sp, #16]
  4013e8:	7100001f 	cmp	w0, #0x0
  4013ec:	5400006c 	b.gt	4013f8 <user_PrintChar+0x28>
  4013f0:	52800020 	mov	w0, #0x1                   	// #1
  4013f4:	b90013e0 	str	w0, [sp, #16]
  4013f8:	b9400fe0 	ldr	w0, [sp, #12]
  4013fc:	7100001f 	cmp	w0, #0x0
  401400:	54000280 	b.eq	401450 <user_PrintChar+0x80>  // b.none
  401404:	f9400fe0 	ldr	x0, [sp, #24]
  401408:	39405fe1 	ldrb	w1, [sp, #23]
  40140c:	39000001 	strb	w1, [x0]
  401410:	52800020 	mov	w0, #0x1                   	// #1
  401414:	b9002fe0 	str	w0, [sp, #44]
  401418:	14000009 	b	40143c <user_PrintChar+0x6c>
  40141c:	b9802fe0 	ldrsw	x0, [sp, #44]
  401420:	f9400fe1 	ldr	x1, [sp, #24]
  401424:	8b000020 	add	x0, x1, x0
  401428:	52800401 	mov	w1, #0x20                  	// #32
  40142c:	39000001 	strb	w1, [x0]
  401430:	b9402fe0 	ldr	w0, [sp, #44]
  401434:	11000400 	add	w0, w0, #0x1
  401438:	b9002fe0 	str	w0, [sp, #44]
  40143c:	b9402fe1 	ldr	w1, [sp, #44]
  401440:	b94013e0 	ldr	w0, [sp, #16]
  401444:	6b00003f 	cmp	w1, w0
  401448:	54fffeab 	b.lt	40141c <user_PrintChar+0x4c>  // b.tstop
  40144c:	14000016 	b	4014a4 <user_PrintChar+0xd4>
  401450:	b9002fff 	str	wzr, [sp, #44]
  401454:	14000009 	b	401478 <user_PrintChar+0xa8>
  401458:	b9802fe0 	ldrsw	x0, [sp, #44]
  40145c:	f9400fe1 	ldr	x1, [sp, #24]
  401460:	8b000020 	add	x0, x1, x0
  401464:	52800401 	mov	w1, #0x20                  	// #32
  401468:	39000001 	strb	w1, [x0]
  40146c:	b9402fe0 	ldr	w0, [sp, #44]
  401470:	11000400 	add	w0, w0, #0x1
  401474:	b9002fe0 	str	w0, [sp, #44]
  401478:	b94013e0 	ldr	w0, [sp, #16]
  40147c:	51000400 	sub	w0, w0, #0x1
  401480:	b9402fe1 	ldr	w1, [sp, #44]
  401484:	6b00003f 	cmp	w1, w0
  401488:	54fffe8b 	b.lt	401458 <user_PrintChar+0x88>  // b.tstop
  40148c:	b98013e0 	ldrsw	x0, [sp, #16]
  401490:	d1000400 	sub	x0, x0, #0x1
  401494:	f9400fe1 	ldr	x1, [sp, #24]
  401498:	8b000020 	add	x0, x1, x0
  40149c:	39405fe1 	ldrb	w1, [sp, #23]
  4014a0:	39000001 	strb	w1, [x0]
  4014a4:	b94013e0 	ldr	w0, [sp, #16]
  4014a8:	9100c3ff 	add	sp, sp, #0x30
  4014ac:	d65f03c0 	ret

00000000004014b0 <user_PrintString>:
user_PrintString():
  4014b0:	d100c3ff 	sub	sp, sp, #0x30
  4014b4:	f9000fe0 	str	x0, [sp, #24]
  4014b8:	f9000be1 	str	x1, [sp, #16]
  4014bc:	b9000fe2 	str	w2, [sp, #12]
  4014c0:	b9000be3 	str	w3, [sp, #8]
  4014c4:	b9002bff 	str	wzr, [sp, #40]
  4014c8:	f9400be0 	ldr	x0, [sp, #16]
  4014cc:	f90013e0 	str	x0, [sp, #32]
  4014d0:	14000004 	b	4014e0 <user_PrintString+0x30>
  4014d4:	b9402be0 	ldr	w0, [sp, #40]
  4014d8:	11000400 	add	w0, w0, #0x1
  4014dc:	b9002be0 	str	w0, [sp, #40]
  4014e0:	f94013e0 	ldr	x0, [sp, #32]
  4014e4:	91000401 	add	x1, x0, #0x1
  4014e8:	f90013e1 	str	x1, [sp, #32]
  4014ec:	39400000 	ldrb	w0, [x0]
  4014f0:	7100001f 	cmp	w0, #0x0
  4014f4:	54ffff01 	b.ne	4014d4 <user_PrintString+0x24>  // b.any
  4014f8:	b9400fe1 	ldr	w1, [sp, #12]
  4014fc:	b9402be0 	ldr	w0, [sp, #40]
  401500:	6b00003f 	cmp	w1, w0
  401504:	5400006a 	b.ge	401510 <user_PrintString+0x60>  // b.tcont
  401508:	b9402be0 	ldr	w0, [sp, #40]
  40150c:	b9000fe0 	str	w0, [sp, #12]
  401510:	b9400be0 	ldr	w0, [sp, #8]
  401514:	7100001f 	cmp	w0, #0x0
  401518:	54000440 	b.eq	4015a0 <user_PrintString+0xf0>  // b.none
  40151c:	b9002fff 	str	wzr, [sp, #44]
  401520:	1400000c 	b	401550 <user_PrintString+0xa0>
  401524:	b9802fe0 	ldrsw	x0, [sp, #44]
  401528:	f9400be1 	ldr	x1, [sp, #16]
  40152c:	8b000021 	add	x1, x1, x0
  401530:	b9802fe0 	ldrsw	x0, [sp, #44]
  401534:	f9400fe2 	ldr	x2, [sp, #24]
  401538:	8b000040 	add	x0, x2, x0
  40153c:	39400021 	ldrb	w1, [x1]
  401540:	39000001 	strb	w1, [x0]
  401544:	b9402fe0 	ldr	w0, [sp, #44]
  401548:	11000400 	add	w0, w0, #0x1
  40154c:	b9002fe0 	str	w0, [sp, #44]
  401550:	b9402fe1 	ldr	w1, [sp, #44]
  401554:	b9402be0 	ldr	w0, [sp, #40]
  401558:	6b00003f 	cmp	w1, w0
  40155c:	54fffe4b 	b.lt	401524 <user_PrintString+0x74>  // b.tstop
  401560:	b9402be0 	ldr	w0, [sp, #40]
  401564:	b9002fe0 	str	w0, [sp, #44]
  401568:	14000009 	b	40158c <user_PrintString+0xdc>
  40156c:	b9802fe0 	ldrsw	x0, [sp, #44]
  401570:	f9400fe1 	ldr	x1, [sp, #24]
  401574:	8b000020 	add	x0, x1, x0
  401578:	52800401 	mov	w1, #0x20                  	// #32
  40157c:	39000001 	strb	w1, [x0]
  401580:	b9402fe0 	ldr	w0, [sp, #44]
  401584:	11000400 	add	w0, w0, #0x1
  401588:	b9002fe0 	str	w0, [sp, #44]
  40158c:	b9402fe1 	ldr	w1, [sp, #44]
  401590:	b9400fe0 	ldr	w0, [sp, #12]
  401594:	6b00003f 	cmp	w1, w0
  401598:	54fffeab 	b.lt	40156c <user_PrintString+0xbc>  // b.tstop
  40159c:	1400002a 	b	401644 <user_PrintString+0x194>
  4015a0:	b9002fff 	str	wzr, [sp, #44]
  4015a4:	14000009 	b	4015c8 <user_PrintString+0x118>
  4015a8:	b9802fe0 	ldrsw	x0, [sp, #44]
  4015ac:	f9400fe1 	ldr	x1, [sp, #24]
  4015b0:	8b000020 	add	x0, x1, x0
  4015b4:	52800401 	mov	w1, #0x20                  	// #32
  4015b8:	39000001 	strb	w1, [x0]
  4015bc:	b9402fe0 	ldr	w0, [sp, #44]
  4015c0:	11000400 	add	w0, w0, #0x1
  4015c4:	b9002fe0 	str	w0, [sp, #44]
  4015c8:	b9400fe1 	ldr	w1, [sp, #12]
  4015cc:	b9402be0 	ldr	w0, [sp, #40]
  4015d0:	4b000020 	sub	w0, w1, w0
  4015d4:	b9402fe1 	ldr	w1, [sp, #44]
  4015d8:	6b00003f 	cmp	w1, w0
  4015dc:	54fffe6b 	b.lt	4015a8 <user_PrintString+0xf8>  // b.tstop
  4015e0:	b9400fe1 	ldr	w1, [sp, #12]
  4015e4:	b9402be0 	ldr	w0, [sp, #40]
  4015e8:	4b000020 	sub	w0, w1, w0
  4015ec:	b9002fe0 	str	w0, [sp, #44]
  4015f0:	14000011 	b	401634 <user_PrintString+0x184>
  4015f4:	b9402fe1 	ldr	w1, [sp, #44]
  4015f8:	b9400fe0 	ldr	w0, [sp, #12]
  4015fc:	4b000021 	sub	w1, w1, w0
  401600:	b9402be0 	ldr	w0, [sp, #40]
  401604:	0b000020 	add	w0, w1, w0
  401608:	93407c00 	sxtw	x0, w0
  40160c:	f9400be1 	ldr	x1, [sp, #16]
  401610:	8b000021 	add	x1, x1, x0
  401614:	b9802fe0 	ldrsw	x0, [sp, #44]
  401618:	f9400fe2 	ldr	x2, [sp, #24]
  40161c:	8b000040 	add	x0, x2, x0
  401620:	39400021 	ldrb	w1, [x1]
  401624:	39000001 	strb	w1, [x0]
  401628:	b9402fe0 	ldr	w0, [sp, #44]
  40162c:	11000400 	add	w0, w0, #0x1
  401630:	b9002fe0 	str	w0, [sp, #44]
  401634:	b9402fe1 	ldr	w1, [sp, #44]
  401638:	b9400fe0 	ldr	w0, [sp, #12]
  40163c:	6b00003f 	cmp	w1, w0
  401640:	54fffdab 	b.lt	4015f4 <user_PrintString+0x144>  // b.tstop
  401644:	b9400fe0 	ldr	w0, [sp, #12]
  401648:	9100c3ff 	add	sp, sp, #0x30
  40164c:	d65f03c0 	ret

0000000000401650 <user_PrintNum>:
user_PrintNum():
  401650:	d10143ff 	sub	sp, sp, #0x50
  401654:	f90017e0 	str	x0, [sp, #40]
  401658:	f90013e1 	str	x1, [sp, #32]
  40165c:	b9001fe2 	str	w2, [sp, #28]
  401660:	b9001be3 	str	w3, [sp, #24]
  401664:	b90017e4 	str	w4, [sp, #20]
  401668:	b90013e5 	str	w5, [sp, #16]
  40166c:	39003fe6 	strb	w6, [sp, #15]
  401670:	b9000be7 	str	w7, [sp, #8]
  401674:	b9003bff 	str	wzr, [sp, #56]
  401678:	f94017e0 	ldr	x0, [sp, #40]
  40167c:	f90027e0 	str	x0, [sp, #72]
  401680:	b9801fe1 	ldrsw	x1, [sp, #28]
  401684:	f94013e0 	ldr	x0, [sp, #32]
  401688:	9ac10802 	udiv	x2, x0, x1
  40168c:	9b017c41 	mul	x1, x2, x1
  401690:	cb010000 	sub	x0, x0, x1
  401694:	b90037e0 	str	w0, [sp, #52]
  401698:	b94037e0 	ldr	w0, [sp, #52]
  40169c:	7100241f 	cmp	w0, #0x9
  4016a0:	5400014c 	b.gt	4016c8 <user_PrintNum+0x78>
  4016a4:	b94037e0 	ldr	w0, [sp, #52]
  4016a8:	12001c01 	and	w1, w0, #0xff
  4016ac:	f94027e0 	ldr	x0, [sp, #72]
  4016b0:	91000402 	add	x2, x0, #0x1
  4016b4:	f90027e2 	str	x2, [sp, #72]
  4016b8:	1100c021 	add	w1, w1, #0x30
  4016bc:	12001c21 	and	w1, w1, #0xff
  4016c0:	39000001 	strb	w1, [x0]
  4016c4:	14000015 	b	401718 <user_PrintNum+0xc8>
  4016c8:	b9400be0 	ldr	w0, [sp, #8]
  4016cc:	7100001f 	cmp	w0, #0x0
  4016d0:	54000140 	b.eq	4016f8 <user_PrintNum+0xa8>  // b.none
  4016d4:	b94037e0 	ldr	w0, [sp, #52]
  4016d8:	12001c01 	and	w1, w0, #0xff
  4016dc:	f94027e0 	ldr	x0, [sp, #72]
  4016e0:	91000402 	add	x2, x0, #0x1
  4016e4:	f90027e2 	str	x2, [sp, #72]
  4016e8:	1100dc21 	add	w1, w1, #0x37
  4016ec:	12001c21 	and	w1, w1, #0xff
  4016f0:	39000001 	strb	w1, [x0]
  4016f4:	14000009 	b	401718 <user_PrintNum+0xc8>
  4016f8:	b94037e0 	ldr	w0, [sp, #52]
  4016fc:	12001c01 	and	w1, w0, #0xff
  401700:	f94027e0 	ldr	x0, [sp, #72]
  401704:	91000402 	add	x2, x0, #0x1
  401708:	f90027e2 	str	x2, [sp, #72]
  40170c:	11015c21 	add	w1, w1, #0x57
  401710:	12001c21 	and	w1, w1, #0xff
  401714:	39000001 	strb	w1, [x0]
  401718:	b9801fe0 	ldrsw	x0, [sp, #28]
  40171c:	f94013e1 	ldr	x1, [sp, #32]
  401720:	9ac00820 	udiv	x0, x1, x0
  401724:	f90013e0 	str	x0, [sp, #32]
  401728:	f94013e0 	ldr	x0, [sp, #32]
  40172c:	f100001f 	cmp	x0, #0x0
  401730:	54fffa81 	b.ne	401680 <user_PrintNum+0x30>  // b.any
  401734:	b9401be0 	ldr	w0, [sp, #24]
  401738:	7100001f 	cmp	w0, #0x0
  40173c:	540000c0 	b.eq	401754 <user_PrintNum+0x104>  // b.none
  401740:	f94027e0 	ldr	x0, [sp, #72]
  401744:	91000401 	add	x1, x0, #0x1
  401748:	f90027e1 	str	x1, [sp, #72]
  40174c:	528005a1 	mov	w1, #0x2d                  	// #45
  401750:	39000001 	strb	w1, [x0]
  401754:	f94027e1 	ldr	x1, [sp, #72]
  401758:	f94017e0 	ldr	x0, [sp, #40]
  40175c:	cb000020 	sub	x0, x1, x0
  401760:	b9003be0 	str	w0, [sp, #56]
  401764:	b94017e1 	ldr	w1, [sp, #20]
  401768:	b9403be0 	ldr	w0, [sp, #56]
  40176c:	6b00003f 	cmp	w1, w0
  401770:	5400006a 	b.ge	40177c <user_PrintNum+0x12c>  // b.tcont
  401774:	b9403be0 	ldr	w0, [sp, #56]
  401778:	b90017e0 	str	w0, [sp, #20]
  40177c:	b94013e0 	ldr	w0, [sp, #16]
  401780:	7100001f 	cmp	w0, #0x0
  401784:	54000060 	b.eq	401790 <user_PrintNum+0x140>  // b.none
  401788:	52800400 	mov	w0, #0x20                  	// #32
  40178c:	39003fe0 	strb	w0, [sp, #15]
  401790:	b9401be0 	ldr	w0, [sp, #24]
  401794:	7100001f 	cmp	w0, #0x0
  401798:	540003e0 	b.eq	401814 <user_PrintNum+0x1c4>  // b.none
  40179c:	b94013e0 	ldr	w0, [sp, #16]
  4017a0:	7100001f 	cmp	w0, #0x0
  4017a4:	54000381 	b.ne	401814 <user_PrintNum+0x1c4>  // b.any
  4017a8:	39403fe0 	ldrb	w0, [sp, #15]
  4017ac:	7100c01f 	cmp	w0, #0x30
  4017b0:	54000321 	b.ne	401814 <user_PrintNum+0x1c4>  // b.any
  4017b4:	b9403be0 	ldr	w0, [sp, #56]
  4017b8:	51000400 	sub	w0, w0, #0x1
  4017bc:	b90047e0 	str	w0, [sp, #68]
  4017c0:	14000009 	b	4017e4 <user_PrintNum+0x194>
  4017c4:	b98047e0 	ldrsw	x0, [sp, #68]
  4017c8:	f94017e1 	ldr	x1, [sp, #40]
  4017cc:	8b000020 	add	x0, x1, x0
  4017d0:	39403fe1 	ldrb	w1, [sp, #15]
  4017d4:	39000001 	strb	w1, [x0]
  4017d8:	b94047e0 	ldr	w0, [sp, #68]
  4017dc:	11000400 	add	w0, w0, #0x1
  4017e0:	b90047e0 	str	w0, [sp, #68]
  4017e4:	b94017e0 	ldr	w0, [sp, #20]
  4017e8:	51000400 	sub	w0, w0, #0x1
  4017ec:	b94047e1 	ldr	w1, [sp, #68]
  4017f0:	6b00003f 	cmp	w1, w0
  4017f4:	54fffe8b 	b.lt	4017c4 <user_PrintNum+0x174>  // b.tstop
  4017f8:	b98017e0 	ldrsw	x0, [sp, #20]
  4017fc:	d1000400 	sub	x0, x0, #0x1
  401800:	f94017e1 	ldr	x1, [sp, #40]
  401804:	8b000020 	add	x0, x1, x0
  401808:	528005a1 	mov	w1, #0x2d                  	// #45
  40180c:	39000001 	strb	w1, [x0]
  401810:	14000010 	b	401850 <user_PrintNum+0x200>
  401814:	b9403be0 	ldr	w0, [sp, #56]
  401818:	b90047e0 	str	w0, [sp, #68]
  40181c:	14000009 	b	401840 <user_PrintNum+0x1f0>
  401820:	b98047e0 	ldrsw	x0, [sp, #68]
  401824:	f94017e1 	ldr	x1, [sp, #40]
  401828:	8b000020 	add	x0, x1, x0
  40182c:	39403fe1 	ldrb	w1, [sp, #15]
  401830:	39000001 	strb	w1, [x0]
  401834:	b94047e0 	ldr	w0, [sp, #68]
  401838:	11000400 	add	w0, w0, #0x1
  40183c:	b90047e0 	str	w0, [sp, #68]
  401840:	b94047e1 	ldr	w1, [sp, #68]
  401844:	b94017e0 	ldr	w0, [sp, #20]
  401848:	6b00003f 	cmp	w1, w0
  40184c:	54fffeab 	b.lt	401820 <user_PrintNum+0x1d0>  // b.tstop
  401850:	b90043ff 	str	wzr, [sp, #64]
  401854:	b94013e0 	ldr	w0, [sp, #16]
  401858:	7100001f 	cmp	w0, #0x0
  40185c:	540000a0 	b.eq	401870 <user_PrintNum+0x220>  // b.none
  401860:	b9403be0 	ldr	w0, [sp, #56]
  401864:	51000400 	sub	w0, w0, #0x1
  401868:	b9003fe0 	str	w0, [sp, #60]
  40186c:	1400001d 	b	4018e0 <user_PrintNum+0x290>
  401870:	b94017e0 	ldr	w0, [sp, #20]
  401874:	51000400 	sub	w0, w0, #0x1
  401878:	b9003fe0 	str	w0, [sp, #60]
  40187c:	14000019 	b	4018e0 <user_PrintNum+0x290>
  401880:	b98043e0 	ldrsw	x0, [sp, #64]
  401884:	f94017e1 	ldr	x1, [sp, #40]
  401888:	8b000020 	add	x0, x1, x0
  40188c:	39400000 	ldrb	w0, [x0]
  401890:	3900cfe0 	strb	w0, [sp, #51]
  401894:	b9803fe0 	ldrsw	x0, [sp, #60]
  401898:	f94017e1 	ldr	x1, [sp, #40]
  40189c:	8b000021 	add	x1, x1, x0
  4018a0:	b98043e0 	ldrsw	x0, [sp, #64]
  4018a4:	f94017e2 	ldr	x2, [sp, #40]
  4018a8:	8b000040 	add	x0, x2, x0
  4018ac:	39400021 	ldrb	w1, [x1]
  4018b0:	39000001 	strb	w1, [x0]
  4018b4:	b9803fe0 	ldrsw	x0, [sp, #60]
  4018b8:	f94017e1 	ldr	x1, [sp, #40]
  4018bc:	8b000020 	add	x0, x1, x0
  4018c0:	3940cfe1 	ldrb	w1, [sp, #51]
  4018c4:	39000001 	strb	w1, [x0]
  4018c8:	b94043e0 	ldr	w0, [sp, #64]
  4018cc:	11000400 	add	w0, w0, #0x1
  4018d0:	b90043e0 	str	w0, [sp, #64]
  4018d4:	b9403fe0 	ldr	w0, [sp, #60]
  4018d8:	51000400 	sub	w0, w0, #0x1
  4018dc:	b9003fe0 	str	w0, [sp, #60]
  4018e0:	b9403fe1 	ldr	w1, [sp, #60]
  4018e4:	b94043e0 	ldr	w0, [sp, #64]
  4018e8:	6b00003f 	cmp	w1, w0
  4018ec:	54fffcac 	b.gt	401880 <user_PrintNum+0x230>
  4018f0:	b94017e0 	ldr	w0, [sp, #20]
  4018f4:	910143ff 	add	sp, sp, #0x50
  4018f8:	d65f03c0 	ret

00000000004018fc <user_myoutput>:
user_myoutput():
  4018fc:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
  401900:	910003fd 	mov	x29, sp
  401904:	f90017e0 	str	x0, [sp, #40]
  401908:	f90013e1 	str	x1, [sp, #32]
  40190c:	b9001fe2 	str	w2, [sp, #28]
  401910:	b9401fe0 	ldr	w0, [sp, #28]
  401914:	7100041f 	cmp	w0, #0x1
  401918:	540000a1 	b.ne	40192c <user_myoutput+0x30>  // b.any
  40191c:	f94013e0 	ldr	x0, [sp, #32]
  401920:	39400000 	ldrb	w0, [x0]
  401924:	7100001f 	cmp	w0, #0x0
  401928:	54000300 	b.eq	401988 <user_myoutput+0x8c>  // b.none
  40192c:	b9003fff 	str	wzr, [sp, #60]
  401930:	14000011 	b	401974 <user_myoutput+0x78>
  401934:	b9803fe0 	ldrsw	x0, [sp, #60]
  401938:	f94013e1 	ldr	x1, [sp, #32]
  40193c:	8b000020 	add	x0, x1, x0
  401940:	39400000 	ldrb	w0, [x0]
  401944:	940000ec 	bl	401cf4 <syscall_putchar>
  401948:	b9803fe0 	ldrsw	x0, [sp, #60]
  40194c:	f94013e1 	ldr	x1, [sp, #32]
  401950:	8b000020 	add	x0, x1, x0
  401954:	39400000 	ldrb	w0, [x0]
  401958:	7100281f 	cmp	w0, #0xa
  40195c:	54000061 	b.ne	401968 <user_myoutput+0x6c>  // b.any
  401960:	52800140 	mov	w0, #0xa                   	// #10
  401964:	940000e4 	bl	401cf4 <syscall_putchar>
  401968:	b9403fe0 	ldr	w0, [sp, #60]
  40196c:	11000400 	add	w0, w0, #0x1
  401970:	b9003fe0 	str	w0, [sp, #60]
  401974:	b9403fe1 	ldr	w1, [sp, #60]
  401978:	b9401fe0 	ldr	w0, [sp, #28]
  40197c:	6b00003f 	cmp	w1, w0
  401980:	54fffdab 	b.lt	401934 <user_myoutput+0x38>  // b.tstop
  401984:	14000002 	b	40198c <user_myoutput+0x90>
  401988:	d503201f 	nop
  40198c:	a8c47bfd 	ldp	x29, x30, [sp], #64
  401990:	d65f03c0 	ret

0000000000401994 <writef>:
writef():
  401994:	a9ae7bfd 	stp	x29, x30, [sp, #-288]!
  401998:	910003fd 	mov	x29, sp
  40199c:	f9001fe0 	str	x0, [sp, #56]
  4019a0:	f90077e1 	str	x1, [sp, #232]
  4019a4:	f9007be2 	str	x2, [sp, #240]
  4019a8:	f9007fe3 	str	x3, [sp, #248]
  4019ac:	f90083e4 	str	x4, [sp, #256]
  4019b0:	f90087e5 	str	x5, [sp, #264]
  4019b4:	f9008be6 	str	x6, [sp, #272]
  4019b8:	f9008fe7 	str	x7, [sp, #280]
  4019bc:	3d801be0 	str	q0, [sp, #96]
  4019c0:	3d801fe1 	str	q1, [sp, #112]
  4019c4:	3d8023e2 	str	q2, [sp, #128]
  4019c8:	3d8027e3 	str	q3, [sp, #144]
  4019cc:	3d802be4 	str	q4, [sp, #160]
  4019d0:	3d802fe5 	str	q5, [sp, #176]
  4019d4:	3d8033e6 	str	q6, [sp, #192]
  4019d8:	3d8037e7 	str	q7, [sp, #208]
  4019dc:	910483e0 	add	x0, sp, #0x120
  4019e0:	f90023e0 	str	x0, [sp, #64]
  4019e4:	910483e0 	add	x0, sp, #0x120
  4019e8:	f90027e0 	str	x0, [sp, #72]
  4019ec:	910383e0 	add	x0, sp, #0xe0
  4019f0:	f9002be0 	str	x0, [sp, #80]
  4019f4:	128006e0 	mov	w0, #0xffffffc8            	// #-56
  4019f8:	b9005be0 	str	w0, [sp, #88]
  4019fc:	12800fe0 	mov	w0, #0xffffff80            	// #-128
  401a00:	b9005fe0 	str	w0, [sp, #92]
  401a04:	910043e2 	add	x2, sp, #0x10
  401a08:	910103e3 	add	x3, sp, #0x40
  401a0c:	a9400460 	ldp	x0, x1, [x3]
  401a10:	a9000440 	stp	x0, x1, [x2]
  401a14:	a9410460 	ldp	x0, x1, [x3, #16]
  401a18:	a9010440 	stp	x0, x1, [x2, #16]
  401a1c:	910043e0 	add	x0, sp, #0x10
  401a20:	aa0003e3 	mov	x3, x0
  401a24:	f9401fe2 	ldr	x2, [sp, #56]
  401a28:	d2800001 	mov	x1, #0x0                   	// #0
  401a2c:	90000000 	adrp	x0, 401000 <user_lp_Print+0x984>
  401a30:	9123f000 	add	x0, x0, #0x8fc
  401a34:	97fffb12 	bl	40067c <user_lp_Print>
  401a38:	d503201f 	nop
  401a3c:	a8d27bfd 	ldp	x29, x30, [sp], #288
  401a40:	d65f03c0 	ret

0000000000401a44 <_user_panic>:
_user_panic():
  401a44:	a9ae7bfd 	stp	x29, x30, [sp, #-288]!
  401a48:	910003fd 	mov	x29, sp
  401a4c:	f90027e0 	str	x0, [sp, #72]
  401a50:	b90047e1 	str	w1, [sp, #68]
  401a54:	f9001fe2 	str	x2, [sp, #56]
  401a58:	f9007fe3 	str	x3, [sp, #248]
  401a5c:	f90083e4 	str	x4, [sp, #256]
  401a60:	f90087e5 	str	x5, [sp, #264]
  401a64:	f9008be6 	str	x6, [sp, #272]
  401a68:	f9008fe7 	str	x7, [sp, #280]
  401a6c:	3d801fe0 	str	q0, [sp, #112]
  401a70:	3d8023e1 	str	q1, [sp, #128]
  401a74:	3d8027e2 	str	q2, [sp, #144]
  401a78:	3d802be3 	str	q3, [sp, #160]
  401a7c:	3d802fe4 	str	q4, [sp, #176]
  401a80:	3d8033e5 	str	q5, [sp, #192]
  401a84:	3d8037e6 	str	q6, [sp, #208]
  401a88:	3d803be7 	str	q7, [sp, #224]
  401a8c:	910483e0 	add	x0, sp, #0x120
  401a90:	f9002be0 	str	x0, [sp, #80]
  401a94:	910483e0 	add	x0, sp, #0x120
  401a98:	f9002fe0 	str	x0, [sp, #88]
  401a9c:	9103c3e0 	add	x0, sp, #0xf0
  401aa0:	f90033e0 	str	x0, [sp, #96]
  401aa4:	128004e0 	mov	w0, #0xffffffd8            	// #-40
  401aa8:	b9006be0 	str	w0, [sp, #104]
  401aac:	12800fe0 	mov	w0, #0xffffff80            	// #-128
  401ab0:	b9006fe0 	str	w0, [sp, #108]
  401ab4:	b94047e2 	ldr	w2, [sp, #68]
  401ab8:	f94027e1 	ldr	x1, [sp, #72]
  401abc:	b0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  401ac0:	91040000 	add	x0, x0, #0x100
  401ac4:	97ffffb4 	bl	401994 <writef>
  401ac8:	910043e2 	add	x2, sp, #0x10
  401acc:	910143e3 	add	x3, sp, #0x50
  401ad0:	a9400460 	ldp	x0, x1, [x3]
  401ad4:	a9000440 	stp	x0, x1, [x2]
  401ad8:	a9410460 	ldp	x0, x1, [x3, #16]
  401adc:	a9010440 	stp	x0, x1, [x2, #16]
  401ae0:	910043e0 	add	x0, sp, #0x10
  401ae4:	aa0003e3 	mov	x3, x0
  401ae8:	f9401fe2 	ldr	x2, [sp, #56]
  401aec:	d2800001 	mov	x1, #0x0                   	// #0
  401af0:	90000000 	adrp	x0, 401000 <user_lp_Print+0x984>
  401af4:	9123f000 	add	x0, x0, #0x8fc
  401af8:	97fffae1 	bl	40067c <user_lp_Print>
  401afc:	b0000000 	adrp	x0, 402000 <syscall_ipc_recv+0x2c>
  401b00:	91046000 	add	x0, x0, #0x118
  401b04:	97ffffa4 	bl	401994 <writef>
  401b08:	14000000 	b	401b08 <_user_panic+0xc4>

0000000000401b0c <strlen>:
strlen():
  401b0c:	d10083ff 	sub	sp, sp, #0x20
  401b10:	f90007e0 	str	x0, [sp, #8]
  401b14:	b9001fff 	str	wzr, [sp, #28]
  401b18:	14000007 	b	401b34 <strlen+0x28>
  401b1c:	b9401fe0 	ldr	w0, [sp, #28]
  401b20:	11000400 	add	w0, w0, #0x1
  401b24:	b9001fe0 	str	w0, [sp, #28]
  401b28:	f94007e0 	ldr	x0, [sp, #8]
  401b2c:	91000400 	add	x0, x0, #0x1
  401b30:	f90007e0 	str	x0, [sp, #8]
  401b34:	f94007e0 	ldr	x0, [sp, #8]
  401b38:	39400000 	ldrb	w0, [x0]
  401b3c:	7100001f 	cmp	w0, #0x0
  401b40:	54fffee1 	b.ne	401b1c <strlen+0x10>  // b.any
  401b44:	b9401fe0 	ldr	w0, [sp, #28]
  401b48:	910083ff 	add	sp, sp, #0x20
  401b4c:	d65f03c0 	ret

0000000000401b50 <strcpy>:
strcpy():
  401b50:	d10083ff 	sub	sp, sp, #0x20
  401b54:	f90007e0 	str	x0, [sp, #8]
  401b58:	f90003e1 	str	x1, [sp]
  401b5c:	f94007e0 	ldr	x0, [sp, #8]
  401b60:	f9000fe0 	str	x0, [sp, #24]
  401b64:	d503201f 	nop
  401b68:	f94003e1 	ldr	x1, [sp]
  401b6c:	91000420 	add	x0, x1, #0x1
  401b70:	f90003e0 	str	x0, [sp]
  401b74:	f94007e0 	ldr	x0, [sp, #8]
  401b78:	91000402 	add	x2, x0, #0x1
  401b7c:	f90007e2 	str	x2, [sp, #8]
  401b80:	39400021 	ldrb	w1, [x1]
  401b84:	39000001 	strb	w1, [x0]
  401b88:	39400000 	ldrb	w0, [x0]
  401b8c:	7100001f 	cmp	w0, #0x0
  401b90:	54fffec1 	b.ne	401b68 <strcpy+0x18>  // b.any
  401b94:	f9400fe0 	ldr	x0, [sp, #24]
  401b98:	910083ff 	add	sp, sp, #0x20
  401b9c:	d65f03c0 	ret

0000000000401ba0 <strchr>:
strchr():
  401ba0:	d10043ff 	sub	sp, sp, #0x10
  401ba4:	f90007e0 	str	x0, [sp, #8]
  401ba8:	39001fe1 	strb	w1, [sp, #7]
  401bac:	1400000b 	b	401bd8 <strchr+0x38>
  401bb0:	f94007e0 	ldr	x0, [sp, #8]
  401bb4:	39400000 	ldrb	w0, [x0]
  401bb8:	39401fe1 	ldrb	w1, [sp, #7]
  401bbc:	6b00003f 	cmp	w1, w0
  401bc0:	54000061 	b.ne	401bcc <strchr+0x2c>  // b.any
  401bc4:	f94007e0 	ldr	x0, [sp, #8]
  401bc8:	14000009 	b	401bec <strchr+0x4c>
  401bcc:	f94007e0 	ldr	x0, [sp, #8]
  401bd0:	91000400 	add	x0, x0, #0x1
  401bd4:	f90007e0 	str	x0, [sp, #8]
  401bd8:	f94007e0 	ldr	x0, [sp, #8]
  401bdc:	39400000 	ldrb	w0, [x0]
  401be0:	7100001f 	cmp	w0, #0x0
  401be4:	54fffe61 	b.ne	401bb0 <strchr+0x10>  // b.any
  401be8:	d2800000 	mov	x0, #0x0                   	// #0
  401bec:	910043ff 	add	sp, sp, #0x10
  401bf0:	d65f03c0 	ret

0000000000401bf4 <memcpy>:
memcpy():
  401bf4:	d100c3ff 	sub	sp, sp, #0x30
  401bf8:	f9000fe0 	str	x0, [sp, #24]
  401bfc:	f9000be1 	str	x1, [sp, #16]
  401c00:	b9000fe2 	str	w2, [sp, #12]
  401c04:	f9400fe0 	ldr	x0, [sp, #24]
  401c08:	f90017e0 	str	x0, [sp, #40]
  401c0c:	f9400be0 	ldr	x0, [sp, #16]
  401c10:	f90013e0 	str	x0, [sp, #32]
  401c14:	14000009 	b	401c38 <memcpy+0x44>
  401c18:	f94013e1 	ldr	x1, [sp, #32]
  401c1c:	91000420 	add	x0, x1, #0x1
  401c20:	f90013e0 	str	x0, [sp, #32]
  401c24:	f94017e0 	ldr	x0, [sp, #40]
  401c28:	91000402 	add	x2, x0, #0x1
  401c2c:	f90017e2 	str	x2, [sp, #40]
  401c30:	39400021 	ldrb	w1, [x1]
  401c34:	39000001 	strb	w1, [x0]
  401c38:	b9400fe0 	ldr	w0, [sp, #12]
  401c3c:	51000401 	sub	w1, w0, #0x1
  401c40:	b9000fe1 	str	w1, [sp, #12]
  401c44:	7100001f 	cmp	w0, #0x0
  401c48:	54fffe81 	b.ne	401c18 <memcpy+0x24>  // b.any
  401c4c:	f9400fe0 	ldr	x0, [sp, #24]
  401c50:	9100c3ff 	add	sp, sp, #0x30
  401c54:	d65f03c0 	ret

0000000000401c58 <strcmp>:
strcmp():
  401c58:	d10043ff 	sub	sp, sp, #0x10
  401c5c:	f90007e0 	str	x0, [sp, #8]
  401c60:	f90003e1 	str	x1, [sp]
  401c64:	14000007 	b	401c80 <strcmp+0x28>
  401c68:	f94007e0 	ldr	x0, [sp, #8]
  401c6c:	91000400 	add	x0, x0, #0x1
  401c70:	f90007e0 	str	x0, [sp, #8]
  401c74:	f94003e0 	ldr	x0, [sp]
  401c78:	91000400 	add	x0, x0, #0x1
  401c7c:	f90003e0 	str	x0, [sp]
  401c80:	f94007e0 	ldr	x0, [sp, #8]
  401c84:	39400000 	ldrb	w0, [x0]
  401c88:	7100001f 	cmp	w0, #0x0
  401c8c:	540000e0 	b.eq	401ca8 <strcmp+0x50>  // b.none
  401c90:	f94007e0 	ldr	x0, [sp, #8]
  401c94:	39400001 	ldrb	w1, [x0]
  401c98:	f94003e0 	ldr	x0, [sp]
  401c9c:	39400000 	ldrb	w0, [x0]
  401ca0:	6b00003f 	cmp	w1, w0
  401ca4:	54fffe20 	b.eq	401c68 <strcmp+0x10>  // b.none
  401ca8:	f94007e0 	ldr	x0, [sp, #8]
  401cac:	39400001 	ldrb	w1, [x0]
  401cb0:	f94003e0 	ldr	x0, [sp]
  401cb4:	39400000 	ldrb	w0, [x0]
  401cb8:	6b00003f 	cmp	w1, w0
  401cbc:	54000062 	b.cs	401cc8 <strcmp+0x70>  // b.hs, b.nlast
  401cc0:	12800000 	mov	w0, #0xffffffff            	// #-1
  401cc4:	1400000a 	b	401cec <strcmp+0x94>
  401cc8:	f94007e0 	ldr	x0, [sp, #8]
  401ccc:	39400001 	ldrb	w1, [x0]
  401cd0:	f94003e0 	ldr	x0, [sp]
  401cd4:	39400000 	ldrb	w0, [x0]
  401cd8:	6b00003f 	cmp	w1, w0
  401cdc:	54000069 	b.ls	401ce8 <strcmp+0x90>  // b.plast
  401ce0:	52800020 	mov	w0, #0x1                   	// #1
  401ce4:	14000002 	b	401cec <strcmp+0x94>
  401ce8:	52800000 	mov	w0, #0x0                   	// #0
  401cec:	910043ff 	add	sp, sp, #0x10
  401cf0:	d65f03c0 	ret

0000000000401cf4 <syscall_putchar>:
syscall_putchar():
  401cf4:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
  401cf8:	910003fd 	mov	x29, sp
  401cfc:	39007fe0 	strb	w0, [sp, #31]
  401d00:	39407fe0 	ldrb	w0, [sp, #31]
  401d04:	d2800005 	mov	x5, #0x0                   	// #0
  401d08:	d2800004 	mov	x4, #0x0                   	// #0
  401d0c:	d2800003 	mov	x3, #0x0                   	// #0
  401d10:	d2800002 	mov	x2, #0x0                   	// #0
  401d14:	aa0003e1 	mov	x1, x0
  401d18:	d2800020 	mov	x0, #0x1                   	// #1
  401d1c:	97fffa56 	bl	400674 <msyscall>
  401d20:	a8c27bfd 	ldp	x29, x30, [sp], #32
  401d24:	d65f03c0 	ret

0000000000401d28 <syscall_getenvid>:
syscall_getenvid():
  401d28:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
  401d2c:	910003fd 	mov	x29, sp
  401d30:	d2800005 	mov	x5, #0x0                   	// #0
  401d34:	d2800004 	mov	x4, #0x0                   	// #0
  401d38:	d2800003 	mov	x3, #0x0                   	// #0
  401d3c:	d2800002 	mov	x2, #0x0                   	// #0
  401d40:	d2800001 	mov	x1, #0x0                   	// #0
  401d44:	d2800040 	mov	x0, #0x2                   	// #2
  401d48:	97fffa4b 	bl	400674 <msyscall>
  401d4c:	a8c17bfd 	ldp	x29, x30, [sp], #16
  401d50:	d65f03c0 	ret

0000000000401d54 <syscall_yield>:
syscall_yield():
  401d54:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
  401d58:	910003fd 	mov	x29, sp
  401d5c:	d2800005 	mov	x5, #0x0                   	// #0
  401d60:	d2800004 	mov	x4, #0x0                   	// #0
  401d64:	d2800003 	mov	x3, #0x0                   	// #0
  401d68:	d2800002 	mov	x2, #0x0                   	// #0
  401d6c:	d2800001 	mov	x1, #0x0                   	// #0
  401d70:	d2800060 	mov	x0, #0x3                   	// #3
  401d74:	97fffa40 	bl	400674 <msyscall>
  401d78:	d503201f 	nop
  401d7c:	a8c17bfd 	ldp	x29, x30, [sp], #16
  401d80:	d65f03c0 	ret

0000000000401d84 <syscall_env_destroy>:
syscall_env_destroy():
  401d84:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
  401d88:	910003fd 	mov	x29, sp
  401d8c:	b9001fe0 	str	w0, [sp, #28]
  401d90:	b9401fe0 	ldr	w0, [sp, #28]
  401d94:	d2800005 	mov	x5, #0x0                   	// #0
  401d98:	d2800004 	mov	x4, #0x0                   	// #0
  401d9c:	d2800003 	mov	x3, #0x0                   	// #0
  401da0:	d2800002 	mov	x2, #0x0                   	// #0
  401da4:	aa0003e1 	mov	x1, x0
  401da8:	d2800080 	mov	x0, #0x4                   	// #4
  401dac:	97fffa32 	bl	400674 <msyscall>
  401db0:	d503201f 	nop
  401db4:	a8c27bfd 	ldp	x29, x30, [sp], #32
  401db8:	d65f03c0 	ret

0000000000401dbc <syscall_set_pgfault_handler>:
syscall_set_pgfault_handler():
  401dbc:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
  401dc0:	910003fd 	mov	x29, sp
  401dc4:	b9002fe0 	str	w0, [sp, #44]
  401dc8:	f90013e1 	str	x1, [sp, #32]
  401dcc:	f9000fe2 	str	x2, [sp, #24]
  401dd0:	b9402fe0 	ldr	w0, [sp, #44]
  401dd4:	d2800005 	mov	x5, #0x0                   	// #0
  401dd8:	d2800004 	mov	x4, #0x0                   	// #0
  401ddc:	f9400fe3 	ldr	x3, [sp, #24]
  401de0:	f94013e2 	ldr	x2, [sp, #32]
  401de4:	aa0003e1 	mov	x1, x0
  401de8:	d28000a0 	mov	x0, #0x5                   	// #5
  401dec:	97fffa22 	bl	400674 <msyscall>
  401df0:	a8c37bfd 	ldp	x29, x30, [sp], #48
  401df4:	d65f03c0 	ret

0000000000401df8 <syscall_mem_alloc>:
syscall_mem_alloc():
  401df8:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
  401dfc:	910003fd 	mov	x29, sp
  401e00:	b9002fe0 	str	w0, [sp, #44]
  401e04:	f90013e1 	str	x1, [sp, #32]
  401e08:	f9000fe2 	str	x2, [sp, #24]
  401e0c:	b9402fe0 	ldr	w0, [sp, #44]
  401e10:	d2800005 	mov	x5, #0x0                   	// #0
  401e14:	d2800004 	mov	x4, #0x0                   	// #0
  401e18:	f9400fe3 	ldr	x3, [sp, #24]
  401e1c:	f94013e2 	ldr	x2, [sp, #32]
  401e20:	aa0003e1 	mov	x1, x0
  401e24:	d28000c0 	mov	x0, #0x6                   	// #6
  401e28:	97fffa13 	bl	400674 <msyscall>
  401e2c:	a8c37bfd 	ldp	x29, x30, [sp], #48
  401e30:	d65f03c0 	ret

0000000000401e34 <syscall_mem_map>:
syscall_mem_map():
  401e34:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
  401e38:	910003fd 	mov	x29, sp
  401e3c:	b9002fe0 	str	w0, [sp, #44]
  401e40:	f90013e1 	str	x1, [sp, #32]
  401e44:	b9002be2 	str	w2, [sp, #40]
  401e48:	f9000fe3 	str	x3, [sp, #24]
  401e4c:	f9000be4 	str	x4, [sp, #16]
  401e50:	b9402fe0 	ldr	w0, [sp, #44]
  401e54:	b9402be1 	ldr	w1, [sp, #40]
  401e58:	f9400be5 	ldr	x5, [sp, #16]
  401e5c:	f9400fe4 	ldr	x4, [sp, #24]
  401e60:	aa0103e3 	mov	x3, x1
  401e64:	f94013e2 	ldr	x2, [sp, #32]
  401e68:	aa0003e1 	mov	x1, x0
  401e6c:	d28000e0 	mov	x0, #0x7                   	// #7
  401e70:	97fffa01 	bl	400674 <msyscall>
  401e74:	a8c37bfd 	ldp	x29, x30, [sp], #48
  401e78:	d65f03c0 	ret

0000000000401e7c <syscall_mem_unmap>:
syscall_mem_unmap():
  401e7c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
  401e80:	910003fd 	mov	x29, sp
  401e84:	b9001fe0 	str	w0, [sp, #28]
  401e88:	f9000be1 	str	x1, [sp, #16]
  401e8c:	b9401fe0 	ldr	w0, [sp, #28]
  401e90:	d2800005 	mov	x5, #0x0                   	// #0
  401e94:	d2800004 	mov	x4, #0x0                   	// #0
  401e98:	d2800003 	mov	x3, #0x0                   	// #0
  401e9c:	f9400be2 	ldr	x2, [sp, #16]
  401ea0:	aa0003e1 	mov	x1, x0
  401ea4:	d2800100 	mov	x0, #0x8                   	// #8
  401ea8:	97fff9f3 	bl	400674 <msyscall>
  401eac:	a8c27bfd 	ldp	x29, x30, [sp], #32
  401eb0:	d65f03c0 	ret

0000000000401eb4 <syscall_env_alloc>:
syscall_env_alloc():
  401eb4:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
  401eb8:	910003fd 	mov	x29, sp
  401ebc:	d2800005 	mov	x5, #0x0                   	// #0
  401ec0:	d2800004 	mov	x4, #0x0                   	// #0
  401ec4:	d2800003 	mov	x3, #0x0                   	// #0
  401ec8:	d2800002 	mov	x2, #0x0                   	// #0
  401ecc:	d2800001 	mov	x1, #0x0                   	// #0
  401ed0:	d2800120 	mov	x0, #0x9                   	// #9
  401ed4:	97fff9e8 	bl	400674 <msyscall>
  401ed8:	a8c17bfd 	ldp	x29, x30, [sp], #16
  401edc:	d65f03c0 	ret

0000000000401ee0 <syscall_set_env_status>:
syscall_set_env_status():
  401ee0:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
  401ee4:	910003fd 	mov	x29, sp
  401ee8:	b9001fe0 	str	w0, [sp, #28]
  401eec:	b9001be1 	str	w1, [sp, #24]
  401ef0:	b9401fe0 	ldr	w0, [sp, #28]
  401ef4:	b9401be1 	ldr	w1, [sp, #24]
  401ef8:	d2800005 	mov	x5, #0x0                   	// #0
  401efc:	d2800004 	mov	x4, #0x0                   	// #0
  401f00:	d2800003 	mov	x3, #0x0                   	// #0
  401f04:	aa0103e2 	mov	x2, x1
  401f08:	aa0003e1 	mov	x1, x0
  401f0c:	d2800140 	mov	x0, #0xa                   	// #10
  401f10:	97fff9d9 	bl	400674 <msyscall>
  401f14:	a8c27bfd 	ldp	x29, x30, [sp], #32
  401f18:	d65f03c0 	ret

0000000000401f1c <syscall_set_trapframe>:
syscall_set_trapframe():
  401f1c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
  401f20:	910003fd 	mov	x29, sp
  401f24:	b9001fe0 	str	w0, [sp, #28]
  401f28:	f9000be1 	str	x1, [sp, #16]
  401f2c:	b9401fe0 	ldr	w0, [sp, #28]
  401f30:	f9400be1 	ldr	x1, [sp, #16]
  401f34:	d2800005 	mov	x5, #0x0                   	// #0
  401f38:	d2800004 	mov	x4, #0x0                   	// #0
  401f3c:	d2800003 	mov	x3, #0x0                   	// #0
  401f40:	aa0103e2 	mov	x2, x1
  401f44:	aa0003e1 	mov	x1, x0
  401f48:	d2800160 	mov	x0, #0xb                   	// #11
  401f4c:	97fff9ca 	bl	400674 <msyscall>
  401f50:	a8c27bfd 	ldp	x29, x30, [sp], #32
  401f54:	d65f03c0 	ret

0000000000401f58 <syscall_panic>:
syscall_panic():
  401f58:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
  401f5c:	910003fd 	mov	x29, sp
  401f60:	f9000fe0 	str	x0, [sp, #24]
  401f64:	f9400fe0 	ldr	x0, [sp, #24]
  401f68:	d2800005 	mov	x5, #0x0                   	// #0
  401f6c:	d2800004 	mov	x4, #0x0                   	// #0
  401f70:	d2800003 	mov	x3, #0x0                   	// #0
  401f74:	d2800002 	mov	x2, #0x0                   	// #0
  401f78:	aa0003e1 	mov	x1, x0
  401f7c:	d2800180 	mov	x0, #0xc                   	// #12
  401f80:	97fff9bd 	bl	400674 <msyscall>
  401f84:	d503201f 	nop
  401f88:	a8c27bfd 	ldp	x29, x30, [sp], #32
  401f8c:	d65f03c0 	ret

0000000000401f90 <syscall_ipc_can_send>:
syscall_ipc_can_send():
  401f90:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
  401f94:	910003fd 	mov	x29, sp
  401f98:	b9002fe0 	str	w0, [sp, #44]
  401f9c:	b9002be1 	str	w1, [sp, #40]
  401fa0:	f90013e2 	str	x2, [sp, #32]
  401fa4:	f9000fe3 	str	x3, [sp, #24]
  401fa8:	b9402fe0 	ldr	w0, [sp, #44]
  401fac:	b9402be1 	ldr	w1, [sp, #40]
  401fb0:	d2800005 	mov	x5, #0x0                   	// #0
  401fb4:	f9400fe4 	ldr	x4, [sp, #24]
  401fb8:	f94013e3 	ldr	x3, [sp, #32]
  401fbc:	aa0103e2 	mov	x2, x1
  401fc0:	aa0003e1 	mov	x1, x0
  401fc4:	d28001a0 	mov	x0, #0xd                   	// #13
  401fc8:	97fff9ab 	bl	400674 <msyscall>
  401fcc:	a8c37bfd 	ldp	x29, x30, [sp], #48
  401fd0:	d65f03c0 	ret

0000000000401fd4 <syscall_ipc_recv>:
syscall_ipc_recv():
  401fd4:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
  401fd8:	910003fd 	mov	x29, sp
  401fdc:	f9000fe0 	str	x0, [sp, #24]
  401fe0:	d2800005 	mov	x5, #0x0                   	// #0
  401fe4:	d2800004 	mov	x4, #0x0                   	// #0
  401fe8:	d2800003 	mov	x3, #0x0                   	// #0
  401fec:	d2800002 	mov	x2, #0x0                   	// #0
  401ff0:	f9400fe1 	ldr	x1, [sp, #24]
  401ff4:	d28001c0 	mov	x0, #0xe                   	// #14
  401ff8:	97fff99f 	bl	400674 <msyscall>
  401ffc:	d503201f 	nop
  402000:	a8c27bfd 	ldp	x29, x30, [sp], #32
  402004:	d65f03c0 	ret

0000000000402008 <syscall_cgetc>:
syscall_cgetc():
  402008:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
  40200c:	910003fd 	mov	x29, sp
  402010:	d2800005 	mov	x5, #0x0                   	// #0
  402014:	d2800004 	mov	x4, #0x0                   	// #0
  402018:	d2800003 	mov	x3, #0x0                   	// #0
  40201c:	d2800002 	mov	x2, #0x0                   	// #0
  402020:	d2800001 	mov	x1, #0x0                   	// #0
  402024:	d28001e0 	mov	x0, #0xf                   	// #15
  402028:	97fff993 	bl	400674 <msyscall>
  40202c:	a8c17bfd 	ldp	x29, x30, [sp], #16
  402030:	d65f03c0 	ret

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
  402050:	ffc00000 	.inst	0xffc00000 ; undefined
  402054:	0000003f 	.inst	0x0000003f ; undefined

0000000000402058 <envs>:
  402058:	ff800000 	.inst	0xff800000 ; undefined
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
