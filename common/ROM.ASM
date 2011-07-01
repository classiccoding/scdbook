	include ROMSTART.ASM
StartBookInfo:
	include	PG11.ASM
	even
StartBookText:
	incbin	PG11.TXT
	even
	include ROMEND.ASM
