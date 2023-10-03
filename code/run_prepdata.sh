#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

#for sub in `cat ${scriptdir}/recentsubs_rf1-mbme-pilot.txt` ; do
for sub in 10606sp 10608sp 10704sp; do

	script=${scriptdir}/prepdata.sh
	NCORES=10
	while [ $(ps -ef | grep -v grep | grep $script | wc -l) -ge $NCORES ]; do
		sleep 5s
	done
	bash $script $sub &
	sleep 5s

done


