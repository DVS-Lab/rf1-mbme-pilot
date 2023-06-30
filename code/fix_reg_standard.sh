#!/bin/bash

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

for sub in `cat ${scriptdir}/newsubs.txt`; do #10303 10198 10185; do
	for model in mb1me1 mb1me4 mb3me1 mb3me4 mb6me1 mb6me4; do
		rm /data/projects/rf1-mbme-pilot/derivatives/fsl/sub-${sub}/L1_task-sharedreward_model-1_type-act_acq-${model}_sm-4_denoising-base.feat/reg/standard.nii.gz
		ln -s /data/projects/rf1-mbme-pilot/derivatives/fsl/sub-${sub}/L1_task-sharedreward_model-1_type-act_acq-${model}_sm-4_denoising-base.feat/mean_func.nii.gz /data/projects/rf1-mbme-pilot/derivatives/fsl/sub-${sub}/L1_task-sharedreward_model-1_type-act_acq-${model}_sm-4_denoising-base.feat/reg/standard.nii.gz
		echo "fixed reg standard for" $sub $model
	done
done