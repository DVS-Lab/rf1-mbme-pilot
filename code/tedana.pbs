#!/bin/bash
#PBS -l walltime=1:00:00
#PBS -N tedana-test
#PBS -q normal
#PBS -l nodes=1:ppn=28

# load modules and go to workdir
module load fsl/6.0.2
source $FSLDIR/etc/fslconf/fsl.sh
module load singularity/3.8.5
cd $PBS_O_WORKDIR

# ensure paths are correct
projectname=rf1-mbme-pilot #this should be the only line that has to change if the rest of the script is set up correctly
maindir=~/work/$projectname
scriptdir=$maindir/code
bidsdir=$maindir/bids
logdir=$maindir/logs
mkdir -p $logdir


rm -f $logdir/cmd_tedana_${PBS_JOBID}.txt
touch $logdir/cmd_tedana_${PBS_JOBID}.txt

for sub in ${subjects[@]}; do
	echo python $scriptdir/tedana-multi.py \
	--fmriprepDir $maindir/derivatives/fmriprep-syn/sub-${sub} \
	--bidsDir $bidsdir/sub-${sub} \
	--sub $sub >> $logdir/cmd_tedana_${PBS_JOBID}.txt
done

torque-launch -p $logdir/chk_tedana_${PBS_JOBID}.txt $logdir/cmd_tedana_${PBS_JOBID}.txt
