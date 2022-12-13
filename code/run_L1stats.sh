#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"

task=sharedreward # edit if necessary

for ppi in 0 "VS_thr5"; do # putting 0 first will indicate "activation"

	for sub in 10136; do #`cat ${scriptdir}/newsubs.txt`; do # `ls -d ${basedir}/derivatives/fmriprep/sub-*/`; do

          sub=${sub#*sub-}
          sub=${sub%/}  

	  for mb in 1 3 6; do
		for me in 1 4; do

	  	# Manages the number of jobs and cores
	  	SCRIPTNAME=${basedir}/code/L1stats.sh
	  	NCORES=8
	  	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
	    		sleep 5s
	  	done
	  	bash $SCRIPTNAME $sub $mb $me $ppi &
                echo $SCRIPTNAME $sub $mb $me $ppi &
			sleep 1s

	    done
	  done
	done
done
