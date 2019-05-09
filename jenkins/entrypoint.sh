#!/bin/bash
### INTERFACE
###   DESC: dockerfileのentrypointで呼ばれるコンテナ初期化処理
###   PARAM: 

###
### WHAT: 初期config更新用ジョブをつくります
###
EP=$(echo ${GITHUB_EP}|sed -e "s/\//\\\\\//g")
mkdir -p /var/jenkins_home/jobs/update-config
cat /tmp/config.xml|sed -e "s/{{ GITHUB_EP }}/${EP}/g" > /var/jenkins_home/jobs/update-config/config.xml

###
### WHAT: Jenkinsを実行します
###
/sbin/tini -- /usr/local/bin/jenkins.sh
