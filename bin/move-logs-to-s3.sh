#!/bin/bash

# Usage ./cli/move-logs-to-s3.sh
# This command copies all logfiles ending with .log.gz from the current working directory to S3

set -euxo

bucket_name="countable/backups"

# Get the current directory name
current_directory=$(basename "$PWD")

# Iterate over all log.gz files in the current directory
ls *202*.log 2>/dev/null | xargs -r zstd --rm

for file in *.log.zst; do
    echo $file
    if [[ -f "$file" ]]; then
        echo "moving"
        # Construct the S3 destination path
        s3_destination="s3://${bucket_name}/${current_directory}/logs/${file}"

        # Copy the file to S3
        aws s3 cp "$file" "$s3_destination"
        rm "$file"
    fi
done

