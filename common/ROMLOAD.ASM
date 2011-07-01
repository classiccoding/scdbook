	;; copy game tiles over VRAM 0400
	;; load font (same as sega cd default font, mostly for ROM)
        move.l  #$44000000,4(a6)
        lea     StartFONTTiles(pc),a5
        move.w  #((EndFONTTiles-StartFONTTiles)/2-1),d5
FontCopy:
        move.w  (a5)+,d0
	move.w	d0,d1
	moveq	#3,d2
FontCopyUncompress:	
	move.w	d1,d0
	lsr.w	#1,d1
	andi.w  #$1111,d0
	move.w  d0,(a6)
	dbf	d2,FontCopyUncompress
        dbf     d5,FontCopy

	;; enable display and vint and genesis display
        move.w    #$8164,4(a6)
	;; allow interrupts again
	and.w     #$F8FF,sr

	;; set book specific addresses
	lea	StartBookInfo(pc),a2
	move.l	a2,a3
	;; if crossing word boundary, not in FF0000-FFFFFF region...
	addi.w	#BookDataChapterTableStart,a3
	move.l	a2,a4
	add.w	BookDataPageTableOffset(a2),a4
	lea	StartBookText(pc),a5

	bsr	LoadPage
