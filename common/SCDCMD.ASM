	;; possible combinations
	;;   SCDSendWordRAMCommandAndWaitFull
	;;   SCDSendCommandAndWaitFull
	;;   SCDSendCommandAndWaitHalf/SCDWaitLastHalf
	;;   SCDSendCommandNoWait/SCDWaitFull
	;;   SCDSendCommandNoWait/SCDWaitHalf/SCDWaitLastHalf

SCDSendWordRAMCommandAndWaitFull:	
	;; give sub cpu control of word RAM
	bset	#1,$A12003

	;; d0.b has command to issue SCD
SCDSendCommandAndWaitFull:	
	move.b	d0,$A1200E
SCDWaitFull:	
SCDWaitFullLoop:	
	cmp.b	$A1200F,d0
	bne.s	SCDWaitFullLoop
	move.b	#$00,$A1200E
SCDWaitLastHalf:	
SCDWaitLastHalfLoop:	
	tst.b	$A1200F
	bne.s	SCDWaitLastHalfLoop

	rts


	;; allows other things to be processed while SCD loading
	;; d0.b has command to issue SCD
SCDSendCommandAndWaitHalf:	
	move.b	d0,$A1200E
SCDWaitHalf:	
SCDWaitHalfLoop:	
	cmp.b	$A1200F,d0
	bne.s	SCDWaitHalfLoop
	move.b	#$00,$A1200E
	rts

	;; d0.b has command to issue SCD
SCDSendCommandNoWait:	
	move.b	d0,$A1200E
	rts
