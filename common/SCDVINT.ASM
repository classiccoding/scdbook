VintSpecific:
	;; TODO is this needed?
	;; trigger interrupt on Sub CPU
	move.b	#1,$A12000
	rts
