DisplayLoading:	
	;; TODO do this?
	;; ;; disable display and vint and genesis display
        ;; move.w    #$8104,4(a6)
	;; ;; supervisor mode and ignore all interrupts
	;; move    #$2700,sr

	;; could make common routine between display loading and display pause
	lea	StartLOADMap(pc),a0
	;; want to use third palette and use tiles starting at an offset
	move.w	#($C080+(StartLOADTiles-StartInitialTiles)/32),d2
	;; set plane a with sequential map
	move.l	#$661C0003,d3
        moveq	#(LOADTileHeight-1),d0
SetPlaneBLoadLoopOuter:	
        moveq	#(LOADTileWidth-1),d1
	move.l	d3,4(a6)
SetPlaneBLoadLoopInner:	
	clr.w	d4
	move.b	(a0)+,d4
	add.w	d2,d4
        move.w  d4,(a6)
        dbf     d1,SetPlaneBLoadLoopInner
	addi.l  #$00800000,d3
	dbf     d0,SetPlaneBLoadLoopOuter

	;; TODO do this?
	;; ;; enable display and vint and genesis display
        ;; move.w    #$8164,4(a6)
	;; ;; allow interrupts again
	;; and.w     #$F8FF,sr

	rts
