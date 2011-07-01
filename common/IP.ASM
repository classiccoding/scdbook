	;; scdbook parts are 64*0x800 incrementing forward, which is why
	;;   the book info needs to be less the 64*0x800 minus one page
	;; scdbookformat limits 32*0x800 (64K) book info warning
	;; scdbookformat limits 63*0x800 (126K) book info failure
	;;   limits book to ~32K pages
	;;   limits book to ~27M bytes
	;; book index word limits total books to 0x10000 (64K) books
	;; chapter has page offset as word so limit to 0x10000 (64K) pages
	;; SCD ISO limits book size to around 500M
	;; SP program limits culmative book size to 128M
	;;   easy to switch from word to longword to allow longer ISOs
	;; SP program limits single book size to 128M
	;; page number can only handle 0x10000 (64K) pages due to word math

	;; TODO hold button to slowly go through pages
	;; TODO unicode character support

	include	CONSTANT.INC
	include	RAM.INC
	include	SCDSETUP.ASM
	include	VDPSETUP.ASM
	include RAMSETUP.ASM
	include MAINMENU.ASM
	include	SCDLOAD.ASM
	include	MAIN.ASM
	include	MAINPAUS.ASM
	include	SCDPAUSE.ASM
	include PAGEPAL.ASM
	include	LOADTOC.ASM
	include	SCDPART.ASM
	include	LOADPAGE.ASM
	include	DISPTEXT.ASM
	include	DISPLOAD.ASM
	include	DISPPAUS.ASM
	include	VDP.ASM
	include	VINT.ASM
	include SCDVINT.ASM
	include	SCDCMD.ASM
	
StartInitialTiles:
	include CURSOR.ASM
	include	TITLE.ASM
	include	LOAD.ASM
	include	PAUSE.ASM
EndInitialTiles:	

	include	TITLEMAP.ASM
	include	LOADMAP.ASM
	include	PAUSEMAP.ASM
