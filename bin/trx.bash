#!/bin/bash

set -euxo

echo "Transfer docker compose projects with their volumes across servers. Run as root."
if [ "$#" -lt 2 ]; then
    echo "Error: Incorrect number of arguments"
    echo "Usage: $0 <FOLDER_NAME> <NEW_SERVER_IP>"
    exit 1
fi


NEW_SERVER_IP=$1
DESTINATION_PATH="/opt/"
PARENT_FOLDER_NAME=$2
TAR_INPUTS="${@:2}"

if [ "$EUID" -eq 1 ]; then

# Detect volume name
for PARENT_FOLDER_NAME in $TAR_INPUTS
 do
  VOLUME_NAME=$(ls /var/lib/docker/volumes | grep ${PARENT_FOLDER_NAME})
  if [ $(echo "$VOLUME_NAME" | wc -l) -gt 1 ]; then
    echo "Warning: Expected one or fewer volumes with the name $VOLUME_NAME, but found $(echo "$VOLUME_NAME" | wc -l). Aborting."
    exit 1
  fi

  if [ $(echo "$VOLUME_NAME" | wc -l) -eq 1 ]; then
    echo "Found volume, $VOLUME_NAME, copying into project dir for transfer."
    TAR_INPUTS="$TAR_INPUTS /docker-vols/$VOLUME_NAME"
  fi
 done
fi
# root only

echo TAR INPUTS $TAR_INPUTS

#docker run --rm -v $(pwd):/from -v $(pwd):/to danysk/zstd sh -c "tar cv /from/$PARENT_FOLDER_NAME | zstd -1 -T0 -o -" | ssh $NEW_SERVER_USERNAME@$NEW_SERVER_IP "zstdcat | tar xv -C $DESTINATION_PATH"

start=`date +%s`

# TODO - direct transfer without intermediate file.
docker run --rm -v /var/lib/docker/volumes:/docker-vols -v $(pwd):/from -v /home/jenkins/.ssh:/root/.ssh:ro danysk/zstd sh -c "apk add openssh && cd /from/ && tar cvp $TAR_INPUTS | zstd -2 -T0 | ssh -o StrictHostKeyChecking=no jenkins@$NEW_SERVER_IP 'zstdcat | tar xv -C /opt/inputs/'"


# Save a local packed copy
#docker run --rm -v /var/lib/docker/volumes:/fromv -v $(pwd):/from danysk/zstd sh -c "cd /from && tar cvp $PARENT_FOLDER_NAME $APPEND_VOLUME_PATH | zstd -2 -T12 > $PARENT_FOLDER_NAME.tar.zst"
# Transfer the current directory (including Dockerfile, docker-compose.yml, etc) to the new server
#ssh -i /home/jenkins/.ssh/id_rsa jenkins@$NEW_SERVER_IP "zstdcat | tar xv -C /opt/" < $(pwd)/$PARENT_FOLDER_NAME.tar.zst

end=`date +%s`

runtime=$((end-start))
echo $runtime

