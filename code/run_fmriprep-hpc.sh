#!/bin/bash


# ensure paths are correct
maindir=~/work/rf1-mbme-pilot #this should be the only line that has to change if the rest of the script is set up correctly
scriptdir=$maindir/code

for sub in `cat ${scriptdir}/newsubs_rf1-mbme-pilot.txt` ; do
	qsub fmriprep-hpc.sh $sub
done
