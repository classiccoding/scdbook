StartMainPause:
	bsr	DisplayPause
MainPause:
	bsr	WaitForVint

	move.b	Port1Press,d0
	bne.s	MainPauseGotPort
	move.b	Port2Press,d0

MainPauseGotPort:	
	btst	#bitC,d0
	bne.s	PauseC

	btst	#bitA,d0
	bne.s	PauseA

	btst	#bitRight,d0
	bne.s	PauseRight

	btst	#bitLeft,d0
	bne.s	PauseLeft

	bra.s	MainPause
	
PauseC:
	bsr	ClearPlaneB
	bra	Main

PauseRight:
	move.b	PagePalette,d0
	cmpi.b	#2,d0
	bcc.s	PauseRightMax
	addq.b	#1,d0
	bra.s	PauseRightSet
PauseRightMax
	clr.b	d0
PauseRightSet:	
	move.b	d0,PagePalette
	bsr.s	LoadPagePalette	
	bra.s	MainPause

PauseLeft:	
	move.b	PagePalette,d0
	beq.s	PauseLeftSetMax
	subq.b	#1,d0
	bra.s	PauseLeftSet
PauseLeftSetMax
	move.b	#2,d0
PauseLeftSet:	
	move.b	d0,PagePalette
	bsr.s	LoadPagePalette	
	bra.s	MainPause
