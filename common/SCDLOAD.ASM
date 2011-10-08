	bsr	DisplayLoading

	;; if book already loaded do not need to reload it
	move.w	Book,d0
	cmp.w	LastBook,d0
	beq.s	BookLoaded

	;; reset Chapter and Page
	move.l	#0,BookPart
	move.l	#0,Chapter

	move.w	d0,$A12010

	move.b	#SCDCommandLoadFileStart,d0
	bsr	SCDSendWordRAMCommandAndWaitFull

BookLoaded:

	bsr	ClearPlaneB

	;; set book specific addresses
	lea	BookDataStart,a2

	move.b	BookDataType(a2),d0
	beq.s	BookTypeBook

	;; book types that are not books
		
	;; set last book to a book that doesn't exist
	move.w	#$FFFF,LastBook

	jsr	ExecutableOffset(a2)

	;; disable display and vint and genesis display
        move.w    #$8104,4(a6)
	;; supervisor mode and ignore all interrupts
	move    #$2700,sr

	bra	StartMainMenu

BookTypeBook:
	move.w	Book,d0
	move.w	d0,LastBook

	lea	BookDataStart+BookDataChapterTableStart,a3
	move.l	a2,a4
	add.w	BookDataPageTableOffset(a2),a4
	move.l	a2,a5
	clr.l	d0
	move.w	BookDataTextTableSectorOffset(a2),d0
	;; shift by 11 (aka multiply by 2048)
	lsl.l	#8,d0
	lsl.l	#3,d0
	add.l	d0,a5

	bsr	LoadPage
