#!/bin/sh
###############################################################################

scdimg2tile -v=1 -binpal=SCDBPAL.BIN TITLE.PNG LOAD.PNG PAUSE.PNG
scdimg2tile -v=1 -planewithmap -palfile=SCDBPAL.BIN -asmtiles=TITLE.ASM -asmmap=TITLEMAP.ASM TITLE.PNG
scdimg2tile -v=1 -planewithmap -palfile=SCDBPAL.BIN -asmtiles=LOAD.ASM -asmmap=LOADMAP.ASM LOAD.PNG
scdimg2tile -v=1 -planewithmap -palfile=SCDBPAL.BIN -asmtiles=PAUSE.ASM -asmmap=PAUSEMAP.ASM PAUSE.PNG
scdimg2tile -v=1 -planewithmap -palfile=SCDBPAL.BIN -asmtiles=PAUZE.ASM -asmmap=PAUZEMAP.ASM PAUZE.PNG
