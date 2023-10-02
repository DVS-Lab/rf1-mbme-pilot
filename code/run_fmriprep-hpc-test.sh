#!/bin/bash

# ensure paths are correct
maindir=~/work/testing-Axel #this should be the only line that has to change if the rest of the script is set up correctly
scriptdir=$maindir/code


## run all subjects
#mapfile -t myArray < ${scriptdir}/sublist-all.txt

# run first 12 subjects
mapfile -t myArray < ${scriptdir}/sublist-n12.txt


ntasks=2
counter=0
while [ $counter -lt ${#myArray[@]} ]; do
	subjects=${myArray[@]:$counter:$ntasks}
	echo $subjects
	let counter=$counter+$ntasks
	qsub -v subjects="${subjects[@]}" fmriprep-hpc-test.sh
done
