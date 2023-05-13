#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"

task=sharedreward # edit if necessary

for denoise in "none";do # "tedana"
	for ppi in 0; do # putting 0 first will indicate "activation" "VS_thr5"
		for model in 1; do
		
			for sub in `cat ${scriptdir}/newsubs.txt`; do # `ls -d ${basedir}/derivatives/fmriprep/sub-*/`

			  sub=${sub#*sub-}
			  sub=${sub%/}  

			  for mb in 1 3 6; do
				for me in 1 4; do

			  	# Manages the number of jobs and cores
			  	SCRIPTNAME=${basedir}/code/L1stats_melodic.sh
			  	NCORES=8
			  	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
			    		sleep 5s
			  	done
			  	bash $SCRIPTNAME $model $sub $mb $me $ppi $denoise &
				echo $SCRIPTNAME $model $sub $mb $me $ppi $denoise &
					sleep 1s

			    	done
			  done
			done
		done
	done
done
