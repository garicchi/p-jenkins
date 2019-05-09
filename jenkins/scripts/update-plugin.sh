#!/bin/bash -e

###
### INTERFACE
###
### WHAT:
###   plugin変更を反映します
###
### PARAMETER:
SCRIPT_PATH=$(cd $(dirname $0);pwd)
JENKINS_EP=http://localhost:8080
GITHUB_EP="$GITHUB_EP"
JENKINS_USER_ADMIN="$JENKINS_USER_ADMIN"
JENKINS_PASS_ADMIN="$JENKINS_PASS_ADMIN"

cd $SCRIPT_PATH

###
### WHAT: plugin差分を取得して更新します
###   
DIFF_PLUGINS=$(diff -u ${SCRIPT_PATH}/../config/plugins.txt /build/plugins.txt||true)

echo ""
if [[ "${#DIFF_PLUGINS}" -gt 0 ]]; then
    echo "------ There are some difference in plugins.txt ------"
    echo ""
    diff -u ${SCRIPT_PATH}/../config/plugins.txt /build/plugins.txt||true
    copy ${SCRIPT_PATH}/../config/plugins.txt /build/plugins.txt
    /usr/local/bin/install-plugins.sh < /build/plugins.txt
    echo "copying config completed!"
else
    echo "------ There is no difference in plugins.txt ------"
fi
