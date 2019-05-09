#!/bin/bash -xe

###
### INTERFACE
###
### WHAT:
###   jenkins-homeをs3からリストアします
###
### PARAMETER:
BACKUP_FILE=$1
BACKUP_BUCKET_NAME=$BACKUP_BUCKET_NAME

if [[ -z "${BACKUP_FILE}" ]]; then
    echo "please specify backup file!" >&2
    echo "./restore.sh BACKUP_FILE" >&2
    exit 1
fi

aws \
    s3 cp s3://${BACKUP_BUCKET_NAME}/${BACKUP_FILE} /restore

tar zxvf \
    /restore/${BACKUP_FILE}

echo -e "\e[1;34m restore completed! please restart jenkins! \e[m"
