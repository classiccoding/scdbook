PauseA:
	;; disable display and vint and genesis display
        move.w    #$8104,4(a6)
	;; supervisor mode and ignore all interrupts
	move    #$2700,sr

	bra	StartMainMenu
