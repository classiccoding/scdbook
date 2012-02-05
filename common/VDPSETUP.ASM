	;; setup VDP

	;; supervisor mode and ignore all interrupts
	move    #$2700,sr

	;; VDP access (a6) and 4(a6)
	move.l	#$00C00000,a6
	
	move.w	#$8000,d0
	move.w	#(EndVDPSetup-StartVDPSetup-1),d1
	lea	StartVDPSetup(pc),a0
VDPSetupCopy:
	move.b	(a0)+,d0
	move.w	d0,4(a6)
	addi.w	#$0100,d0
	dbf	d1,VDPSetupCopy

	;; vdp increment address by 1
        move.w   #$8f01,4(a6)

	;; copy the palettes to CRAM 0000
        move.l	#$c0000000,4(a6)
        clr.l	d0
	;; copy palette(s)
        move.w	#((EndInitialPalette-StartInitialPalette)/2-1),d1
	lea	StartInitialPalette(pc),a0
InitialPaletteCopy:
        move.w	(a0)+,d0
	move.l	d0,(a6)
        dbf	d1,InitialPaletteCopy

	;; vdp increment address by 2
        move.w   #$8f02,4(a6)

	;; clear tiles 0-31 (VRAM 0000)
        move.l  #$40000000,4(a6)
	move.w	#(32*32/4-1),d2
InitialTilesClear:	
        move.l	#0,(a6)
        dbf	d2,InitialTilesClear

	move.w	#(EndInitialTiles-StartInitialTiles-1),d0
	;; VRAM 1000
        move.l  #$50000000,4(a6)
	lea	StartInitialTiles(pc),a0
InitialTileCopy:	
	move.l	(a0)+,(a6)
	dbf	d0,InitialTileCopy

	bra.s	EndOfFileVDPSetup

StartVDPSetup:
	;; based on sonic 1 vdp init
	dc.b $04		; VDP $80 - 8-colour mode
	dc.b $04		; VDP $81 - Megadrive mode, DMA disable
	dc.b ($C000>>10)	; VDP $82 - foreground nametable address
	dc.b ($F000>>10)	; VDP $83 - window nametable address
	dc.b ($E000>>13)	; VDP $84 - background nametable address
	dc.b ($D800>>9)		; VDP $85 - sprite table address
	dc.b 0			; VDP $86 - unused
	dc.b 0			; VDP $87 - background colour
	dc.b 0			; VDP $88 - unused
	dc.b 0			; VDP $89 - unused
	dc.b 255		; VDP $8A - HBlank register
	dc.b $00		; VDP $8B - full v scroll, cell h scroll
	dc.b $81		; VDP $8C - 40 cell display
	dc.b ($DC00>>10)	; VDP $8D - hscroll table address
	dc.b 0			; VDP $8E - unused
	dc.b 1			; VDP $8F - VDP increment
	dc.b 1			; VDP $90 - 64 cell hscroll size
	dc.b 0			; VDP $91 - window h position
	dc.b 0			; VDP $92 - window v position
EndVDPSetup:
	;; actually putting a zero byte here to keep old asmx compatible
	dc.b 0
	;; keeping even as a sanity check
	even

StartInitialPalette:
	dc.w	$000,$CCC,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	$000,$666,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	incbin	SCDBPAL.BIN
EndInitialPalette:	

EndOfFileVDPSetup:
