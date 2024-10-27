#!/bin/bash

ARCH=$(uname -m)
if [ -z "$ARCH" ]; then
  echo "Error: Unable to determine architecture"
  exit 1
fi

if [ "$ARCH" == "arm64"  || "$ARCH" == "aarch64"  ]; then
  export NEXUS_IMAGE=${NEXUS_IMAGE:-"sonatype/nexus3:3.70.3-arm64"}
else
  export NEXUS_IMAGE=${NEXUS_IMAGE:-"sonatype/nexus3:3.70.3"}
fi

docker-compose up -d