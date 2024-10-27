#!/bin/bash

## https://github.com/sonatype/docker-nexus3
## https://github.com/sonatype/docker-nexus3/blob/main/Dockerfile.alpine.java17

docker build --rm=true --tag=sonatype/nexus3 .

docker run -d -p 8081:8081 --name nexus sonatype/nexus3

sleep 10

docker ps -a
