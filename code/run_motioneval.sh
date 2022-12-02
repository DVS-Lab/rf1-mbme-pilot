#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"

task=sharedreward # edit if necessary


for sub in `ls -d ${basedir}/bids/sub-*/`; do

  sub=${sub#*sub-}
  sub=${sub%/}
  echo ${sub}  

  for mb in 1 3 6; do
	for me in 1 4; do
	    if [[ $me -gt 1 ]]
	    then
		BIDSDATA=${basedir}/bids/sub-${sub}/func/sub-${sub}_task-${task}_acq-mb${mb}me4_echo-2_bold.nii.gz
	    else
		BIDSDATA=${basedir}/bids/sub-${sub}/func/sub-${sub}_task-${task}_acq-mb${mb}me1_bold.nii.gz
	    fi


  	# Manages the number of jobs and cores
	OUT=${basedir}/derivatives/fsl/mcflirt/sub-${sub}/mb${mb}me${me}/
	if [ -d $OUT ]
        then
            echo "sub ${sub} mb ${mb} me ${me} already has mclfirt"
	else
	

	    mkdir -p $OUT
        
  	    NCORES=15
  	    while [ $(ps -ef | grep -v grep | grep 'mcflirt' | wc -l) -ge $NCORES ]; do
    		sleep 5s
  	    done
  	    /usr/share/fsl/6.0.4/bin/mcflirt -in $BIDSDATA -out $OUT -mats -plots -refvol 0 -rmsrel -rmsabs -spline_final &
            echo $BIDSDATA $OUT &
		    sleep 1s
        fi

    done
  done
done

