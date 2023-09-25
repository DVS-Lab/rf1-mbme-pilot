#!/bin/bash

# this script removes unecessary files that take up a ton of space.
# ideally you should run this on the cluster/HPC before copying files back to our Linux Box,
# but it should work from anywhere. no inputs/arguments required.


# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"
bidsdir=$maindir/bids
derivsdir=$maindir/derivatives

# tedana images we don't need
rm -rf $derivsdir/tedana/sub-*/sub-*/sub-*_desc-adaptiveGoodSignal_mask.nii.gz
rm -rf $derivsdir/tedana/sub-*/sub-*/sub-*_desc-ICA*.nii.gz
rm -rf $derivsdir/tedana/sub-*/sub-*/sub-*_desc-optcomAccepted_bold.nii.gz
rm -rf $derivsdir/tedana/sub-*/sub-*/sub-*_desc-optcomRejected_bold.nii.gz
rm -rf $derivsdir/tedana/sub-*/sub-*/sub-*_desc-optcom_bold.nii.gz
rm -rf $derivsdir/tedana/sub-*/sub-*/sub-*_desc-PCA*.nii.gz
rm -rf $derivsdir/tedana/sub-*/sub-*/sub-*_T2starmap.nii.gz
rm -rf $derivsdir/tedana/sub-*/sub-*/sub-*_S0map.nii.gz

# fmriprep images we don't need after tedana is run
rm -rf $derivsdir/fmriprep-syn/sub-*/func/sub-*_task-*_acq-*_echo-?_desc-preproc_bold.nii.gz
