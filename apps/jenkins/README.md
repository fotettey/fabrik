## How to setup Jenkins CASC (Configuration as Code)
https://www.digitalocean.com/community/tutorials/how-to-automate-jenkins-setup-with-docker-and-jenkins-configuration-as-code

cd apps/jenkins/jcasc
docker build -t jenkins:jcasc .

## Testing build image:
docker run --name jenkins --rm -p 8080:8080 jenkins:jcasc

## Checking installed plugins:
server_ip:8080/pluginManager/installed

## Configuration options
server_ip:8080/configuration-as-code/reference


