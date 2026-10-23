#!/bin/bash

set -u

workspace=${1:-/home/jenkins/workspace}
aws_bucket=${2:-cortico-backups}
aws_folder=${3:-backups}

if ! workspace=$(cd "$workspace" && pwd); then
    echo "Could not access workspace: $workspace" >&2
    exit 1
fi

folder=$(date +%Y%m)
failed=0

for environment_dir in "$workspace"/cortico-*; do
    [ -d "$environment_dir" ] || continue

    environment=${environment_dir##*/}
    case "$environment" in
        *@tmp*|*ARCH*) continue ;;
    esac

    for logfile in \
        "$environment_dir"/*202*.log ; do
        [[ -f "$logfile" && -s "$logfile" ]] || continue

        compressed_log=$logfile.zst
        filename=${logfile##*/}.zst
        destination="s3://$aws_bucket/$aws_folder/$environment/$folder/$filename"

        echo "Backing up $logfile to $destination"
        if ! zstd -f -T0 "$logfile" -o "$compressed_log"; then
            echo "Failed to compress $logfile; leaving it in place" >&2
            failed=1
            continue
        fi

        if aws s3 mv "$compressed_log" "$destination"; then
            if rm "$logfile"; then
                echo "Successfully backed up and removed $logfile"
            else
                echo "Moved backup to S3 but failed to remove original log $logfile" >&2
                failed=1
            fi
        else
            echo "Failed to upload $compressed_log; leaving local files in place" >&2
            failed=1
        fi
    done
done

exit "$failed"
