LoadTOCPage:	
	;; display list
	move.l	#$42060003,d7
	clr.l	d0
	move.w	Book,d0
	divu.w	#23,d0
	lsl.w	#2,d0
	move.l	(a4,d0.w),d1
	move.l	4(a4,d0.w),d2
	clr.w	d3
	sub.l	d1,d2
	subq.l	#1,d2
	movea.l	a5,a0
	add.l	d1,a0
	bsr	DisplayText

	clr.l	d0
	move.w	Book,d0
	divu.w	#23,d0
	clr.w	d0
	lsl.l	#7,d0
	addi.l	#$42040003,d0
	move.l	d0,4(a6)
	move.w	#$0080,(a6)

	rts
