WaitForVint:
        bclr    #GotVintGlobalFlag,GlobalFlags
        beq.s   WaitForVint
	rts


Vint:
	;; save registers we will use
	movem.l	d0-d1/a0-a1,-(a7)

	bsr.s	VintSpecific

	;; update Port1Hold and Port1Press
	lea	$a10003,a0
	lea	Port1Hold,a1
	bsr.s	VintUpdatePort

	;; update Port2Hold and Port2Press
	adda.w	#2,a0
	;; a6 already updated to point to Port2Hold
	bsr.s	VintUpdatePort

	;; restore registers we will use
	movem.l  (a7)+,d0-d1/a0-a1
	;; indicate we saw a vint
        bset     #GotVintGlobalFlag,GlobalFlags
        rte

	;; update port hold and port press bytes
	;; a0 port address
	;; a1 address of hold/pressed bytes
VintUpdatePort:
	;; get port1 info
        move.b   #$40,(a0)
        nop
        nop
        move.b   (a0),d0
	;; d0 has XXCBRLDU
        andi.b   #$3f,d0
        move.b   #$00,(a0)
        nop
        nop
        move.b   (a0),d1
	;; d1 has XXSARLDU
	andi.b   #$30,d1
        lsl.b    #2,d1
	or.b     d1,d0
        not.b    d0
	;; d0 now has SACBRLDU
	;; get old hold value to determine press value
	;; press value is any new button not pressed in the last update
        move.b   (a1),d1
	eor.b	 d0,d1
	and.b	 d0,d1
	;; store hold and press values
        move.b   d0,(a1)+
        move.b   d1,(a1)+

	rts
