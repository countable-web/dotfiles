#!/bin/bash

# Ensure that the AWS CLI is installed
if ! command -v aws &> /dev/null
then
    echo "AWS CLI could not be found, please install it."
    exit
fi

# Ensure that an S3 path is provided
if [ -z "$1" ]
then
    echo "Usage: $0 <s3-folder-path>"
    exit 1
fi

S3_PATH=$1

# Function to get the lexicographically last child of a given S3 directory
get_last_child() {
    local directory=$1
    aws s3 ls $directory --recursive | sort | tail -n 1
}

# Get the list of subdirectories
subdirs=$(aws s3 ls $S3_PATH | awk '$1 == "PRE" {print $2}')

# Iterate over each subdirectory and find the lexicographically last child
for subdir in $subdirs; do
    full_path="${S3_PATH}${subdir}"
    echo "Subdirectory: $full_path"
    last_child=$(get_last_child $full_path)
    echo "Last child: $last_child"
    echo ""
done
