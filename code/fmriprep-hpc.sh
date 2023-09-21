#!/bin/bash
#PBS -l walltime=24:00:00
#PBS -N fmriprep
#PBS -q normal
#PBS -l nodes=12:ppn=4

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


rm -f $logdir/cmd_fmriprep_${PBS_JOBID}.txt
touch $logdir/cmd_fmriprep_${PBS_JOBID}.txt

# make derivatives folder if it doesn't exist.
# let's keep this out of bids for now
if [ ! -d $maindir/derivatives ]; then
	mkdir -p $maindir/derivatives
fi

scratchdir=~/scratch/$projectname/fmriprep
if [ ! -d $scratchdir ]; then
	mkdir -p $scratchdir
fi

TEMPLATEFLOW_DIR=~/work/tools/templateflow
MPLCONFIGDIR_DIR=~/work/mplconfigdir
export SINGULARITYENV_TEMPLATEFLOW_HOME=/opt/templateflow
export SINGULARITYENV_MPLCONFIGDIR=/opt/mplconfigdir

for sub in ${subjects[@]}; do
	# check this list and update intendedfor to make fmpas match
	if [ $sub -eq 10317 ] || [ $sub -eq 10369 ] || [ $sub -eq 10402 ] || [ $sub -eq 10486 ] || [ $sub -eq 10541 ] || [ $sub -eq 10572 ] || [ $sub -eq 10584 ] || [ $sub -eq 10589 ] || [ $sub -eq 10691 ] || [ $sub -eq 10701 ]; then
		echo singularity run --cleanenv \
		-B ${TEMPLATEFLOW_DIR}:/opt/templateflow \
		-B ${MPLCONFIGDIR_DIR}:/opt/mplconfigdir \
		-B $maindir:/base \
		-B ~/work/tools/licenses:/opts \
		-B $scratchdir:/scratch \
		~/work/tools/fmriprep-23.1.3.simg \
		/base/bids /base/derivatives/fmriprep \
		participant --participant_label $sub \
		--stop-on-first-crash \
		--nthreads 12 \
		--me-output-echos \
		--ignore fieldmaps \
		--use-syn-sdc \
		--cifti-output 91k \
		--output-spaces fsLR fsaverage MNI152NLin6Asym \
		--bids-filter-file /base/code/fmriprep_config.json \
		--fs-license-file /opts/fs_license.txt -w /scratch >> $logdir/cmd_fmriprep_${PBS_JOBID}.txt
	else
		echo singularity run --cleanenv \
		-B ${TEMPLATEFLOW_DIR}:/opt/templateflow \
		-B ${MPLCONFIGDIR_DIR}:/opt/mplconfigdir \
		-B $maindir:/base \
		-B ~/work/tools/licenses:/opts \
		-B $scratchdir:/scratch \
		~/work/tools/fmriprep-23.1.3.simg \
		/base/bids /base/derivatives/fmriprep \
		participant --participant_label $sub \
		--stop-on-first-crash \
		--nthreads 12 \
		--me-output-echos \
		--cifti-output 91k \
		--output-spaces fsLR fsaverage MNI152NLin6Asym \
		--bids-filter-file /base/code/fmriprep_config.json \
		--fs-license-file /opts/fs_license.txt -w /scratch >> $logdir/cmd_fmriprep_${PBS_JOBID}.txt
	fi
done

torque-launch -p $logdir/chk_fmriprep_${PBS_JOBID}.txt $logdir/cmd_fmriprep_${PBS_JOBID}.txt
