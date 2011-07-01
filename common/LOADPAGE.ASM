LoadPage:	
	bsr.s	LoadBookPart

	;; TODO do this?
	;; ;; disable display and vint and genesis display
        ;; move.w    #$8104,4(a6)
	;; ;; supervisor mode and ignore all interrupts
	;; move    #$2700,sr

	bsr	ClearPlaneB
	bsr	ClearPlaneA

	;; display page number
	clr.l	d0
	move.w	Page,d0

	;; page is a zero based index, most people like one based page numbers
	addq.w	#1,d0

	;; want to use the second palette (darker text so doesn't stand out)
	move.w	#$2000,d1

	;; LSL uses modulo 64 for the shift count
	move.b	#16,d2

	move.l	#$40CA0003,4(a6)
	cmpi.w	#10,d0
	bcs.s	PageHas1Digit
	
	move.l	#$40C80003,4(a6)
	cmpi.w	#100,d0
	bcs.s	PageHas2Digits

	move.l	#$40C60003,4(a6)
	cmpi.w	#1000,d0
	bcs.s	PageHas3Digits

	move.l	#$40C40003,4(a6)
	cmpi.w	#10000,d0
	bcs.s	PageHas4Digits

	move.l	#$40C20003,4(a6)

	;; determine page%10000
	;; divu.w	#100000,d0
	;; lsr.l	d2,d0

PageHas5Digits:	
	;; cannot handle full 5 digits since word math: 0x10000 < 100000
	;; can only handle 65536 pages since using word math operators
	divu.w	#10000,d0
	move.b	d0,d1
	ori.b	#$30,d1
	move.w  d1,(a6)
	lsr.l	d2,d0

PageHas4Digits:	
	divu.w	#1000,d0
	move.b	d0,d1
	ori.b	#$30,d1
	move.w  d1,(a6)
	lsr.l	d2,d0

PageHas3Digits:	
	divu.w	#100,d0
	move.b	d0,d1
	ori.b	#$30,d1
	move.w  d1,(a6)
	lsr.l	d2,d0

PageHas2Digits:	
	divu.w	#10,d0
	move.b	d0,d1
	ori.b	#$30,d1
	move.w  d1,(a6)
	lsr.l	d2,d0

PageHas1Digit:
	move.b	d0,d1
	ori.b	#$30,d1
	move.w  d1,(a6)
	
	;; display the page text
	move.w	Page,d0
	lsl.w	#2,d0
	
	;; get page start byte
	move.l	(a4,d0.w),d1
	;; get next page start byte
	move.l	4(a4,d0.w),d2

	sub.l	d1,d2
	;; subtract one for dbra type loop
	subq.l	#1,d2

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

	lea	(a5,d1.l),a0

	move.l	#$41040003,d7
	;; want to use the first palette
	clr.w	d3

	bsr.s	DisplayText

	;; TODO do this?
	;; ;; enable display and vint and genesis display
        ;; move.w    #$8164,4(a6)
	;; ;; allow interrupts again
	;; and.w     #$F8FF,sr

	rts
