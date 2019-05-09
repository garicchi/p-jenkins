#!/bin/bash -xe

###
### INTERFACE
###
### WHAT:
###   jenkins-homeをs3にバックアップします
###
### PARAMETER:
BACKUP_BUCKET_NAME=$BACKUP_BUCKET_NAME

SCRIPT_PATH=$(cd $(dirname $0);pwd)

NOW=$(date "+%Y%m%d-%H%M")
tar zcvf \
    /backup/${NOW}.tar.gz \
    /var/jenkins_home \
    -X ${SCRIPT_PATH}/backup-excludes.txt

aws s3 cp \
    /backup/${NOW}.tar.gz s3://${BACKUP_BUCKET_NAME}/backup-${NOW}
