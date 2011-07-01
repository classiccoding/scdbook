ClearPlaneA:
	;; clear plane a
	move.l	#$40000003,d3
ClearPlaneSub:	
	moveq	#27,d0
ClearPlaneLoopOuter:	
        moveq	#39,d1
	move.l	d3,4(a6)
ClearPlaneLoopInner:	
        move.w  #$0000,(a6)
        dbf     d1,ClearPlaneLoopInner
	addi.l  #$00800000,d3
	dbf     d0,ClearPlaneLoopOuter
	rts


ClearPlaneB:
	;; clear plane b
	move.l	#$60000003,d3
	bra.s	ClearPlaneSub
	
	
ClearPlaneTOCA:
	;; clear plane a
	move.l	#$40000003,d3
	move.l	#$42000003,d3
ClearPlaneTOCSub:	
	moveq	#22,d0
ClearPlaneTOCLoopOuter:	
        moveq	#39,d1
	move.l	d3,4(a6)
ClearPlaneTOCLoopInner:	
        move.w  #$0000,(a6)
        dbf     d1,ClearPlaneTOCLoopInner
	addi.l  #$00800000,d3
	dbf     d0,ClearPlaneTOCLoopOuter
	rts
