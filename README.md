# Supinfo Tours TechLunches - Demo Jenkins environment

This project is the project used as a demo on the Jenkins discovery talk made on 16/03/2016 at Supinfo, Tours campus.

## Prerequisites
The whole infrastructure is heavily Dockerized, so make sure to have [Docker](https://www.docker.com/) installed on your host.

## Project structure
This project is composed of 2 custom Docker images. 
The first one (**techlunches-customjenkins-docker**) is bootstrapping a custom Jenkins instance with default plugins installed and host Docker communication basis in order to be able to spawn executors on the Docker host.
The second one (**techlunches-jenkinsexecutor**) is a slave image used to build Maven-based projects.

**Note that the project is also using a third Docker image containing [Sonatype](http://www.sonatype.com/) in order to test the Java artifact deployment workflow from end-to-end.**

## Well, ok. But how does this work ?
- Both Java projects **technlunches-validjavaproject** and **technlunches-invalidjavaproject** are pushed to GitHub.
- The local Jenkins instance is configured to periodically poll changes on their repositories (**note that as the infrastructure is behind a NAT and not on the Internet, we can't use [Webhooks](https://developer.github.com/webhooks/Github) in order to trigger builds every time a change is pushed.**)
- Even if a change is not made (for the sake of the demo), we trigger a build in order to test both build workflows :
    - The workflow associated to the **technlunches-validjavaproject** must build a Java artifact, pass tests, send a mail and push the artifact to Sonatype.
    - The workflow associated to the **technlunches-invalidjavaproject** must not pass tests, fail, and that's all.