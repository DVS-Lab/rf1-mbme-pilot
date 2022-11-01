#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

sub=$1

datadir=$maindir/derivatives/fmriprep/sub-${sub}/func
cd $datadir

for i in `ls -1 *_bold.nii.gz`; do

	fslmaths $i -Tmean tmp_mean
	fslmaths $i -Tstd tmp_std
	fslmaths tmp_mean -div tmp_std tmp_tsnr
	fslmaths tmp_tsnr -thr 2 thr_tmp_tsnr
	max=`fslstats thr_tmp_tsnr -R | awk '{ print $2 }'`
	mean=`fslstats thr_tmp_tsnr -M`
	echo -e "$i\t mean tsnr: $mean\t max tsnr: $max"

done
