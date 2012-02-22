	include ROMSTART.ASM
StartBookInfo:
	include	PG11.ASM
StartBookText:
	incbin	PG11.TXT
	;; no need for even since scdbookformat forces text to be even length
	include ROMEND.ASM
