#!/bin/bash -e

function create-job {
    JOB_NAME="$1"
    cat << __EOS__ > /tmp/job.xml
<?xml version='1.1' encoding='UTF-8'?>
<flow-definition plugin="workflow-job@2.32">
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <com.sonyericsson.rebuild.RebuildSettings plugin="rebuild@1.29">
      <autoRebuild>false</autoRebuild>
      <rebuildDisabled>false</rebuildDisabled>
    </com.sonyericsson.rebuild.RebuildSettings>
  </properties>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps@2.66">
    <scm class="hudson.plugins.git.GitSCM" plugin="git@3.9.1">
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>$GITHUB_EP</url>
          <credentialsId>default-github</credentialsId>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>*/master</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="list"/>
      <extensions/>
    </scm>
    <scriptPath>jobs/${JOB_NAME}/Jenkinsfile</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
__EOS__


    java -jar /jenkins-cli.jar \
         -s JENKINS_EP \
         -auth $USER_NAME_ADMIN:$USER_PASS_ADMIN \
         create-job \
         $JOB_NAME < /tmp/job.xml
    
}

function delete-job {
    JOB_NAME="$1"
    java -jar /jenkins-cli.jar \
     -s JENKINS_EP \
     -auth $USER_NAME_ADMIN:$USER_PASS_ADMIN \
     delete-job \
     $JOB_NAME
}


###
### INTERFACE
###
### WHAT:
###   job変更を反映します
###
### PARAMETER:
SCRIPT_PATH=$(cd $(dirname $0);pwd)
JENKINS_EP=http://localhost:8080
GITHUB_EP="$GITHUB_EP"
JENKINS_USER_ADMIN="$JENKINS_USER_ADMIN"
JENKINS_PASS_ADMIN="$JENKINS_PASS_ADMIN"

cd $SCRIPT_PATH

###
### WHAT: jenkins-cliをダウンロードします
###
### WHY: ジョブを追加したりするためです
###      jenkinsが立ち上がってないとcliをダウンロードできないのでこのタイミングでおこないます
###   
curl -u ${USER_NAME_ADMIN}:${USER_PASS_ADMIN} -o /jenkins-cli.jar ${JENKINS_EP}/jnlpJars/jenkins-cli.jar

###
### WHAT: ジョブ差分を取得して更新します
###   
JENKINS_JOBS=$(ls /var/jenkins_home/jobs)

REPO_JOBS=$(ls $SCRIPT_PATH/../../jobs)

DIFF_JOBS_FOR_ADD=$(join -v 1 <(echo "${REPO_JOBS[@]}") <(echo "${JENKINS_JOBS[@]}"))

IS_UPDATE_JOB=false

echo "------ Job difference for add ------"
for j in ${DIFF_JOBS_FOR_ADD[@]}; do
    echo "[ADD] $j"
    IS_UPDATE_JOB=true
done

DIFF_JOBS_FOR_RM=$(join -v 2 <(echo "${REPO_JOBS[@]}") <(echo "${JENKINS_JOBS[@]}"))

echo "------ Job difference for remove ------"
for j in ${DIFF_JOBS_FOR_RM[@]}; do
    echo "[REMOVE] $j"
    IS_UPDATE_JOB=true
done

echo ""

if [[ $IS_UPDATE_JOB = true ]]; then
    echo "There are difference in job!"
    for JOB in ${DIFF_JOBS_FOR_ADD[@]}; do
        echo "$JOB adding..."
        create-job "$JOB"
    done
    for JOB in ${DIFF_JOBS_FOR_RM[@]}; do
        echo "$JOB removing..."
        delete-job "$JOB"
    done

    echo "job apply completed!"

else
    echo "------ There is no difference in job ------"
fi
