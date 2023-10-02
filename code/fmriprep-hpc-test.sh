#!/bin/bash
#PBS -l walltime=6:00:00
#PBS -N fmriprep-test
#PBS -q normal
#PBS -l nodes=2:ppn=28

# load modules and go to workdir
module load fsl/6.0.2
source $FSLDIR/etc/fslconf/fsl.sh
module load singularity/3.8.5
cd $PBS_O_WORKDIR

# ensure paths are correct
projectname=testing-Axel #this should be the only line that has to change if the rest of the script is set up correctly
maindir=~/work/$projectname
scriptdir=$maindir/code
bidsdir=$maindir/bids
logdir=$maindir/logs
mkdir -p $logdir


rm -f $logdir/cmd_fmriprep_${PBS_JOBID}.txt
touch $logdir/cmd_fmriprep_${PBS_JOBID}.txt

# make derivatives folder if it doesn't exist.
# let's keep this out of bids for now
if [ ! -d $maindir/derivatives ]; then
	mkdir -p $maindir/derivatives
fi

scratchdir=~/scratch/$projectname/fmriprep-syn
if [ ! -d $scratchdir ]; then
	mkdir -p $scratchdir
fi

TEMPLATEFLOW_DIR=$maindir/templateflow
MPLCONFIGDIR_DIR=$maindir/mplconfigdir
export SINGULARITYENV_TEMPLATEFLOW_HOME=/opt/templateflow
export SINGULARITYENV_MPLCONFIGDIR=/opt/mplconfigdir

for sub in ${subjects[@]}; do
	echo singularity run --cleanenv \
	-B ${TEMPLATEFLOW_DIR}:/opt/templateflow \
	-B ${MPLCONFIGDIR_DIR}:/opt/mplconfigdir \
	-B $maindir:/base \
	-B $maindir/licenses:/opts \
	-B $scratchdir:/scratch \
	$maindir/fmriprep-23.1.4.simg \
	/base/bids /base/derivatives/fmriprep-syn \
	participant --participant_label $sub \
	--stop-on-first-crash \
	--me-output-echos \
	--ignore fieldmaps \
	--use-syn-sdc \
	--fs-no-reconall \
	--notrack \
	--bids-filter-file /base/code/fmriprep_config.json \
	--fs-license-file /opts/fs_license.txt -w /scratch >> $logdir/cmd_fmriprep_${PBS_JOBID}.txt
done

## debugging later and not necessary for Axel's tests
# --cifti-output 91k \
# --output-spaces fsLR fsaverage MNI152NLin6Asym \

torque-launch -p $logdir/chk_fmriprep_${PBS_JOBID}.txt $logdir/cmd_fmriprep_${PBS_JOBID}.txt
