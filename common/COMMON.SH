#!/bin/sh
###############################################################################

scdimg2tile -v=1 -palget TITLE.PNG LOAD.PNG PAUSE.PNG > SCDBPAL.ASM

scdimg2tile -v=1 -palfile=SCDBPAL.ASM -map TITLE.PNG > TITLE.ASM
scdimg2tile -v=1 -palfile=SCDBPAL.ASM -map -showmap TITLE.PNG > TITLEMAP.ASM

scdimg2tile -v=1 -palfile=SCDBPAL.ASM -map LOAD.PNG > LOAD.ASM
scdimg2tile -v=1 -palfile=SCDBPAL.ASM -map -showmap LOAD.PNG > LOADMAP.ASM

scdimg2tile -v=1 -palfile=SCDBPAL.ASM -map PAUSE.PNG > PAUSE.ASM
scdimg2tile -v=1 -palfile=SCDBPAL.ASM -map -showmap PAUSE.PNG > PAUSEMAP.ASM

scdimg2tile -v=1 -palfile=SCDBPAL.ASM -map PAUZE.PNG > PAUZE.ASM
scdimg2tile -v=1 -palfile=SCDBPAL.ASM -map -showmap PAUZE.PNG > PAUZEMAP.ASM

rm TMP.BIN
