#!/usr/bin/env bash

## python commands, but couldn't get ANTSpy working
# import ants

# fixed = ants.image_read('../derivatives/fmriprep-test4/sub-10391/func/sub-10391_task-sharedreward_acq-mb1me4_part-mag_desc-coreg_boldref.nii.gz') 
# moving = ants.image_read('../masks/VS-Imanova_2mm.nii')

# reg_mni2T1w = '../derivatives/fmriprep-test4/sub-10391/anat/sub-10391_from-MNI152NLin6Asym_to-T1w_mode-image_xfm.h5'
# reg_bold2T1w = '../derivatives/fmriprep-test4/sub-10391/func/sub-10391_task-sharedreward_acq-mb1me4_from-boldref_to-T1w_mode-image_desc-coreg_xfm.txt'

# mywarpedimage = ants.apply_transforms(
#     fixed=fixed,
#     moving=moving,
#     imagetype=3,
#     transformlist=[reg_mni2T1w, reg_bold2T1w],
#     whichtoinvert=[False, True] )

# mywarpedimage.to_filename('../masks/sub-10391_task-sharedreward_acq-mb1me4_space-native_roi-vs_mask.nii.gz')


# transssform mask to native space
antsApplyTransforms -d 3 \
-i ../masks/VS-Imanova_2mm.nii \
-r ../derivatives/fmriprep-test4/sub-10391/func/sub-10391_task-sharedreward_acq-mb1me4_part-mag_desc-coreg_boldref.nii.gz \
-t ../derivatives/fmriprep-test4/sub-10391/anat/sub-10391_from-MNI152NLin6Asym_to-T1w_mode-image_xfm.h5 \
-t [../derivatives/fmriprep-test4/sub-10391/func/sub-10391_task-sharedreward_acq-mb1me4_from-boldref_to-T1w_mode-image_desc-coreg_xfm.txt, 1] \
-n Linear \
-o ../masks/sub-10391_task-sharedreward_acq-mb1me4_space-native_roi-vs_mask.nii.gz


# threshold and binarise output
fslmaths ../masks/sub-10391_task-sharedreward_acq-mb1me4_space-native_roi-vs_mask.nii.gz -thr 0.5 -bin ../masks/sub-10391_task-sharedreward_acq-mb1me4_space-native_roi-vs_mask.nii.gz
