#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"

task=sharedreward # edit if necessary


for sub in `ls -d ${basedir}/bids/sub-*/`; do

  sub=${sub#*sub-}
  sub=${sub%/}
  echo ${sub}

  if [ "${sub}" == "10589sp" ] || [ "${sub}" == "10590sp" ] || [ "${sub}" == "10603sp" ] || [ "${sub}" == "10606sp" ] || [ "${sub}" == "10608sp" ] || [ "${sub}" == "10644sp" ] || [ "${sub}" == "10690sp" ] || [ "${sub}" == "10691sp" ] || [ "${sub}" == "10723sp" ] || [ "${sub}" == "10741sp" ] || [ "${sub}" == "10777sp" ] || [ "${sub}" == "10803sp" ]; then
    for mbme in mb2me4 mb3me1fa50 mb3me3 mb3me3ip0 mb3me4 mb3me4fa50; do
	    if [[ "$mbme" == "mb3me1fa50" ]]
	    then
		BIDSDATA=${basedir}/bids/sub-${sub}/func/sub-${sub}_task-${task}_acq-${mbme}_bold.nii.gz
	    else
		BIDSDATA=${basedir}/bids/sub-${sub}/func/sub-${sub}_task-${task}_acq-${mbme}_echo-2_bold.nii.gz
	    fi

	#reffile=sub-${basedir)/bids/sub-${sub}/func/${sub}_task-sharedreward_acq-mb${mb}me4_echo-1_part-mag_sbref.nii.gz

  	# Manages the number of jobs and cores
	OUT=${basedir}/derivatives/fsl/mcflirt/sub-${sub}/${mbme}/
	if [ -d $OUT ]
        then
            echo "sub ${sub} mb ${mb} me ${me} already has mcflirt"
	else

	    mkdir -p $OUT

  	    NCORES=15
  	    while [ $(ps -ef | grep -v grep | grep 'mcflirt' | wc -l) -ge $NCORES ]; do
    		sleep 5s
  	    done
  	    # New command: need to confirm what the reffile should be for all acqs
            #/usr/local/fsl/bin/mcflirt -in $BIDSDATA -out $OUT -mats -plots -reffile ${reffile} -rmsrel -rmsabs -spline_final &
            # Old command:
            /usr/local/fsl/bin/mcflirt -in $BIDSDATA -out $OUT -mats -plots -refvol 0 -rmsrel -rmsabs -spline_final &
            echo $BIDSDATA $OUT &
		    sleep 1s
        fi
    done

  else # Original script:
   for mb in 1 3 6; do
        for me in 1 4; do
            if [[ $me -gt 1 ]]
            then
                BIDSDATA=${basedir}/bids/sub-${sub}/func/sub-${sub}_task-${task}_acq-mb${mb}me4_echo-2_bold.nii.gz
            else
                BIDSDATA=${basedir}/bids/sub-${sub}/func/sub-${sub}_task-${task}_acq-mb${mb}me1_bold.nii.gz
            fi

        #reffile=sub-${basedir)/bids/sub-${sub}/func/${sub}_task-sharedreward_acq-mb${mb}me4_echo-1_part-mag_sbref.nii.gz

        # Manages the number of jobs and cores
        OUT=${basedir}/derivatives/fsl/mcflirt/sub-${sub}/mb${mb}me${me}/
        if [ -d $OUT ]
        then
            echo "sub ${sub} mb ${mb} me ${me} already has mcflirt"
        else

            mkdir -p $OUT

            NCORES=15
            while [ $(ps -ef | grep -v grep | grep 'mcflirt' | wc -l) -ge $NCORES ]; do
                sleep 5s
            done
	    # New command: need to confirm what the reffile should be for all acqs
            #/usr/local/fsl/bin/mcflirt -in $BIDSDATA -out $OUT -mats -plots -reffile ${reffile} -rmsrel -rmsabs -spline_final &
	    # Old command:
            /usr/local/fsl/bin/mcflirt -in $BIDSDATA -out $OUT -mats -plots -refvol 0 -rmsrel -rmsabs -spline_final &
	    echo $BIDSDATA $OUT &
                    sleep 1s
        fi

        done
    done
  fi
done

