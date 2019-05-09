FROM jenkins/jenkins:2.164.2-alpine

ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false -Xmx800m"

USER root
RUN mkdir /build

RUN apk add --update python3 py-pip

RUN pip install awscli

# deploy config
RUN mkdir -p /config
ENV CASC_JENKINS_CONFIG /config/jenkins.yaml
COPY ./config/jenkins.yaml $CASC_JENKINS_CONFIG

# install plugin
COPY ./config/plugins.txt /config/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /config/plugins.txt

# deploy manage scripts
COPY scripts/ /scripts

RUN mkdir -p /backup
RUN mkdir -p /restore

# deploy aws config
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

###
### WHAT: AWSの認証情報を書き込みます
### WHY: s3にバックアップデータを入れるため
###
RUN mkdir -p /root/.aws
RUN echo "[default]" >> /root/.aws/credentials
RUN echo "aws_access_key_id = $AWS_ACCESS_KEY_ID" >> /root/.aws/credentials
RUN echo "aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> /root/.aws/credentials


###
### WHAT: 最初のジョブ反映のためにupdate-configジョブだけつくります
###       実際に作るのはentrypoint.shの中なのでここではテンプレートのコピーだけします
###
RUN mkdir -p /tmp
COPY ./config/update-config.xml /tmp/config.xml

# WHAT: コンテナ立ち上げ時にスクリプトを実行します
# WHY: コンテナ立ち上げ時に実行する処理がたくさんあるため
COPY ./entrypoint.sh /
ENTRYPOINT "/entrypoint.sh"
