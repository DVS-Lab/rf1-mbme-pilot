#!/bin/bash

# Define the CSV file path
csv_file="fslinfo_results.csv"

# Define the header line for the CSV file
echo "Subject ID,File Name,Dimension,Data Type,Intent Name" > "$csv_file"

# Define the directory where subjects' data is stored
data_dir="/ZPOOL/data/projects/rf1-mbme-pilot/archive/bids"

# Find all matching files and iterate over them
find "$data_dir" -type f -wholename "*/sub-*/func/sub-*_task-sharedreward_acq-mb1me4_echo-1_bold.nii.gz" | while read -r file_path; do
    # Extract the subject ID from the file path
    if [[ $file_path =~ sub-([0-9]+)_task-sharedreward_acq-mb1me4_echo-1_bold.nii.gz ]]; then
        subject_id="${BASH_REMATCH[1]}"
    else
        echo "Error: Unable to extract subject ID from file path: $file_path"
        continue
    fi
    
    # Get the base name of the file
    file_name=$(basename "$file_path")
    
    # Run fslinfo on the file and capture the output
    fslinfo_output=$(fslinfo "$file_path")
    
    # Extract relevant information from fslinfo output
    dimension=$(echo "$fslinfo_output" | grep "dim1" | awk '{print $2}')
    data_type=$(echo "$fslinfo_output" | grep "datatype" | awk '{print $2}')
    intent_name=$(echo "$fslinfo_output" | grep "intent_name" | awk '{$1=""; print $0}' | xargs)
    
    # Append to CSV file
    echo "$subject_id,$file_name,$dimension,$data_type,$intent_name" >> "$csv_file"
done

echo "CSV file generated: $csv_file"
