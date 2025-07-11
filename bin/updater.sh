#!/bin/bash

set -x

workspace=${1:-/home/jenkins/workspace}
aws_bucket=${2:-countable}
aws_folder=${3:-backups}

cd $workspace
<<<<<<< HEAD
folders=$(ls | grep -E "(cerebro|cortico)" | grep -vE '*@tmp|ARCH')
=======
folders=$(ls -d cortico-* | grep -vE '*@tmp|ARCH')
>>>>>>> 36e96d1661571bf13e8fd10afd4902393a44d921

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

    rm -rf ./dump
    rm -f ./dump.tar.lrz
    rm -f ./dump.lrz

    docker exec -t ${name} rm -fr /dump
    docker exec -t ${name} pg_dump -U postgres -f /dump postgres
    docker cp ${name}:/dump ./dump

    tar cvf ./dump.tar ./dump
    lrzip ./dump.tar
    
    filename=$dir.$(date +%Y%m%d-%H%M%S).sql
    folder=$(date +%Y%m)

    aws s3 mv ./dump.tar.lrz s3://$aws_bucket/$aws_folder/$dir/$folder/$filename.tar.lrz
    rm -r ./*dump*

    echo ""
    echo "Successfully backed up $environment"
    echo "*************************"
done

