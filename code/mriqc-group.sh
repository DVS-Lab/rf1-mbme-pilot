#!/bin/bash

# ensure paths are correct
projectname=rf1-mbme-pilot #this should be the only line that has to change if the rest of the script is set up correctly
maindir=/ZPOOL/data/projects/$projectname
scriptdir=$maindir/code
bidsdir=$maindir/bids


scratchdir=~/ZPOOL/data/scratch/$projectname/mriqc
if [ ! -d $scratchdir ]; then
	mkdir -p $scratchdir
fi

singularity run --cleanenv \
-B $maindir:/base \
-B $scratchdir:/scratch \
/ZPOOL/data/tools/mriqc-23.1.0.simg \
/base/bids /base/derivatives/mriqc \
group \
--modalities T1w bold \
--no-sub --notrack \
-w /scratch
