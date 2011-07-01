LoadPagePalette:
	;; disable display and vint and genesis display
        move.w    #$8104,4(a6)
	;; supervisor mode and ignore all interrupts
	move    #$2700,sr

	;; vdp increment address by 1
        move.w   #$8f01,4(a6)

	clr.w	d0
	clr.l	d1
	move.b	PagePalette,d0
	mulu.w	#6,d0
	lea	StartPagePalettes(pc),a0

	;; copy the palettes to CRAM 0000
        move.l	#$c0000000,4(a6)
	move.w	(a0,d0.w),d1
	move.l	d1,(a6)
	move.w	2(a0,d0.w),d1
	move.l	d1,(a6)

        move.l	#$c0220000,4(a6)
	move.w	4(a0,d0.w),d1
	move.l	d1,(a6)

	;; vdp increment address by 2
        move.w   #$8f02,4(a6)

	;; enable display and vint and genesis display
        move.w    #$8164,4(a6)
	;; allow interrupts again
	and.w     #$F8FF,sr

	rts

StartPagePalettes:	
	dc.w	$000,$CCC,$666
	dc.w	$040,$4C4,$282
	dc.w	$EEE,$222,$AAA
EndPagePalettes:	
