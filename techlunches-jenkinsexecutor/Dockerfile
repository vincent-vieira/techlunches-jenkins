#Bootstrappping a slave executor using Java 8 and Maven
FROM maven:3.3.3
MAINTAINER Vincent Vieira <vincent.vieira@supinfo.com>

#Copying our settings.xml file...
ADD settings.xml /usr/share/maven/conf/settings.xml

#SSH server
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd

# Install packages needed for the build
RUN apt-get install -y --no-install-recommends git

# Add user jenkins to the image
RUN useradd -m -s /bin/bash -m jenkins
RUN echo "jenkins:jenkins" | chpasswd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

