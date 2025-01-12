#!/bin/bash

## Source:
# https://youtu.be/dJjQoxwyNCc

# Installing NMAP from Source
## Install all dependencies
sudo apt install libssl-dev autoconf make g++ subversion -y
cd ~
svn co https://svn.nmap.org/nmap/
cd ~/nmap

## for Errors such as "...make: *** [Makefile:364: install-zenmap] Error 1"
## It is required to downgrade pip:setuptools to 62.0.0 as discussed here: https://github.com/nmap/nmap/issues/2714#issuecomment-1871329317
## REQUIRED FIX: https://askubuntu.com/questions/1471898/makefile372-install-zenmap-error-1

PREFERRED_PYTHON_VERSION=3.11
PYTHON_VERSION=$(python3 --version | awk '{print $2}' | cut -d. -f1,2)

# Provisioning Other VMs
PREFERRED_PYTHON_VERSION=3.11
PYTHON_VERSION=$(python3 --version | awk '{print $2}' | cut -d. -f1,2)

if [ "$PYTHON_VERSION" = "$PREFERRED_PYTHON_VERSION" ]; then
    echo "Python3.11 installed and present"
    ## Configuring & Installing NMAP
    cd /usr/lib/python$PREFERRED_PYTHON_VERSION
    sudo rm /usr/lib/$PREFERRED_PYTHON_VERSION/EXTERNALLY-MANAGED.original
    sudo pip install setuptools==62.0.0
    sudo pip install build
    pip show setuptools
    cd ~/nmap
    ./configure --help
    ./configure
    sudo make
    sudo make install
elif [ "$PYTHON_VERSION" != "$PREFERRED_PYTHON_VERSION" ]; then
    echo "Different Python3 version installed and present"
    ## Configuring & Installing NMAP
    sudo apt install python3-venv  # Ensure `venv` is installed
    python3 -m venv myenv          # Create a virtual environment
    source myenv/bin/activate      # Activate the environment
    pip install setuptools==62.0.0    # Install packages within the environment
    sudo pip install build
    ./configure --help
    ./configure
    sudo make
    sudo make install
else
    echo "Python not installed, check and fix!"
fi

## Zenmap
### Run Zenmap:
cd ~/nmap/zenmap
./zenmap





