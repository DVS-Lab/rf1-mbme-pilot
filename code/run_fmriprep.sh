#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"
bidsdir=$maindir/bids

#for sub  in $bidsdir/sub*; do # in 'sub-10136'; do
#for sub in 'sub-10017' 'sub-10024' 'sub-10035' 'sub-10041' 'sub-10043' 'sub-10054' 'sub-10059' 'sub-10069' 'sub-10074' 'sub-10078' 'sub-10080' 'sub-10085' 'sub-10094' 'sub-10108'; do 
#for sub in 'sub-10125' 'sub-10130' 'sub-10137' 'sub-10142' 'sub-10150' 'sub-10154' 'sub-10166' 'sub-10185' 'sub-10186'; do
#for sub in  'sub-10188' 'sub-10198' 'sub-10203' 'sub-10223' 'sub-10234' 'sub-10296' 'sub-10303' 'sub-10318' 'sub-10319' 'sub-10320' 'sub-10321' 'sub-10363' 'sub-10382'; do
for sub in 'sub-10391' 'sub-10416' 'sub-10422' 'sub-10438' 'sub-12042'; do

	sub="${sub##*/}"

	script=${scriptdir}/fmriprep.sh
	NCORES=1
	while [ $(ps -ef | grep -v grep | grep $script | wc -l) -ge $NCORES ]; do
		sleep 1s
	done
	echo $script $sub
	bash $script $sub &
	sleep 5s
done
#python ${scriptdir}/MakeConfounds.py --fmriprepDir "${scriptdir}/../derivatives/fmriprep
