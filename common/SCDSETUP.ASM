	;; Load Address for VBL routine
	lea	Vint(pc),a1
	;; make appropriate change in Interrupt Jump table
	jsr     $368

	;; give sub cpu control of word RAM
	bset	#1,$A12003
