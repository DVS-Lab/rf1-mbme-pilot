#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

# the "type" variable below is setting a path inside the main script
for type in act; do # act ppi_seed-VS_thr5 nppi-ecn nppi-dmn
	for model in 1; do
		#for sub in fmriprep sublist; do
		#for sub in `cat ${scriptdir}/newsubs.txt`; do #`ls -d ${maindir}/derivatives/fmriprep/sub-*/`; do
		for sub in 10150; do

      	    sub=${sub#*sub-}
         	 sub=${sub%/}
          
		# Manages the number of jobs and cores
  		SCRIPTNAME=${maindir}/code/L2stats.sh
  		#NCORES=10
  		#while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
    			sleep 1s
  		#done
  		bash $SCRIPTNAME $sub $type $model &
  		#sleep 1s

		done
	done
done
