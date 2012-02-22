	include ROMSTART.ASM
StartBookInfo:
	include	PG11.ASM
StartBookText:
	incbin	PG11.TXT
	even
	include ROMEND.ASM
