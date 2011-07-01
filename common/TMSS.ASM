        move.b  $A10001,d0
        andi.b  #$0F,d0
        beq.s   SkipSecurity
	;; move "SEGA" to TMSS register ($A14000)
        move.l  #'SEGA',$A14000
SkipSecurity:	
