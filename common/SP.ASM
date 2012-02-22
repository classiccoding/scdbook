	include	CDBIOS.INC
	include CONSTANT.INC
	include SCDMAKE.INC

DataBookIndex			equ	-4
DataBookPart			equ	-2
DataSectorStartOffset:		equ	0
DataSectorStartLowWordOffset:	equ	2
DataSizeSectorsOffset:		equ	4
DataSizeSectorsLowWordOffset:	equ	6
DataBufferPointerOffset:	equ	8
DataSongOffset:			equ	12
DataSongLowByteOffset:		equ	13
DataHeaderBufferPointerOffset:	equ	14
DataHeaderBufferOffset:		equ	18

	;; SUB-CPU program
StartSCD:	
	;; 11 character string, start with MAIN or ends with SYS, SUB, or DAT
	;; null terminated string
	dc.b    "MAIN       ",$00
	;; version
	dc.w    $0000
	;; type
	dc.w	$0000
	;; next header, zero if no more headers
	dc.l    $00000000
	;; length of packet including header
	dc.l    (EndSCD-StartSCD)
	;; offset from beginning of header to entry point data
	dc.l    (StartUserCallData-StartSCD)
	;; work RAM size
	dc.l    $00000000
StartUserCallData:	
	;; entry point as offset
	dc.w    (StartUserCall0-StartUserCallData)
	;; no more entry points indicated by zeros
	dc.w    $0000

StartUserCall0:	

	;; sent ready for new command indication
	move.b	#$00,$FFFF800F
	
	;; set 2Mbit mode
	andi.b	#$FA,$FFFF8003

	;; always use these for a5-a6
	lea	DataHeaderBuffer(pc),a5
	lea	StartData(pc),a6

	move.b	#SCDCommandInitialize,d0
WaitInitializeCommand:
	cmp.b	$FFFF800E,d0
	bne.s	WaitInitializeCommand
	;; send ack of command (received command)
	move.b	d0,$FFFF800F

WaitEndCommand:
	tst.b	$FFFF800E
	bne.s	WaitEndCommand
	;; send ack of command (command finished)
	move.b	#$00,$FFFF800F

	;; wait for main cpu to start command
WaitStartCommand:	
	move.b	$FFFF800E,d0
	beq.s	WaitStartCommand
	;; send ack of command
	move.b	d0,$FFFF800F

	bsr.s	IssueCommand
	
	bra.s	WaitEndCommand
	
IssueCommand:
	cmpi.b	#SCDCommandLastNop,d0
	bhi.s	IssueCommandNotNop

	;; nop does: nothing!
	rts
	
IssueCommandNotNop:	
	cmpi.b	#SCDCommandLastPassThrough,d0
	bhi.s	IssueCommandNotPassThrough

	;; pass through command: send the command start to _CDBIOS
	;; this is for commands with no args, like stop/pause/unpause/etc
	andi.w	#$00FF,d0
	;; _CDBIOS ends with RTS
	jmp	_CDBIOS

IssueCommandNotPassThrough:	
	cmpi.b	#SCDCommandLoadFileStart,d0
	bhi	IssueCommandNotLoadFileStart

	move.w	$FFFF8010,d0
	move.w	#0,d1

