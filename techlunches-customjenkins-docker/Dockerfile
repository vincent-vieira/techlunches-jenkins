FROM bdruemen/jenkins-uid-from-volume
MAINTAINER Vincent Vieira <vincent.vieira@supinfo.com>

#Installing plugins through descriptor file
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

#Thanks to https://forums.docker.com/t/how-can-i-run-docker-command-inside-a-docker-container/337/6
RUN apt-get -yqq update && apt-get -yqq install docker.io && usermod -g docker jenkins

VOLUME /var/run/docker.sock
ENTRYPOINT groupmod -g $(stat -c "%g" /var/run/docker.sock) docker && usermod -u $(stat -c "%u" /var/jenkins_home) jenkins && gosu jenkins /bin/tini -- /usr/local/bin/jenkins.sh