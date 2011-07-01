LoadBookPart:
	;; current page
	move.w	Page,d0
	lsl.w	#2,d0

CalculateCurrentBookPart:	
	;; get page start byte
	move.l	(a4,d0.w),d1
	;; get next page start byte
	move.l	4(a4,d0.w),d2

	;; add book part * 2048 * 64 sectors to page start and page end
	clr.l	d3
	move.w	BookPart,d3
	;; shift by 11 (multiply by 2048)
	lsl.l	#8,d3
	lsl.l	#3,d3
	;; multiply by 64 sectors (128K)
	lsl.l	#6,d3
	;; reposition page boundaries based on byte based book part index
	sub.l	d3,d1
	sub.l	d3,d2
	;; add text table sector offset * 2048 to page end
	clr.l	d3
	move.w	BookDataTextTableSectorOffset(a2),d3
	;; shift by 11 (multiply by 2048)
	lsl.l	#8,d3
	lsl.l	#3,d3
	add.l	d3,d2
	;; see if book part needs to incremented (does not contain page end)
	cmpi.l	#$40000,d2
	bgt.s	IncrementBookPart
	;; see if book part needs to decremented (does not contain page start)
	tst.l	d1
	bge.s	LoadPageCheckBookPart

DecrementBookPart:
	subq.w	#1,BookPart
	bra.s	CalculateCurrentBookPart
	
IncrementBookPart:
	addq.w	#1,BookPart
	bra.s	CalculateCurrentBookPart
	
LoadPageCheckBookPart:	
	move.w	BookDataBookPart(a2),d0
	cmp.w	BookPart,d0
	beq.s	LoadPageOnRightBookPart
	
	bsr	DisplayLoading

	move.w	BookPart,d0
	move.w	d0,$A12010
	move.b	#SCDCommandLoadFilePart,d0
	bsr	SCDSendWordRAMCommandAndWaitFull

LoadPageOnRightBookPart:
	rts
	