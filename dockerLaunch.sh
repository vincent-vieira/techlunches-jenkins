#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
    error "This script should be run using sudo or as the root user"
    exit 1
fi

#Bootstrapping folders
[ -d ~/jenkins-config ] && echo "Jenkins folder exists, skipping its creation..." || mkdir -p ~/jenkins-config
[ -d ~/nexus-data ] && echo "Sonatype data folder exists, skipping its creation..." || mkdir -p ~/nexus-data
chown -R 1000 ~/jenkins-config
chown -R 200 ~/nexus-data

#Configuring Docker
NEXUS_CONTAINER=$(docker ps -aq -f "name=nexus")
[ ! -z "$NEXUS_CONTAINER" ] && echo "Nexus container already exists, deleting it..." && docker rm -f "$NEXUS_CONTAINER" > /dev/null

JENKINS_CONTAINER=$(docker ps -aq -f "name=jenkins")
[ ! -z "$JENKINS_CONTAINER" ] && echo "Jenkins container already exists, deleting it..." && docker rm -f "$JENKINS_CONTAINER" > /dev/null

HAS_JENKINS_IMAGE=$(docker images | grep techlunches-customjenkins)
[ ! -z "$HAS_JENKINS_IMAGE" ] && docker rmi techlunches-customjenkins > /dev/null

HAS_JENKINS_EXECUTOR_IMAGE=$(docker images | grep techlunches-jenkinsexecutor)
[ ! -z "$HAS_JENKINS_EXECUTOR_IMAGE" ] && docker rmi techlunches-jenkinsexecutor > /dev/null

docker build -t techlunches-customjenkins ./techlunches-customjenkins-docker/
docker build -t techlunches-jenkinsexecutor ./techlunches-jenkinsexecutor/

docker run -d -p 8081:8081 --name nexus -v ~/nexus-data:/sonatype-work sonatype/nexus:oss
docker run -d -p 8080:8080 -p 50000:50000 --link nexus:nexus --name jenkins -v ~/jenkins-config:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock techlunches-customjenkins