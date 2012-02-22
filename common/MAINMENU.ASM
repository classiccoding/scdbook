	;; TODO could add line count to TOC book data and eliminate this file
	;; get the file count to know the limit of the files
	include	FILECNT.INC

StartMainMenu:	
	;; set TOC specific addresses
	;; similar to how the book specific addresses are setup
	lea	TOCStartInfo(pc),a2
	lea	TOCPageTableStart(pc),a4
	lea	TOCStartText(pc),a5

	bsr	ClearPlaneA
	bsr	ClearPlaneB

	lea	StartTITLEMap(pc),a0
	;; want to use third palette and use tiles starting at offset
	move.w	#($4080+(StartTITLETiles-StartInitialTiles)/32),d2
	;; set plane a with sequential map
	move.l	#$40000003,d3
        moveq	#(TITLETileHeight-1),d0
SetPlaneATitleLoopOuter:	
        moveq	#(TITLETileWidth-1),d1
	move.l	d3,4(a6)
SetPlaneATitleLoopInner:	
	clr.w	d4
	move.b	(a0)+,d4
	add.w	d2,d4
        move.w  d4,(a6)
        dbf     d1,SetPlaneATitleLoopInner
	addi.l  #$00800000,d3
	dbf     d0,SetPlaneATitleLoopOuter

	bsr	LoadTOCPage

	;; enable display and vint and genesis display
        move.w    #$8164,4(a6)
	;; allow interrupts again
	and.w     #$F8FF,sr

	btst	#SCDInitializedGlobalFlag,GlobalFlags
	bne.s	MainMenu
	
	;; send setup handshake states command
	move.b	#SCDCommandInitialize,d0
	bsr	SCDSendCommandAndWaitFull
	bset	#SCDInitializedGlobalFlag,GlobalFlags
	
MainMenu:	
	bsr	WaitForVint
	move.b	Port1Press,d0
	bne.s	MainMenuGotPort
	move.b	Port2Press,d0

	clr.l	d1
	move.w	Book,d1

MainMenuGotPort:
	btst	#bitDown,d0
	bne.s	MainMenuDown
	btst	#bitUp,d0
	bne.s	MainMenuUp
	btst	#bitRight,d0
	bne.s	MainMenuRight
	btst	#bitLeft,d0
	bne.s	MainMenuLeft
	andi.b	#(btnStart|btnA|btnB|btnC),d0
	bne	MainMenuStart
	bra.s	MainMenu

MainMenuDown:
	addq.w	#1,d1
	cmpi.w	#FileCount,d1
	bcc.s	MainMenu
	bra.s	MainMenuUpdateSelection

MainMenuUp:
	tst.w	d1
	beq.s	MainMenu
	subq.w	#1,d1
	bra.s	MainMenuUpdateSelection

MainMenuRight:
	addq.w	#1,d1
	cmpi.w	#FileCount,d1
	bcc.s	MainMenu
	;; note, already added one for check, so add only 22 now
	addi.w	#22,d1
	cmpi.w	#FileCount,d1
	bcs.s	MainMenuUpdateSelection
	move.w	#FileCount-1,d1
	bra.s	MainMenuUpdateSelection

MainMenuLeft:
	tst.w	d1
	beq.s	MainMenu
	cmpi.w	#23,d1
	bcs.s	MainMenuLeftSetZero
	subi.w	#23,d1
	bra.s	MainMenuUpdateSelection
MainMenuLeftSetZero:
	clr.w	d1
	
	;; d1.w has the new desired book
MainMenuUpdateSelection:	
	;; clear old selection
	clr.l	d0
	move.w	Book,d0
	divu.w	#23,d0
	;; save new book selection index
	move.w	d1,Book
	divu.w	#23,d1

	cmp.w	d0,d1
	bne.s	MainMenuUpdateSelectionLoadTOCPage
	
	clr.w	d0
	lsl.l	#7,d0
	addi.l	#$42040003,d0

	clr.w	d1
	lsl.l	#7,d1
	addi.l	#$42040003,d1

	move.l	d0,4(a6)
	move.w	#$0020,(a6)

	move.l	d1,4(a6)
	move.w	#$0080,(a6)

	bra	MainMenu

MainMenuUpdateSelectionLoadTOCPage:
	bsr	ClearPlaneTOCA
	bsr	LoadTOCPage

	bra	MainMenu

TOCStartInfo:
	include	TOC.ASM
TOCEndInfo:

TOCStartText:
	incbin	TOC.TXT
TOCEndText:
	even

MainMenuStart:	
