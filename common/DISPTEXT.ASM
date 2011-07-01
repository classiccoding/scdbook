	;; d7 is VDP address
	;; d3 map entry
	;; d2 number of characters minus 1
	;; a0 has character data
	;; destroys VDP address, d7, d6, d3, d2, a0
DisplayText:
	move.l	d7,4(a6)
	;; determine starting column and add a row to it
	move.l	d7,d6
	andi.l	#$007F0000,d6
	ori.l	#$00800000,d6
	
TextLoop:	
	move.b	(a0)+,d3
	cmpi.b	#$0A,d3
	beq.s	LineFeed
	cmpi.b	#$0D,d3
	beq.s	CarriageReturn

	;; display character
	move.w	d3,(a6)
	bra.s	TextDone

LineFeed:	
	andi.l	#$FF80FFFF,d7
	add.l	d6,d7
	move.l	d7,4(a6)

CarriageReturn:	
TextDone:	
	dbf	d2,TextLoop

	rts

