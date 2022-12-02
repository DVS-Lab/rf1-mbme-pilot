#/usr/bin/env bash

# Example code for heudiconv and pydeface. This will get your data ready for analyses.
# This code will convert DICOMS to BIDS (PART 1). Will also deface (PART 2) and run MRIQC (PART 3).

# usage: bash prepdata.sh sub nruns
# example: bash prepdata.sh 104 3

# Notes:
# 1) containers live under /data/tools on local computer. should these relative paths and shared? YODA principles would suggest so.
# 2) other projects should use Jeff's python script for fixing the IntendedFor
# 3) aside from containers, only absolute path in whole workflow (transparent to folks who aren't allowed to access to raw data)
sourcedata=/data/sourcedata/rf1-sequence-pilot

sub=$1
cb=$2 # user must provide the intended counterbalance order

except_subs=(20022 10007 10003 10006 10008 10010 10014 10015 10026 10028 10030 10046)

for i in "${except_subs[@]}"
do
    if [ "$i" -eq "$sub" ] ; then
        echo "Exception ${sub}"
	exit 1
    fi
done


# ensure paths are correct irrespective from where user runs the script
codedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

dsroot=/data/projects/rf1-mbme-pilot

echo ${dsroot}

# make bids folder if it doesn't exist
if [ ! -d $dsroot/bids ]; then
	mkdir -p $dsroot/bids
fi

# overwrite existing
#rm -rf $dsroot/bids/sub-${sub}


# PART 1: running heudiconv and fixing fieldmaps
#/data/sourcedata/rf1-sequence-pilot/MB_ME_test_sub-0001/dicoms/9-CMRR_MB3_IP2_ME1_TR1850/resources/DICOM/files
#if [ ! -d $dsroot/bids/sub-${sub} ]; then

 echo "making bids for sub-${sub}"

	#singularity run --cleanenv \
	#-B $dsroot:/out \
	#-B $sourcedata:/sourcedata \
	#/data/tools/heudiconv-0.9.0.simg \
	#-d /sourcedata/Smith-SRA-{subject}/*/scans/*/*/DICOM/files/*.dcm \
	#-s $sub \
	#-f /out/code/heuristics.py \
	#-c dcm2niix -b --minmeta -o /out/bids --overwrite

	#heudiconv is running through python right now not singularity

	heudiconv -d ${sourcedata}/Smith-SRA-{subject}/*/scans/*/*/DICOM/files/*.dcm \
	-o ${dsroot}/bids/ \
	-f ${dsroot}/code/heuristics.py \
	-s $sub \
	-c dcm2niix \
	-b --minmeta --overwrite

#fi

# run Jeff's code to fix field map, but first correct permissions
chmod -R 777 $dsroot/bids/sub-$sub


#
## PART 2: Defacing anatomicals and date shifting to ensure compatibility with data sharing.
#
## note that you may need to install pydeface via pip or conda
bidsroot=$dsroot/bids
echo "defacing subject $sub"
pydeface ${bidsroot}/sub-${sub}/anat/sub-${sub}_T1w.nii.gz
mv -f ${bidsroot}/sub-${sub}/anat/sub-${sub}_T1w_defaced.nii.gz ${bidsroot}/sub-${sub}/anat/sub-${sub}_T1w.nii.gz
#
## shift dates on scans to reduce likelihood of re-identification
python $codedir/shiftdates.py $dsroot/bids/sub-${sub}/sub-${sub}_scans.tsv
#
#
#
## PART 3: Run MRIQC on subject
#
## make derivatives folder if it doesn't exist.
## let's keep this out of bids for now
echo "running MRIQC for subject $sub remember to clear your scratch"
if [ ! -d $dsroot/derivatives/mriqc ]; then
	mkdir -p $dsroot/derivatives/mriqc
fi


# make scratch
scratch=/data/scratch/`whoami`
if [ ! -d $scratch ]; then
	mkdir -p $scratch
fi

# no space left on device error for v0.15.2 and higher
# https://neurostars.org/t/mriqc-no-space-left-on-device-error/16187/1
# https://github.com/poldracklab/mriqc/issues/850
TEMPLATEFLOW_DIR=/data/tools/templateflow
export SINGULARITYENV_TEMPLATEFLOW_HOME=/opt/templateflow
if [ ! -d $dsroot/derivatives/mriqc/sub-${sub} ]; then
 echo "running mriqc for sub-${sub}"


	singularity run --cleanenv \
	-B ${TEMPLATEFLOW_DIR}:/opt/templateflow \
	-B $dsroot/bids:/data \
	-B $dsroot/derivatives/mriqc:/out \
	-B $scratch:/scratch \
	/data/tools/mriqc-0.16.1.simg \
	/data /out \
       participant --participant_label $sub -w /scratch

fi
#/data /out \
#participant --participant_label $sub -w /scratch


# PART 4: convert raw behavioral data into BIDS events format
cd $codedir
#matlab -nodesktop -batch "try; cd('/data/projects/rf1-sequence-pilot/code'); convertSharedReward2BIDSevents($sub,$cb);catch; end; quit"
# note: the -r option is replaced by -batch in newer versions of matlab. we're on matlab2018a...
