#!/bin/bash

# Define the directory where subjects' data is stored
data_dir="/ZPOOL/data/projects/rf1-mbme-pilot/archive/bids"

# Find all matching files and iterate over them
find "$data_dir" -type f -wholename "*/sub-*/func/sub-*_task-sharedreward_acq-mb1me4_echo-1_bold.nii.gz" | while read -r file_path; do
    # Extract the subject ID from the file path
    # Using pattern matching to extract the subject ID
    if [[ $file_path =~ sub-([0-9]+)_task-sharedreward_acq-mb1me4_echo-1_bold.nii.gz ]]; then
        subject_id="${BASH_REMATCH[1]}"
    else
        echo "Error: Unable to extract subject ID from file path: $file_path"
        continue
    fi
    
    # Print subject ID and run fslinfo on the file
    echo "Subject ID: $subject_id"
    fslinfo "$file_path"
    echo "--------------------------------------------"
done
