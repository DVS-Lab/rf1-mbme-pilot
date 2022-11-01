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

dsroot=/data/projects/rf1-sequence-pilot

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
