#!/bin/bash

set -x

workspace=${1:-/home/jenkins/workspace}
aws_bucket=${2:-countable}
aws_folder=${3:-backups}

cd $workspace
folders=$(ls -d cortico-* | grep -vE '*@tmp|ARCH')

for environment in $folders
do
    echo $environment
    cd $workspace
    cd $environment
    dir=${PWD##*/}

    echo ''
    echo '*************************'
    echo "Checking db container for $environment"
    name=${dir}-db-1
    db_container=$(docker ps -q -f "name=$name")

    if [ -z $db_container ]; then
        echo "no db container found for $environment"
        continue
    fi

    docker exec -t ${name} pg_dump -U postgres postgres | zstd -T0 -o dump.sql.zst

    
    filename=$dir.$(date +%Y%m%d-%H%M%S).sql
    folder=$(date +%Y%m)

    aws s3 mv ./dump.sql.zst s3://$aws_bucket/$aws_folder/$dir/$folder/$filename.sql.zst

    echo ""
    echo "Successfully backed up $environment"
    echo "*************************"
done

