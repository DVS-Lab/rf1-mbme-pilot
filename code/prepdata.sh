#/usr/bin/env bash

# Example code for heudiconv and pydeface. This will get your data ready for analyses.
# This code will convert DICOMS to BIDS (PART 1). Will also deface (PART 2) and run MRIQC (PART 3).

# usage: bash prepdata.sh sub nruns
# example: bash prepdata.sh 104 3

# Notes:
# 1) containers live under /data/tools on local computer. should these relative paths and shared? YODA principles would suggest so.
# 2) other projects should use Jeff's python script for fixing the IntendedFor
# 3) aside from containers, only absolute path in whole workflow (transparent to folks who aren't allowed to access to raw data)
sourcedata=/ZPOOL/data/sourcedata/sourcedata/rf1-sequence-pilot

sub=$1

# to-do: why do we skip these?
except_subs=(20022 10007 10003 10006 10008 10010 10014 10015 10026 10028 10030 10046)

for i in "${except_subs[@]}"; do
    if [ "$i" -eq "$sub" ] ; then
        echo "Exception ${sub}"
	      exit 1
    fi
done


# ensure paths are correct irrespective from where user runs the script
codedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dsroot="$(dirname "$codedir")"

# make bids folder if it doesn't exist
if [ ! -d $dsroot/bids ]; then
	mkdir -p $dsroot/bids
fi

# overwrite existing
rm -rf $dsroot/bids/sub-${sub}


# PART 1: running heudiconv and fixing fieldmaps
# to-do: need if statement for new subjects? i don't think so, but need to check and test heuristic and output
singularity run --cleanenv \
-B $dsroot:/out \
-B $sourcedata:/sourcedata \
/ZPOOL/data/tools/heudiconv-0.13.1.sif \
-d /sourcedata/Smith-RF1pilot-{subject}/*/scans/*/*/DICOM/files/*.dcm \
-o /out/bids/ \
-f /out/code/heuristics.py \
-s $sub \
-c dcm2niix \
-b --minmeta --overwrite



## PART 2: Defacing anatomicals and date shifting to ensure compatibility with data sharing.
# note that you may need to install pydeface via pip or conda
bidsroot=$dsroot/bids
echo "defacing subject $sub"
pydeface ${bidsroot}/sub-${sub}/anat/sub-${sub}_T1w.nii.gz
mv -f ${bidsroot}/sub-${sub}/anat/sub-${sub}_T1w_defaced.nii.gz ${bidsroot}/sub-${sub}/anat/sub-${sub}_T1w.nii.gz

# shift dates on scans to reduce likelihood of re-identification
python $codedir/shiftdates.py $dsroot/bids/sub-${sub}/sub-${sub}_scans.tsv


## PART 3: Run MRIQC on subject
# make derivatives folder if it doesn't exist.
# let's keep this out of bids for now
# TO-DO: this should be its own script
if [ ! -d $dsroot/derivatives/mriqc ]; then
	mkdir -p $dsroot/derivatives/mriqc
fi


# make scratch
scratch=/ZPOOL/data/scratch/`whoami`
if [ ! -d $scratch ]; then
	mkdir -p $scratch
fi

# no space left on device error for v0.15.2 and higher
# https://neurostars.org/t/mriqc-no-space-left-on-device-error/16187/1
# https://github.com/poldracklab/mriqc/issues/850
TEMPLATEFLOW_DIR=/ZPOOL/data/tools/templateflow
export SINGULARITYENV_TEMPLATEFLOW_HOME=/opt/templateflow
if [ ! -d $dsroot/derivatives/mriqc/sub-${sub} ]; then
 echo "running mriqc for sub-${sub}"

	singularity run --cleanenv \
	-B ${TEMPLATEFLOW_DIR}:/opt/templateflow \
	-B $dsroot/bids:/data \
	-B $dsroot/derivatives/mriqc:/out \
	-B $scratch:/scratch \
	/ZPOOL/data/tools/mriqc-23.1.0.simg \
	/data /out \
   participant --participant_label $sub -w /scratch

fi
