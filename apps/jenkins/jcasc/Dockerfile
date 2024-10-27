  # Jenkins CASC configuration done ff doc:
  # https://www.digitalocean.com/community/tutorials/how-to-automate-jenkins-setup-with-docker-and-jenkins-configuration-as-code


FROM jenkins/jenkins:2.482
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt
 # https://community.jenkins.io/t/how-to-generate-a-docker-with-the-desired-plugins-installed/3453/2
COPY casc.yaml /var/jenkins_home/casc.yaml
COPY src/git-auto /var/jenkins_home/git-auto
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

