# Supinfo Tours TechLunches - Demo Jenkins environment

This project is the project used as a demo on the Jenkins discovery talk made on 16/03/2016 at Supinfo, Tours campus.

## Prerequisites
The whole infrastructure is heavily Dockerized, so make sure to have [Docker](https://www.docker.com/) installed on your host.

## Project structure
This project is composed of 2 custom Docker images, and 1 stock image. 

- The first one (**techlunches-customjenkins-docker**) is bootstrapping a custom Jenkins instance with default plugins installed and host Docker communication basis in order to be able to spawn executors on the Docker host.
- The second one (**techlunches-jenkinsexecutor**) is a slave image used to build Maven-based projects. Its use is configured into Jenkins settings and all containers deployed from this image are automatically managed by Jenkins.
- The third image, the stock one, is containing [Sonatype](http://www.sonatype.com/) in order to test the Java artifact deployment workflow from end-to-end.

## Well, ok. But how does this work ?
- Both Java projects **technlunches-validjavaproject** and **technlunches-invalidjavaproject** are pushed to GitHub.
- The local Jenkins instance is configured to periodically poll changes on their repositories (**note that as the infrastructure is behind a NAT and not on the Internet, we can't use [Webhooks](https://developer.github.com/webhooks) in order to trigger builds every time a change is pushed.**)
- Even if a change is not made (for the sake of the demo), we trigger a build in order to test both build workflows :
    - The workflow associated to the **technlunches-validjavaproject** must build a Java artifact, pass tests, send a mail and push the artifact to Sonatype.
    - The workflow associated to the **technlunches-invalidjavaproject** must not pass tests, fail, and that's all.
    
## [Stop... Docker time !](https://www.youtube.com/watch?v=otCpCn0l4Wo&t=2m9s)
### How to build the different custom images ?

First, set your current directory as this directory (**the one i'm located into**). Then :
```bash
docker build -t techlunches-customjenkins ./techlunches-customjenkins-docker/
docker build -t techlunches-jenkinsexecutor ./techlunches-jenkinsexecutor/
```

### And how to run them ?
#### Command line

```bash
docker run -d -p 8081:8081 --name nexus sonatype/nexus:oss
docker run -d -p 8080:8080 -p 50000:50000 --link nexus:nexus --name jenkins -v ~/jenkins-config:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock techlunches-customjenkins
```

#### Recommandations
Make sure the **jenkins-config** directory located inside `~` (aka your Unix current user's home) is writable per userid 1000 (as said in [the official Jenkins Docker image documentation](https://hub.docker.com/_/jenkins/)).
**And note that the host's Docker Unix socket is bound to the Docker client used with Jenkins. This a major security issue and must be only used while creating PoCs and testing things !**