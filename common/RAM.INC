	;; for addresses greater than or equal to FF8000,
	;; use FFFFXXXX instead of 00FFXXXX to assist dumb assembers
	;; that are unaware that the 68000 uses 24 bit addresses
	;; and won't truncate the address to one word since the address is sign
	;; extended

	;; for sega cd, the F700-FDFF is already used (from what I can tell)
	;; FD00-FDFF is for the interrupt table
	;; the stack pointer starts at FD00
	;; only leaves FE00-FFFF (512 bytes) for the shorter word addresses
	

StartImportantRAM:		equ $FFFFFE00


StartImportantGlobalRAM:	equ StartImportantRAM
	;; any port 2 button currently down
Port1Hold:			equ StartImportantGlobalRAM+$0000
	;; any port 1 button that was just pressed down
Port1Press:			equ StartImportantGlobalRAM+$0001
	;; any port 2 button currently down
Port2Hold:			equ StartImportantGlobalRAM+$0002
	;; any port 2 button that was just pressed down
Port2Press:			equ StartImportantGlobalRAM+$0003
	;; last book
LastBook:			equ StartImportantGlobalRAM+$0004
	;; current book
Book:				equ StartImportantGlobalRAM+$0006
	;; current book part
BookPart:			equ StartImportantGlobalRAM+$0008
	;; current chapter
Chapter:			equ StartImportantGlobalRAM+$000A
	;; current page
Page:				equ StartImportantGlobalRAM+$000C
	;; current TOC page
TOCPage:			equ StartImportantGlobalRAM+$000E
	;; current page palette
PagePalette:			equ StartImportantGlobalRAM+$0010
	;; flags, see "bits in the GlobalFlags memory location" below
GlobalFlags:			equ StartImportantGlobalRAM+$0011
EndImportantGlobalRAM:		equ StartImportantGlobalRAM+$0012

	;; bits in the GlobalFlags memory location
	;; set when vint seen, used by WaitForVint
GotVintGlobalFlag:		equ 0
SCDInitializedGlobalFlag:	equ 1