IssueCommandReadCD:
	move.w	d0,DataBookIndex(a6)
	move.w	d1,DataBookPart(a6)
	cmpi.w	#((EndSCDFileInformationTable-StartSCDFileInformationTable)/4-1),d0
	bhi	IssueCommandNotReadCD

	;; read a file from the CD
	;; determine location to use as data buffer
	move.l	#SCDBookDataStart,DataBufferPointerOffset(a6)
	
	;; determine file information from the file information table
	;; each entry is four bytes
	;; change to longword if cross 128M boundary
	lsl.w	#2,d0
	lea	StartSCDFileInformationTable(pc),a0
	move.w	(a0,d0.w),DataSectorStartLowWordOffset(a6)
	move.w	2(a0,d0.w),DataSizeSectorsLowWordOffset(a6)

	move.l	#128,d0
	clr.l	d2
	move.w	DataBookPart(a6),d2
	beq.s	IssueCommandReadCDMaxSectors

	clr.l	d1
	move.w	SCDBookDataStart+BookDataTextTableSectorOffset,d1
	;; multiply by 64 sectors (128K)
	lsl.l	#6,d2

	move.l	d1,d3
	;; shift by 11 (aka multiply by 2048)
	lsl.l	#8,d3
	lsl.l	#3,d3
	add.l	d3,DataBufferPointerOffset(a6)

	add.l	d1,d2
	add.l	d2,DataSectorStartOffset(a6)
	
	sub.l	d2,DataSizeSectorsOffset(a6)

	sub.l	d1,d0

IssueCommandReadCDMaxSectors:

	cmp.l	DataSizeSectorsOffset(a6),d0
	bcc.s	IssueCommandReadCDMaxSectorsChecked

	move.l	d0,DataSizeSectorsOffset(a6)

IssueCommandReadCDMaxSectorsChecked:
	
	;; init CD controller
	move.w	#CDCSTOP,d0
	jsr 	_CDBIOS
	;; start read operation
	move.w	#ROMREADN,d0
	movea.l	a6,a0
	jsr	_CDBIOS

IssueCommandReadCDCheck:
	;check for data
	move.w	#CDCSTAT,d0
	jsr	_CDBIOS
	bcs.s	IssueCommandReadCDCheck

IssueCommandReadCDCheck2:
	move.w	#CDCREAD,d0
	jsr	_CDBIOS
	bcc.s	IssueCommandReadCDCheck2

IssueCommandReadCDCheck3:
	;; transfer data to word ram
	move.w	#CDCTRN,d0
	movea.l	DataBufferPointerOffset(a6),a0
	lea	DataHeaderBufferPointerOffset(a6),a1
	move.l	a5,(a1)
	jsr	_CDBIOS
	bcc.s	IssueCommandReadCDCheck3

	move.w	#CDCACK,d0
	jsr	_CDBIOS

	addi.l	#$800,DataBufferPointerOffset(a6)
	addq.l	#1,DataSectorStartOffset(a6)
	subq.l	#1,DataSizeSectorsOffset(a6)
	bne.s	IssueCommandReadCDCheck

IssueCommandNotReadCD:

	move.w	DataBookIndex(a6),d0
	move.w	d0,SCDBookDataStart+BookDataBookIndex

	move.w	DataBookPart(a6),d0
	move.w	d0,SCDBookDataStart+BookDataBookPart

	;; return word RAM to the main CPU
	ori.b	#$01,$FFFF8003
	rts
	
IssueCommandNotLoadFileStart:	
	cmpi.b	#SCDCommandLoadFilePart,d0
	bhi.s	IssueCommandNotLoadFilePart

	;; set book index and book part
	move.w	DataBookIndex(a6),d0
	move.w	$FFFF8010,d1
	bra	IssueCommandReadCD
	
IssueCommandNotLoadFilePart:
	;; no more commands left, so treating as a nop
	rts
	
	;; using words for the start sector allows nearly 128MB of files to be
	;; used.  since using CDDA songs, should not reach this limit
	;; otherwise convert to double words and adjust code that accesses
	;; table accordingly
StartSCDFileInformationTable:	
	include SCDMAKE2.INC
EndSCDFileInformationTable:	

BookIndex:	
	dc.w	0
BookPart:
	dc.w	0
	
StartData:	
DataSectorStart:	
	dc.l	16
DataSizeSectors:
	dc.l	1
DataBufferPointer:	
	dc.l	SCDBookDataStart
DataSong:
	dc.w	2
DataHeaderBufferPointer:	
	dc.l	0
DataHeaderBuffer:	
	dc.l	0
DataBackUpInit:
	dc.w	0
StartBackUpScratch:
	
EndSCD:	
