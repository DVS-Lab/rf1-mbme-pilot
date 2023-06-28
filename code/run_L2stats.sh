#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

# the "type" variable below is setting a path inside the main script
for type in act; do #ppi_seed-VS_thr5; do # act ppi_seed-VS_thr5 nppi-ecn nppi-dmn
	for model in 1 2 3; do
		for denoising in base; do
			#for sub in fmriprep sublist; do
			for sub in `cat ${scriptdir}/newsubs.txt`; do #`ls -d ${maindir}/derivatives/fmriprep/sub-*/`; do
			#for sub in 10303 10185 10198; do

      	    	sub=${sub#*sub-}
         	 	sub=${sub%/}
          
			# Manages the number of jobs and cores
  			SCRIPTNAME=${maindir}/code/L2stats.sh
  			NCORES=15
  			while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
    				sleep 1s
  			done
  			bash $SCRIPTNAME $sub $type $model $denoising &
  			#sleep 1s

			done
		done	
	done
done
