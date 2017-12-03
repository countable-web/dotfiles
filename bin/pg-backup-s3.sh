#!/bin/sh

site=$1
filename=$site.$(date +%Y%m%d-%H%M%S).sql.bz2
aws=/home/clark/.local/bin/aws

docker exec -t ${site}_db_1 pg_dump -U postgres postgres | bzip2 -9 > /tmp/$filename
$aws s3 mv /tmp/$filename s3://countable/backups/$site/$filename

