#!/bin/sh
###############################################################################

scdimg2tile -v=1 -palget TITLE.PNG LOAD.PNG PAUSE.PNG > SCDBPAL.ASM

scdimg2tile -v=1 -palfile=SCDBPAL.ASM -magicpink -map TITLE.PNG > TITLE.ASM
scdimg2tile -v=1 -palfile=SCDBPAL.ASM -magicpink -map -showmap TITLE.PNG > TITLEMAP.ASM

scdimg2tile -v=1 -palfile=SCDBPAL.ASM -magicpink -map LOAD.PNG > LOAD.ASM
scdimg2tile -v=1 -palfile=SCDBPAL.ASM -magicpink -map -showmap LOAD.PNG > LOADMAP.ASM

scdimg2tile -v=1 -palfile=SCDBPAL.ASM -magicpink -map PAUSE.PNG > PAUSE.ASM
scdimg2tile -v=1 -palfile=SCDBPAL.ASM -magicpink -map -showmap PAUSE.PNG > PAUSEMAP.ASM

scdimg2tile -v=1 -palfile=SCDBPAL.ASM -magicpink -map PAUZE.PNG > PAUZE.ASM
scdimg2tile -v=1 -palfile=SCDBPAL.ASM -magicpink -map -showmap PAUZE.PNG > PAUZEMAP.ASM

rm TMP.BIN
