	;; clear RAM
	move.w	#((EndImportantGlobalRAM-StartImportantGlobalRAM)/2-1),d0
	lea	StartImportantGlobalRAM,a0
RAMClearLoop:
	clr.w	(a0)+
	dbf	d0,RAMClearLoop

	;; set last book to a book that doesn't exist
	move.w	#$FFFF,LastBook
