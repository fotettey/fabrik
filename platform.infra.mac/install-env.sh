#!/bin/bash

# This Bash script provisions VM-backed platform in automated workflow. It delivers all required base VMs using Vagrant,
# Ansible and/or scripts.

ARCH=`arch`
ARM_LINUX_PREFERRED=rocky
PRIMARY_DB=db-postgres
SECONDARY_DB=db-mysql
WKG_DIR=`pwd`
SECRETS_VAULT=secret-vault

# Provision Check and Provision for VAULT VM:
cd $WKG_DIR/$SECRETS_VAULT
vagrant up
vagrant scp ~/Documents/VAGRANT-DEVBOX-DOCUMENTS/vault-data vault:/home/vagrant
VAULT_IP=$(vagrant ssh vault -c "ip address show eth0 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'")

# Provision Check and Provision for DB:
cd $WKG_DIR/$PRIMARY_DB
vagrant up
vagrant scp ~/Documents/VAGRANT-DEVBOX-DOCUMENTS/postgres-data postgres:/home/vagrant
POSTGRES_IP=$(vagrant ssh postgres -c "ip address show eth0 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'")


# Provisioning Other VMs
if [[ "$ARCH" == "x86_64" || "$ARCH" == "amd64" ]]; then
    echo "Architecture is x86_64 or amd64. Using Windows base"
    ## Setting up build VMs
    cd $WKG_DIR/build-$AMD_LINUX_PREFERRED
    vagrant up   
elif [[ "$ARCH" == "arm64" ]]; then
    echo "Architecture is arm64. Using Mac M-chipset"
    ## Setting up build VMs
    cd $WKG_DIR/build-$ARM_LINUX_PREFERRED
    vagrant up    
else
    echo "Architecture is not recognized. Check and Fix Vagrantfile"
fi

##########################################################################
###################### Checking VMs status ###############################
##########################################################################
vagrant global-status
##########################################################################
##########################  VMs are UP! ##################################
##########################################################################




## Setting up Ansible Hosts Inventory
JENKINS_IP=$(vagrant ssh jenkins -c "ip address show eth0 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'")
SONAR_IP=$(vagrant ssh sonar -c "ip address show eth0 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'")
NEXUS_IP=$(vagrant ssh nexus -c "ip address show eth0 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'")


## Saving IPs to Ansible Hosts file
cat <<EOF > ../ansible/hosts
[ vault ]
$VAULT_IP

[ postgres ]
$POSTGRES_IP

[ jenkins ]
$JENKINS_IP

[ sonar ]
$SONAR_IP

[ nexus ]
$NEXUS_IP

EOF


# Formatting IPs for /etc/hosts file:
cat <<EOF > ../ansible/etc-hosts

$VAULT_IP       vault.dev.local.self

$POSTGRES_IP    db.shared-postgres.self

$JENKINS_IP     jenkins.build.fotettey.hub

$SONAR_IP       sonar.build.fotettey.hub

$NEXUS_IP       nexus.build.fotettey.hub

EOF


## Copying apps data to respective VMs:
vagrant scp ~/Documents/VAGRANT-DEVBOX-DOCUMENTS/jenkins-data jenkins:/home/vagrant
vagrant scp ~/Documents/VAGRANT-DEVBOX-DOCUMENTS/sonar-data sonar:/home/vagrant
vagrant scp ~/Documents/VAGRANT-DEVBOX-DOCUMENTS/nexus-data nexus:/home/vagrant
## Copying custom /etc/hosts data to respective VMs:
vagrant scp $WKG_DIR/ansible/etc-hosts jenkins:/home/vagrant
vagrant scp $WKG_DIR/ansible/etc-hosts sonar:/home/vagrant
vagrant scp $WKG_DIR/ansible/etc-hosts nexus:/home/vagrant
## Copying custom /etc/hosts data to Vault VM:
cd $WKG_DIR/$SECRETS_VAULT
vagrant scp $WKG_DIR/ansible/etc-hosts vault:/home/vagrant
## Copying custom /etc/hosts data to DB VM:
cd $WKG_DIR/$PRIMARY_DB
vagrant scp $WKG_DIR/ansible/etc-hosts postgres:/home/vagrant

## Copying Ansible Hosts to MGMT VM:
cd ~/Documents/GitHub/devtools/vagrant.devbox.mac.m1
vagrant scp ~/Documents/VAGRANT-DEVBOX-DOCUMENTS/vault-data vm:/home/vagrant/projects || echo "VM unavailable"
vagrant scp $WKG_DIR/ansible/etc-hosts vm:/home/vagrant/projects || echo "VM unavailable"
vagrant scp $WKG_DIR/ansible/hosts vm:/home/vagrant/projects || echo "VM unavailable"