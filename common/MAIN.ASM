Main:
	bsr	WaitForVint

	;; only do something on L/R press, not C press
	move.b	Port1Hold,d1
	move.b	Port1Press,d0
	bne.s	MainGotPort
	move.b	Port2Hold,d1
	move.b	Port2Press,d0

MainGotPort:

	btst	#bitStart,d0
	bne	StartMainPause

	andi.b	#(btnRight|btnLeft),d0
	beq.s	Main

	;; save the corresponding port hold to d0
	move.b	d1,d0

	btst	#bitRight,d0
	beq.s	NotRight

	btst	#bitC,d0
	beq.s	NotChapterRight

	move.w	Chapter,d1
	addq.w	#1,d1
	;; if already on last chapter, do not increment
	cmp.w	BookDataChapterCount(a2),d1
	;; use bhi to have last chapter implicit on last page
	;; use bcc to have laster chapter at start of last chapter
	bhi.s	Main
	bne.s	ChapterRightProcess
	;; when chapter = chapters, this indicates last page of book
	;; but if last chapter is one page, don't do this
	;; note last chapter is already predecremented by 1
	move.w	d1,d2
	lsl.w	#1,d2
	move.w	-2(a3,d2.w),d3
	move.w	(a3,d2.w),d4
	cmp.w	d3,d4
	bls.s	Main
	
ChapterRightProcess:	
	move.w	d1,Chapter

	lsl.w	#1,d1
	move.w	(a3,d1.w),Page

	bsr	LoadPage

	bra.s	Main

NotChapterRight:	
	move.w	Page,d1
	addq.w	#1,d1
	;; if already on last page, do not increment
	cmp.w	BookDataPageCount(a2),d1
	bcc.s	Main
	move.w	d1,Page
	
	move.w	Chapter,d2
	addq.w	#1,d2
	cmp.w	BookDataChapterCount(a2),d2
	bcc.s	DoNotIncrementChapterOnIncrementPage

	lsl.w	#1,d2
	cmp.w	(a3,d2.w),d1
	bcs.s	DoNotIncrementChapterOnIncrementPage
	
	lsr.w	#1,d2
	move.w	d2,Chapter

DoNotIncrementChapterOnIncrementPage:	

	bsr	LoadPage

	bra	Main

NotRight:	

	btst	#bitLeft,d0
	beq.s	NotLeft

	btst	#bitC,d0
	beq.s	NotChapterLeft

	;; if already page zero, do not change chapter
	tst.w	Page
	beq	Main

	move.w	Chapter,d1

	;; if in middle of chapter, go to start of current chapter
	;; so compare current chapter start page and current page
	move.w	d1,d2
	lsl.w	#1,d2
	move.w	(a3,d2.w),d2
	cmp.w	Page,d2
	bcs.s	ChapterLeftMiddleOfChapter

	;; at beginning of chapter, so can safely go to last chapter
	tst.w	d1
	
	subq.w	#1,d1
	move.w	d1,Chapter

ChapterLeftMiddleOfChapter:
	lsl.w	#1,d1
	move.w	(a3,d1.w),Page

	bsr	LoadPage

	bra	Main

NotChapterLeft:	
	move.w	Page,d1
	;; if already zero, do not change page
	beq	Main
	subq.w	#1,d1
	move.w	d1,Page

	move.w	Chapter,d2
	beq.s	DoNotDecrementChapterOnDecrementPage

	lsl.w	#1,d2
	cmp.w	(a3,d2.w),d1
	bcc.s	DoNotDecrementChapterOnDecrementPage

	lsr.w	#1,d2
	subq.w	#1,d2
	move.w	d2,Chapter

DoNotDecrementChapterOnDecrementPage:

	bsr	LoadPage

NotLeft:
	bra	Main
