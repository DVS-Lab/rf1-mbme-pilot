# example code for FMRIPREP
# runs FMRIPREP on input subject
# usage: bash run_fmriprep.sh sub
# example: bash run_fmriprep.sh 102

sub=$1

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"
bidsdir=$maindir/bids

# make derivatives folder if it doesn't exist.
# let's keep this out of bids for now
if [ ! -d $maindir/derivatives/fmriprep-test2 ]; then
	mkdir -p $maindir/derivatives/fmriprep-test3
fi

scratchdir=/ZPOOL/data/scratch/`whoami`
if [ ! -d $scratchdir ]; then
	mkdir -p $scratchdir
fi

# # prevent fmriprep from average phase and mag parts of the sbref images
# rm -rf ${bidsdir}/sub-*/func/sub-*_part-phase_sbref.*
# for file in `ls -1 ${bidsdir}/sub-*/func/sub-*_part-mag_sbref.*`; do
# 	mv "${file}" "${file/_part-mag/}"
# done
# rm -rf ${bidsdir}/sub-*/sub-*_scans.tsv



TEMPLATEFLOW_DIR=/ZPOOL/data/tools/templateflow
export SINGULARITYENV_TEMPLATEFLOW_HOME=/opt/templateflow
/ZPOOL/data/tools/apptainer/bin/singularity run --cleanenv \
-B ${TEMPLATEFLOW_DIR}:/opt/templateflow \
-B $maindir:/base \
-B /ZPOOL/data/tools/licenses:/opts \
-B $scratchdir:/scratch \
/ZPOOL/data/tools/fmriprep-23.2.1.simg \
/base/bids /base/derivatives/fmriprep-test3 \
participant --participant_label $sub \
--use-syn-sdc \
--me-output-echos \
--output-spaces MNI152NLin6Asym \
--bids-filter-file /base/code/fmriprep_config.json \
--fs-license-file /opts/fs_license.txt -w /scratch

# NOTE: the --use-syn-sdc option will only be applied in cases where there is not a valid fmap.
# https://neurostars.org/t/using-use-syn-sdc-with-fieldmap-data/2592/2

