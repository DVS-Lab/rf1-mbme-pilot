#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"
bidsdir=$maindir/bids

for sub in 'sub-10136'; do # in $bidsdir/sub*; do 

	sub="${sub##*/}"

	script=${scriptdir}/fmriprep.sh
	NCORES=8
	while [ $(ps -ef | grep -v grep | grep $script | wc -l) -ge $NCORES ]; do
		sleep 1s
	done
	echo $script $sub
	bash $script $sub &
	sleep 5s
done
#python ${scriptdir}/MakeConfounds.py --fmriprepDir "${scriptdir}/../derivatives/fmriprep
