#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "scriptdir: ${scriptdir}"

rm -rf $scriptdir/missingFiles-warpkit.log
touch $scriptdir/missingFiles-warpkit.log

#for sub in `cat ${scriptdir}/sublist_all.txt` ; do
for sub in 12042 ; do
	for acq in mb1me1 mb1me4 mb2me4 mb3me1 mb3me1fa50 mb3me3 mb3me3ip0 mb3me4 mb3me4fa50 mb6me1 mb6me4 ; do
		script=${scriptdir}/warpkit.sh
		NCORES=5
		while [ $(ps -ef | grep -v grep | grep $script | wc -l) -ge $NCORES ]; do
			sleep 5s
		done
	   bash $script $sub $acq &
	done 
done
