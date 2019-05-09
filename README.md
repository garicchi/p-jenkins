# p-jenkins
A super portable jenkins

# :question: INTRODUCTION
`p-jenkins` is a template of jenkins for make maintenance ease

you would say goodbye to fragile jenkins with using this template

# :white_check_mark: FEATURE
- [x] make portable jenkins with docker
- [x] backup and restore `jenkins-home` to AWS s3
- [x] full manage jobs you created from github with Declarative Pipeline
- [x] full manage configuration from github with Jenkins CasC
- [x] full manage plugin from github
- [x] all config can apply by running job after only edit code on github

# :beginner: SETUP

create `.env` for writing credentials or parameters
```
copy .env.template .env
```

write `.env`
```
# jenkinsのアカウント情報
USER_NAME_ADMIN=admin
USER_PASS_ADMIN=<your admin pass>

# s3にバックアップするときに使うAWSのクレデンシャル
AWS_ACCESS_KEY_ID=<your aws key>
AWS_SECRET_ACCESS_KEY=<your aws secret>

# バックアップするs3のバケット名
BACKUP_BUCKET_NAME=test-jenkins-backup

# Jenkinsfileをフェッチするためのアカウント情報
GITHUB_EP=<your github repository url that format is https>
GITHUB_USER=<your github username>
GITHUB_TOKEN=<your github personal access token>
```

run jenkins
```
docker-compose build
docker-compose up -d
```

access to `http://localhost:8080` then you can see jenkins login form

input admin name and password that specify in `.env` and login jenkins

after login, you can see 1 job that name is `update-config`

if you run `update-config` job then you can sync job that are same `jobs/` folder!

# :construction_worker: OPERATION

## ADD JOB
create directory and Jenkinsfile to `jobs/` directory

git commit & git push

run `update-config` job on jenkins

reload brower

## DELETE JOB
delete firectory from `jobs`

git commit & git push

run `update-config` job on jenkins

reload brower

## UPDATE JENKINS CONFIG
edit `./jenkins/config/jenkins.yaml`

git commit & git push

run `update-config` job on jenkins

push `Reload existing configuration` button in `Settings > Manage Jenkins > Configuration as code`

## UPDATE PLUGIN
edit `./jenkins/config/plugins.txt`

git commit & git push

run `update-config` job on jenkins

## BACKUP
run `backup` job

## RESTORE
run `restore` job with name of backup file

# QUESTION

## WANT TO USE GITHUB AUTHENTICATION
not work
p-jenkins support only local authentication becase it use jenkins-cli with admin user


