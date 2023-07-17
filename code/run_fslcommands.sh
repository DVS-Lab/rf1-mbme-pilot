#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"

cd ${basedir}/derivatives/tsnr/

###attempt at merging all tsnr outputs for the 19 64-channel subjects by runs first. Unsuccessful, as 4Dimages merged into a 19 input file rather than 114 inputs requisite for the ANOVA
##for sub in 10017 10024 10035 10043 10054 10059 10074 10078 10080 10108 10125 10136 10137 10142 10150 10154 10186 10188 10221; do
##	fslmerge -t tsnr_4Dimage.nii.gz sub-${sub}_acq-mb*me*_tsnr.nii.gz
#	#fslmerge -t sub_${sub}_tsnr.nii.gz sub-${sub}_acq-mb1me1_tsnr.nii.gz sub-${sub}_acq-mb1me4_tsnr.nii.gz sub-${sub}_acq-mb3me1_tsnr.nii.gz sub-${sub}_acq-mb3me4_tsnr.nii.gz sub-${sub}_acq-mb6me1_tsnr.nii.gz sub-${sub}_acq-mb6me4_tsnr.nii.gz
##	echo "Merged ${sub}"	
#	#fslmaths sub-${sub}_tsnr.nii.gz -nan sub-${sub}_tsnr_nan.nii.gz
##	echo "NaNs removed"
##done


#START HERE - Upon obtaining tsnr 3D data from each of the 6 runs of the 19 (64-channel headcoil) subjects, the following steps are used to look at effect of tsnr across Multiband, Multiecho, and an interaction of the two


