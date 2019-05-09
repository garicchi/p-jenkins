#!/bin/bash -e

###
### INTERFACE
###
### WHAT:
###   jenkins.yamlを適用します。実行後、configuration as a codeのページからreloadする必要があります
###
### PARAMETER:
SCRIPT_PATH=$(cd $(dirname $0);pwd)
JENKINS_EP=http://localhost:8080

cd $SCRIPT_PATH

###
### WHAT: jenkins.yamlのdiffをとって差分があれば適用します
###
### WHY: ジョブを追加したりするためです
###      jenkinsが立ち上がってないとcliをダウンロードできないのでこのタイミングでおこないます
###   
DIFF_CONFIG=$(diff -u ${SCRIPT_PATH}/../config/jenkins.yaml $CASC_JENKINS_CONFIG||true)

echo ""
if [[ "${#DIFF_CONFIG}" -gt 0 ]]; then
    echo "------ There are some difference in jenkins.yaml ------"
    echo ""
    diff -u ${SCRIPT_PATH}/../config/jenkins.yaml $CASC_JENKINS_CONFIG||true
    cp ${SCRIPT_PATH}/../config/jenkins.yaml $CASC_JENKINS_CONFIG
    echo "copying config completed!"
    echo -e "\e[1;34m you must apply config from jenkins page! \e[m"
else
    echo "------ There is no difference in jenkins.yaml ------"
fi
echo ""

