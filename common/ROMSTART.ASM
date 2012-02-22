StartOfRom:
Vectors:	dc.l $FFFE00, EntryPoint, BusError, AddressError
		dc.l IllegalInstr, ZeroDivide, ChkInstr, TrapvInstr
		dc.l PrivilegeViol, Trace, Line1010Emu,	Line1111Emu
		dc.l ErrorExcept, ErrorExcept, ErrorExcept, ErrorExcept
		dc.l ErrorExcept, ErrorExcept, ErrorExcept, ErrorExcept
		dc.l ErrorExcept, ErrorExcept, ErrorExcept, ErrorExcept
		dc.l ErrorExcept, ErrorTrap, ErrorTrap,	ErrorTrap
		dc.l HBlank, ErrorTrap, Vint, ErrorTrap
		dc.l ErrorTrap,	ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap,	ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap,	ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap,	ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap,	ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap,	ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap,	ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap,	ErrorTrap, ErrorTrap, ErrorTrap

Console:	dc.b "SEGA GENESIS    " ; Hardware system ID
		dc.b "(C)T-BV 2011.JUN" ; Release date
	;; TODO add book title to title
Title_Local:	dc.b "SCDBook ROM                                     " ; Domestic name
Title_Int:	dc.b "SCDBook ROM                                     " ; Domestic name
Serial:		dc.b "GM T-00005 -00"   ; Serial/version number
Checksum:	dc.w 0
		dc.b "J               " ; I/O support
RomStartLoc:	dc.l StartOfRom		; ROM start
RomEndLoc:	dc.l EndOfRom-1		; ROM end
RamStartLoc:	dc.l $FF0000		; RAM start
RamEndLoc:	dc.l $FFFFFF		; RAM end
		dc.l $20202020
		dc.l $20202020		; SRAM start ($200001)
		dc.l $20202020		; SRAM end ($20xxxx)
Notes:		dc.b "                                                    "
Region:		dc.b "U               " ; Region

; ===========================================================================

BusError:
AddressError:
IllegalInstr:
ZeroDivide:
ChkInstr:
TrapvInstr:
PrivilegeViol:
Trace:
Line1010Emu:
Line1111Emu:
ErrorExcept:
HBlank:
ErrorTrap:
		nop	
		nop	
		bra.s	ErrorTrap
; ===========================================================================

EntryPoint:
	include	TMSS.ASM
	include	CONSTANT.INC
	include	RAM.INC
	include	VDPSETUP.ASM
	include RAMSETUP.ASM
	;; load font, load book instead of main menu
	include	ROMLOAD.ASM
StartMainMenu:	
	include	MAIN.ASM
	include	MAINPAUS.ASM
	;; override the a button aspect of the pause menu
	include	ROMPAUSE.ASM
	include PAGEPAL.ASM
	;; ROM does not divide book into word RAM friendly chunks
	include	ROMPART.ASM
	include	LOADPAGE.ASM
	include	DISPTEXT.ASM
	include	DISPPAUS.ASM
	include	VDP.ASM
	include	VINT.ASM
	;; don't update SCD in each Vint
	include	ROMVINT.ASM
	include	FONT.ASM
	
	;; don't need title or loading images
StartInitialTiles:
	include CURSOR.ASM
	;; use pause image with main menu key
	include	PAUZE.ASM
EndInitialTiles:	

	;; use pause image with main menu key
	include	PAUZEMAP.ASM

	;; link pauze image names to pause image names
StartPauseTiles:	equ	StartPauzeTiles
StartPauseMap:		equ	StartPauzeMap
PauseTileHeight:	equ	PauzeTileHeight
PauseTileWidth:		equ	PauzeTileWidth