##merge all runs of each subject into a single 4D image of tsnr
#fslmerge -t tsnr_4Dimage.nii.gz sub-10017_acq-mb1me1_tsnr.nii.gz sub-10017_acq-mb1me4_tsnr.nii.gz sub-10017_acq-mb3me1_tsnr.nii.gz sub-10017_acq-mb3me4_tsnr.nii.gz sub-10017_acq-mb6me1_tsnr.nii.gz sub-10017_acq-mb6me4_tsnr.nii.gz sub-10024_acq-mb1me1_tsnr.nii.gz sub-10024_acq-mb1me4_tsnr.nii.gz sub-10024_acq-mb3me1_tsnr.nii.gz sub-10024_acq-mb3me4_tsnr.nii.gz sub-10024_acq-mb6me1_tsnr.nii.gz sub-10024_acq-mb6me4_tsnr.nii.gz sub-10035_acq-mb1me1_tsnr.nii.gz sub-10035_acq-mb1me4_tsnr.nii.gz sub-10035_acq-mb3me1_tsnr.nii.gz sub-10035_acq-mb3me4_tsnr.nii.gz sub-10035_acq-mb6me1_tsnr.nii.gz sub-10035_acq-mb6me4_tsnr.nii.gz sub-10043_acq-mb1me1_tsnr.nii.gz sub-10043_acq-mb1me4_tsnr.nii.gz sub-10043_acq-mb3me1_tsnr.nii.gz sub-10043_acq-mb3me4_tsnr.nii.gz sub-10043_acq-mb6me1_tsnr.nii.gz sub-10043_acq-mb6me4_tsnr.nii.gz sub-10054_acq-mb1me1_tsnr.nii.gz sub-10054_acq-mb1me4_tsnr.nii.gz sub-10054_acq-mb3me1_tsnr.nii.gz sub-10054_acq-mb3me4_tsnr.nii.gz sub-10054_acq-mb6me1_tsnr.nii.gz sub-10054_acq-mb6me4_tsnr.nii.gz sub-10059_acq-mb1me1_tsnr.nii.gz sub-10059_acq-mb1me4_tsnr.nii.gz sub-10059_acq-mb3me1_tsnr.nii.gz sub-10059_acq-mb3me4_tsnr.nii.gz sub-10059_acq-mb6me1_tsnr.nii.gz sub-10059_acq-mb6me4_tsnr.nii.gz sub-10074_acq-mb1me1_tsnr.nii.gz sub-10074_acq-mb1me4_tsnr.nii.gz sub-10074_acq-mb3me1_tsnr.nii.gz sub-10074_acq-mb3me4_tsnr.nii.gz sub-10074_acq-mb6me1_tsnr.nii.gz sub-10074_acq-mb6me4_tsnr.nii.gz sub-10078_acq-mb1me1_tsnr.nii.gz sub-10078_acq-mb1me4_tsnr.nii.gz sub-10078_acq-mb3me1_tsnr.nii.gz sub-10078_acq-mb3me4_tsnr.nii.gz sub-10078_acq-mb6me1_tsnr.nii.gz sub-10078_acq-mb6me4_tsnr.nii.gz sub-10080_acq-mb1me1_tsnr.nii.gz sub-10080_acq-mb1me4_tsnr.nii.gz sub-10080_acq-mb3me1_tsnr.nii.gz sub-10080_acq-mb3me4_tsnr.nii.gz sub-10080_acq-mb6me1_tsnr.nii.gz sub-10080_acq-mb6me4_tsnr.nii.gz sub-10108_acq-mb1me1_tsnr.nii.gz sub-10108_acq-mb1me4_tsnr.nii.gz sub-10108_acq-mb3me1_tsnr.nii.gz sub-10108_acq-mb3me4_tsnr.nii.gz sub-10108_acq-mb6me1_tsnr.nii.gz sub-10108_acq-mb6me4_tsnr.nii.gz sub-10125_acq-mb1me1_tsnr.nii.gz sub-10125_acq-mb1me4_tsnr.nii.gz sub-10125_acq-mb3me1_tsnr.nii.gz sub-10125_acq-mb3me4_tsnr.nii.gz sub-10125_acq-mb6me1_tsnr.nii.gz sub-10125_acq-mb6me4_tsnr.nii.gz sub-10136_acq-mb1me1_tsnr.nii.gz sub-10136_acq-mb1me4_tsnr.nii.gz sub-10136_acq-mb3me1_tsnr.nii.gz sub-10136_acq-mb3me4_tsnr.nii.gz sub-10136_acq-mb6me1_tsnr.nii.gz sub-10136_acq-mb6me4_tsnr.nii.gz sub-10137_acq-mb1me1_tsnr.nii.gz sub-10137_acq-mb1me4_tsnr.nii.gz sub-10137_acq-mb3me1_tsnr.nii.gz sub-10137_acq-mb3me4_tsnr.nii.gz sub-10137_acq-mb6me1_tsnr.nii.gz sub-10137_acq-mb6me4_tsnr.nii.gz sub-10142_acq-mb1me1_tsnr.nii.gz sub-10142_acq-mb1me4_tsnr.nii.gz sub-10142_acq-mb3me1_tsnr.nii.gz sub-10142_acq-mb3me4_tsnr.nii.gz sub-10142_acq-mb6me1_tsnr.nii.gz sub-10142_acq-mb6me4_tsnr.nii.gz sub-10150_acq-mb1me1_tsnr.nii.gz sub-10150_acq-mb1me4_tsnr.nii.gz sub-10150_acq-mb3me1_tsnr.nii.gz sub-10150_acq-mb3me4_tsnr.nii.gz sub-10150_acq-mb6me1_tsnr.nii.gz sub-10150_acq-mb6me4_tsnr.nii.gz sub-10154_acq-mb1me1_tsnr.nii.gz sub-10154_acq-mb1me4_tsnr.nii.gz sub-10154_acq-mb3me1_tsnr.nii.gz sub-10154_acq-mb3me4_tsnr.nii.gz sub-10154_acq-mb6me1_tsnr.nii.gz sub-10154_acq-mb6me4_tsnr.nii.gz sub-10186_acq-mb1me1_tsnr.nii.gz sub-10186_acq-mb1me4_tsnr.nii.gz sub-10186_acq-mb3me1_tsnr.nii.gz sub-10186_acq-mb3me4_tsnr.nii.gz sub-10186_acq-mb6me1_tsnr.nii.gz sub-10186_acq-mb6me4_tsnr.nii.gz sub-10188_acq-mb1me1_tsnr.nii.gz sub-10188_acq-mb1me4_tsnr.nii.gz sub-10188_acq-mb3me1_tsnr.nii.gz sub-10188_acq-mb3me4_tsnr.nii.gz sub-10188_acq-mb6me1_tsnr.nii.gz sub-10188_acq-mb6me4_tsnr.nii.gz sub-10221_acq-mb1me1_tsnr.nii.gz sub-10221_acq-mb1me4_tsnr.nii.gz sub-10221_acq-mb3me1_tsnr.nii.gz sub-10221_acq-mb3me4_tsnr.nii.gz sub-10221_acq-mb6me1_tsnr.nii.gz sub-10221_acq-mb6me4_tsnr.nii.gz

