#!/bin/sh

set -e
set -x

site=$1
filename=$site.$(date +%Y%m%d-%H%M%S).sql
folder=$(date +%Y%m%d)
rm /tmp/*.sql
rm /tmp/*.lrz
docker exec ${site}_db_1 pg_dump -U postgres -f /tmp/db.sql postgres
docker cp ${site}_db_1:/tmp/db.sql /tmp/$filename
lrzip /tmp/$filename
rm /tmp/$filename
aws s3 mv /tmp/$filename.lrz s3://${2}$site/$folder/$filename.lrz

