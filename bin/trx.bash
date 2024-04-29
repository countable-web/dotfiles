#!/bin/bash

set -euxo


if [ "$#" -lt 1 ]; then
    echo "Error: Incorrect number of arguments"
    echo "Usage: DOCKER_VOLUMES=[quoted, space delimited volume list] $0 <NEW_SERVER_IP> [FOLDER_NAME]"

echo "Transfer docker compose projects with their volumes across servers, faster, with no temp storage, and in one step. Run as root."
echo "To set this up, you must:"
echo "1. Create jenkins user on both systems"
echo "2. Generate jenkins ssh key on sender, and install jenkins ssh public key into ~/.ssh/authorized_keys on recipient system."
echo "3. Install zstd on the recipient"
echo "4. Create a folder, /opt/inputs, owned by jenkis users, on the recipient. Everything is copied here."
echo
echo "Example 1: send just a specific volume"
echo jenkins@whitehead:~/workspace % DOCKER_VOLUMES="cortico-kmc_prescriptions" trx.bash fermat.countable.ca
echo transfers /docker-vols/cortico-kmc_prescriptions
echo 
echo Example 2: send onlyone volume and the main folder
echo jenkins@whitehead:~/workspace % DOCKER_VOLUMES="cortico-kmc_prescriptions" trx.bash fermat.countable.ca cortico-kmc
echo transfers cortico-kmc /docker-vols/cortico-kmc_prescriptions
echo
echo Example 3: send the folder and all associated docker volumes
echo jenkins@whitehead:~/workspace % trx.bash fermat.countable.ca cortico-kmc
echo transfers cortico-kmc /docker-vols/cortico-kmc_media_volume /docker-vols/cortico-kmc_patient_files /docker-vols/cortico-kmc_pg-data /docker-vols/cortico-kmc_prescriptions /docker-vols/cortico-kmc_redis
echo
echo Example 4: send only the specified folder.
echo jenkins@whitehead:~/workspace % DOCKER_VOLUMES= trx.bash fermat.countable.ca cortico-kmc
echo transfers cortico-kmc

    exit 1
fi


NEW_SERVER_IP=$1
TAR_INPUTS="${@:2}"

# Detect volume names
if [ -z ${DOCKER_VOLUMES+x} ]; then
 echo "Detecting docker volumes"
 for PARENT_FOLDER_NAME in $TAR_INPUTS
 do
  VOLUMES=$(docker volume ls -q | grep $PARENT_FOLDER_NAME | tr '\n' ' ')
  for VOLUME in $VOLUMES
   do
    DOCKER_VOLUMES="$DOCKER_VOLUMES $VOLUME"
   done
 done
fi

for v in $DOCKER_VOLUMES
do
 TAR_INPUTS="$TAR_INPUTS /docker-vols/$v"
done

echo transferring... $TAR_INPUTS


#docker run --rm -v $(pwd):/from -v $(pwd):/to danysk/zstd sh -c "tar cv /from/$PARENT_FOLDER_NAME | zstd -1 -T0 -o -" | ssh $NEW_SERVER_USERNAME@$NEW_SERVER_IP "zstdcat | tar xv -C $DESTINATION_PATH"

start=`date +%s`

# TODO - direct transfer without intermediate file.
docker run --rm -v /var/lib/docker/volumes:/docker-vols:ro -v $(pwd):/from:ro -v /home/jenkins/.ssh/id_rsa:/root/.ssh/id_rsa:ro danysk/zstd sh -c "apk add openssh && cd /from/ && tar cvp $TAR_INPUTS | zstd -2 -T0 | ssh -o StrictHostKeyChecking=no jenkins@$NEW_SERVER_IP 'zstdcat | tar xv -C /opt/inputs/'"


# Save a local packed copy
#docker run --rm -v /var/lib/docker/volumes:/fromv -v $(pwd):/from danysk/zstd sh -c "cd /from && tar cvp $PARENT_FOLDER_NAME $APPEND_VOLUME_PATH | zstd -2 -T12 > $PARENT_FOLDER_NAME.tar.zst"
# Transfer the current directory (including Dockerfile, docker-compose.yml, etc) to the new server
#ssh -i /home/jenkins/.ssh/id_rsa jenkins@$NEW_SERVER_IP "zstdcat | tar xv -C /opt/" < $(pwd)/$PARENT_FOLDER_NAME.tar.zst

end=`date +%s`

runtime=$((end-start))
echo $runtime

