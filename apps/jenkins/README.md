## How to setup Jenkins CASC (Configuration as Code)
https://www.digitalocean.com/community/tutorials/how-to-automate-jenkins-setup-with-docker-and-jenkins-configuration-as-code
https://www.jenkins.io/doc/book/managing/casc/
## Sample JCASC Config files:
https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos
https://github.com/jenkinsci/configuration-as-code-plugin/tree/master

cd apps/jenkins/jcasc
docker build -t jenkins:jcasc .

## Testing build image:
docker run --name jenkins --rm -p 8080:8080 jenkins:jcasc

## Checking installed plugins:
server_ip:8080/pluginManager/installed

## Configuration options
server_ip:8080/configuration-as-code/reference

## Run after configs:
docker run --name jenkins --rm -p 8080:8080 --env JENKINS_ADMIN_ID=admin --env JENKINS_ADMIN_PASSWORD=password jenkins:jcasc

## JCASC enables the fully automated setup/installation of Jenkins which is closest to EaC (Everything as Code) paradigm.
## Jenkins PIPELINE (workflow-aggregator) plugin enables developers to define their jobs inside a Jenkinsfile, and lastly the Job-DSL plugin allows us to define projects and jobs as code. What’s more, you can include the Job DSL code inside your JCasC configuration file, and have the projects and jobs created as part of the configuration process. 


## FINAL BUILD CMD:
cp /home/vagrant/.ssh/git-auto /home/vagrant/projects/fabrik/apps/jenkins/jcasc/src

docker build -t jenkins:jcasc .



