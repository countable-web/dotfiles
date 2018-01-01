#!/bin/sh

site=$1
filename=$site-dump.$(date +%Y%m%d-%H%M%S)
aws=/home/clark/.local/bin/aws

docker exec -t ${site}_db_1 rm -rf /dump
docker exec -t ${site}_db_1 mongodump
docker cp ${site}_db_1:/dump /tmp/$filename
cd /tmp/ && lrztar /tmp/$filename
rm -fr "/tmp/${filename}"
$aws s3 mv /tmp/$filename.tar.lrz s3://countable/backups/$site/$filename.tar.lrz

