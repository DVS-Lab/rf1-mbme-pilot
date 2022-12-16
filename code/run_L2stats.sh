#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

# the "type" variable below is setting a path inside the main script
for type in ppi_seed-VS_thr5; do # ppi_seed-NAcc act nppi-ecn nppi-dmn
	
	#for sub in fmriprep sublist; do
	for sub in `cat ${scriptdir}/newsubs.txt`; do #`ls -d ${maindir}/derivatives/fmriprep/sub-*/`; do

          sub=${sub#*sub-}
          sub=${sub%/}
          
		# Manages the number of jobs and cores
  	SCRIPTNAME=${maindir}/code/L2stats.sh
  	#NCORES=10
  	#while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
    		sleep 1s
  	#done
  	bash $SCRIPTNAME $sub $type &
  	#sleep 1s

	done
done
