#!/bin/bash

echo "This command removes files as it goes, so it's not safe to interrupt. Also, please run as root. It's for long term archival of non-critical data. Critical stuff should be backed up elsewhere."

for var in "$@"
do
    echo "$var"
    tar cvp --remove-files --remove-files --remove-files --remove-files --remove-files --remove-files --remove-files --remove-files --remove-files $var | zstd -2 -T12 > $var.tar.zst
done


