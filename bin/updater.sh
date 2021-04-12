#!/bin/bash

set -x

workspace=/home/jenkins/workspace
cd $workspace
folders=$(ls -d * | grep -vE '*@tmp|ARCH')

for environment in $folders
do
    echo $environment
    cd $workspace
    cd $environment
    dir=${PWD##*/}

    echo ''
    echo '*************************'
    echo "Checking db container for $environment"
    name=${dir}_db_1
    db_container=$(docker ps -q -f "name=$name")

    if [ -z $db_container ]; then
        echo "no db container found for $environment"
        continue
    fi

    rm -rf ./dump
    rm -f ./dump.tar.lrz
    rm -f ./dump.lrz

    docker exec -t ${name} rm -fr /dump
    docker exec -t ${name} pg_dump -U postgres -f /dump postgres
    docker cp ${name}:/dump ./dump

    tar cvf ./dump.tar ./dump
    lrzip ./dump.tar
    rm -r ./dump
    
    filename=$dir.$(date +%Y%m%d-%H%M%S).sql
    folder=$(date +%Y%m)

    aws s3 mv ./dump.tar.lrz s3://countable/backups/$dir/$folder/$filename.tar.lrz

    echo ""
    echo "Successfully backed up $environment"
    echo "*************************"
done

