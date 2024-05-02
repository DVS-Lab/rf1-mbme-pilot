#!/usr/bin/env python

import ants


fixed = ants.image_read('../derivatives/fmriprep-test4/sub-10391/func/sub-10391_task-sharedreward_acq-mb1me4_part-mag_desc-coreg_boldref.nii.gz') 
moving = ants.image_read('../masks/VS-Imanova_2mm.nii')

reg_mni2T1w = '../derivatives/fmriprep-test4/sub-10391/anat/sub-10391_from-MNI152NLin6Asym_to-T1w_mode-image_xfm.h5'
reg_bold2T1w = '../derivatives/fmriprep-test4/sub-10391/func/sub-10391_task-sharedreward_acq-mb1me4_from-boldref_to-T1w_mode-image_desc-coreg_xfm.txt'


mywarpedimage = ants.apply_transforms(
    fixed=fixed,
    moving=moving,
    imagetype=3,
    transformlist=[reg_mni2T1w, reg_bold2T1w],
    whichtoinvert=[False, True] )

mywarpedimage.to_filename('../masks/sub-10391_task-sharedreward_acq-mb1me4_space-native_roi-vs_mask.nii.gz')


antsApplyTransforms \
-i sub-experimentalSE110_T1w_space-MNI152NLin2009cAsym_preproc.nii.gz \
-r ../../../../sub-experimentalSE110/ses-pre/anat/sub-experimentalSE110_ses-pre_acq-highres_T1w.nii.gz \
-t [sub-experimentalSE110_T1w_space-MNI152NLin2009cAsym_warp.h5,1] \
-n NearestNeighbor \
-o test2.nii.gz -v 1


antsApplyTransforms -d 3 \
-i ../masks/VS-Imanova_2mm.nii \
-r ../derivatives/fmriprep-test4/sub-10391/func/sub-10391_task-sharedreward_acq-mb1me4_part-mag_desc-coreg_boldref.nii.gz \
-t ../derivatives/fmriprep-test4/sub-10391/anat/sub-10391_from-MNI152NLin6Asym_to-T1w_mode-image_xfm.h5 \
-t [../derivatives/fmriprep-test4/sub-10391/func/sub-10391_task-sharedreward_acq-mb1me4_from-boldref_to-T1w_mode-image_desc-coreg_xfm.txt, 1]
-n Linear \
-o ../masks/sub-10391_task-sharedreward_acq-mb1me4_space-native_roi-vs_mask.nii.gz