##remove NaNs from tsnr 4Dimage
#fslmaths tsnr_4Dimage.nii.gz -nan tsnr_4Dimage_nan_removed.nii.gz

##first run of randomise to generate fstat outputs of ME, MB, and MB*ME interaction
#randomise -i tsnr_4Dimage_nan_removed.nii.gz -o tsnr_wholebrain_n19 -d ../fsl/L3_ANOVA_n19.gfeat/cope1.feat/design.mat -t L3template_model-2x3_n-19_inputs-114_extraCons.con -f ../fsl/L3_ANOVA_n19.gfeat/cope1.feat/design.fts -c 3.1 -T -x -n 10000

## threshold the fstat images to .975
#for num in 1 2 3; do
#	fslmaths tsnr_wholebrain_n19_vox_corrp_fstat${num}.nii.gz -thr 0.975 tsnr_wholebrain_n19_vox_corrp_fstat${num}_thresholded.nii.gz
#done

## generate binary mask of each thresholded fstat
#for num in 1 2 3; do
#	fslmaths tsnr_wholebrain_n19_vox_corrp_fstat${num}_thresholded.nii.gz -bin tsnr_fstat${num}_mask.nii.gz
#done

## binarize and invert interaction image
#fslmaths tsnr_wholebrain_n19_vox_corrp_fstat3_thresholded.nii.gz -binv tsnr_interaction_mask_inverted_unbounded.nii.gz

## multiply with previous inverted binary mask of interaction fstat to remove those voxels from fstat 1 and 2
#for num in 1 2; do
#	fslmaths tsnr_fstat${num}_mask.nii.gz -mul tsnr_interaction_mask_inverted_unbounded.nii.gz tsnr_fstat${num}_mask_InteractionRemoved.nii.gz
#done

#run randomise with fstat1-minus-interaction mask
randomise -i tsnr_4Dimage_nan_removed.nii.gz -o tsnr_fstat1_mask -d ../fsl/L3_ANOVA_n19.gfeat/cope1.feat/design.mat -t L3template_model-2x3_n-19_inputs-114_extraCons.con -c 3.1 -T -x -m tsnr_fstat1_mask_InteractionRemoved.nii.gz -n 10000 &

#run randomise with fstat2-minus-interaction mask
randomise -i tsnr_4Dimage_nan_removed.nii.gz -o tsnr_fstat2_mask -d ../fsl/L3_ANOVA_n19.gfeat/cope1.feat/design.mat -t L3template_model-2x3_n-19_inputs-114_extraCons.con -c 3.1 -T -x -m tsnr_fstat2_mask_InteractionRemoved.nii.gz -n 10000 &

#run randomise with fstat3 (interaction) mask
randomise -i tsnr_4Dimage_nan_removed.nii.gz -o tsnr_fstat3_mask -d ../fsl/L3_ANOVA_n19.gfeat/cope1.feat/design.mat -t L3template_model-2x3_n-19_inputs-114_extraCons.con -c 3.1 -T -x -m tsnr_fstat3_mask.nii.gz -n 10000 &