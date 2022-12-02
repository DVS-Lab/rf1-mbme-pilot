#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

sourcedir=/data/sourcedata/rf1-mbme-pilot/*
DLscript=${scriptdir}/downloadXNAT.py

python $DLscript

for sub_CB in "10391 3"; do #"10017 2" "10024 2" "10035 4" "10041 6" "10043 4" "10054 1" "10059 6" "10069 1" "10074 3" "10078 2" "10080 3" "10085 5" "10094 5" "10108 2" "10125 3" "10130 4" "10136 6" "10137 5" "10142 5" "10150 6" "10154 4" "10186 5" "10188 1" "10221 1" "10166 4" "10185 2" "10198 3" "10203 4" "10223 1" "10234 1" "10296 5" "10303 6" "10318 6" "10319 5" "10320 3" "10321 5" "10363 4" "10382 6" "10416 2" "10422 1" "10438 3" "12042 2" "10391 3"; do 
        set -- $sub_CB
	sub=$1
	CB=$2
	

	script=${scriptdir}/prepdata.sh
	NCORES=4
	while [ $(ps -ef | grep -v grep | grep $script | wc -l) -ge $NCORES ]; do
		echo "made it here" $script $sub $CB
		sleep 1m
	done
        echo "Running prepdata" $script $sub $CB
	bash $script $sub $CB &
	sleep 5s

done

NCORES=8
	while [ $(ps -ef | grep -v grep | grep $script | wc -l) -ge $NCORES ]; do
		sleep 1s
	done
bash ${scriptdir}/run_motioneval.sh
python ${scriptdir}/IDoutliers.py --mriscDir "${sourcedir}/derivatives/mriqc"
bash ${scriptdir}/run_gen3colfiles.sh

