#!/bin/bash

# This Bash script deletes platform in automated workflow. It destroys all provisioned base VMs using Vagrant,
# Ansible and/or scripts.

ARCH=`arch`
ARM_LINUX_PREFERRED=rocky
PRIMARY_DB=db-postgres
SECONDARY_DB=db-mysql
WKG_DIR=`pwd`
SECRETS_VAULT=secret-vault


# Halting DB VM:
cd $WKG_DIR/$PRIMARY_DB
vagrant scp postgres:/home/vagrant/postgres-data/app-data ~/Documents/VAGRANT-DEVBOX-DOCUMENTS/postgres-data/
vagrant destroy --force

# Halting VAULT VM:
cd $WKG_DIR/$SECRETS_VAULT
vagrant scp vault:/home/vagrant/vault-data/app-data ~/Documents/VAGRANT-DEVBOX-DOCUMENTS/vault-data/
vagrant destroy --force


# Platform based deletion
if [[ "$ARCH" == "x86_64" || "$ARCH" == "amd64" ]]; then
    echo "Architecture is x86_64 or amd64. Using Windows base"
    ## Destroying build VMs
    cd $WKG_DIR/build-$AMD_LINUX_PREFERRED
    ## Copying apps data to local host:
    vagrant scp jenkins:/home/vagrant/jenkins-data/app-data ~/Documents/VAGRANT-DEVBOX-DOCUMENTS/jenkins-data/
    vagrant scp sonar:/home/vagrant/sonar-data/app-data ~/Documents/VAGRANT-DEVBOX-DOCUMENTS/sonar-data/
    vagrant scp nexus:/home/vagrant/nexus-data/app-data ~/Documents/VAGRANT-DEVBOX-DOCUMENTS/nexus-data/
    vagrant destroy --force
elif [[ "$ARCH" == "arm64" ]]; then
    echo "Architecture is arm64. Using Mac M-chipset"
    ## Destroying build VMs
    cd $WKG_DIR/build-$ARM_LINUX_PREFERRED
    ## Copying apps data to local host:
    vagrant scp jenkins:/home/vagrant/jenkins-data/app-data ~/Documents/VAGRANT-DEVBOX-DOCUMENTS/jenkins-data/
    vagrant scp sonar:/home/vagrant/sonar-data/app-data ~/Documents/VAGRANT-DEVBOX-DOCUMENTS/sonar-data/
    vagrant scp nexus:/home/vagrant/nexus-data/app-data ~/Documents/VAGRANT-DEVBOX-DOCUMENTS/nexus-data
    vagrant destroy --force  
else
    echo "Architecture is not recognized. Check and Fix Vagrantfile"
fi

##########################################################################
###################### Checking VMs status ###############################
##########################################################################
vagrant global-status
##########################################################################
################# Build Stage VMs are Destroyed! #########################
##########################################################################


