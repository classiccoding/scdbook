	;; where the book data is loaded on the main CPU
BookDataStart:				equ	$00200000
	;; where the book data is loaded on the sub CPU
SCDBookDataStart:			equ	$00080000
	;; fixed offsets for book type and version
BookDataType:				equ	0
BookDataVersion:			equ	1
	;; fixed offsets for book data
BookDataBookIndex:			equ	2
BookDataBookPart:			equ	4
BookDataPageTableOffset:		equ	6
BookDataTextTableSectorOffset:		equ	8
BookDataChapterCount:			equ	10
BookDataPageCount:			equ	12
BookDataChapterTableStart:		equ	14
	;; fixed offsets for TOC data
TOCDataPageTableOffset:			equ	2
TOCDataTextTableByteStart:		equ	4
	;; fixed offsets for book executable
ExecutableOffset:			equ	2
	;; SCD initialize/nop command
SCDCommandInitialize:			equ	$01
SCDCommandNop:				equ	$01
SCDCommandLastNop:			equ	$01
	;; SCD pass through commands
SCDCommandSongStop:			equ	$02
SCDCommandSongPause:			equ	$03
SCDCommandSongUnpause:			equ	$04
SCDCommandSongScanForward:		equ	$05
SCDCommandSongScanReverse:		equ	$06
SCDCommandSongScanOff:			equ	$07
SCDCommandROMPause:			equ	$08
SCDCommandROMUnpause:			equ	$09
SCDCommandDriveOpen:			equ	$0A
SCDCommandLastPassThrough:		equ	$0A
	;; SCD code load commands
SCDCommandLoadFileStart:		equ	$0B
SCDCommandLoadFilePart:			equ	$0C
	;; port bit masks
btnStart:       equ	%10000000
btnA:           equ	%01000000
btnC:           equ	%00100000
btnB:           equ	%00010000
btnRight:       equ	%00001000
btnLeft:        equ	%00000100
btnDown:        equ	%00000010
btnUp:          equ	%00000001
	;; port bit locations
bitStart:	equ	7
bitA:		equ	6
bitC:		equ	5
bitB:		equ	4
bitRight:	equ	3
bitLeft:	equ	2
bitDown:	equ	1
bitUp:		equ	0
