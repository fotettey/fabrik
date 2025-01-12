#!/bin/bash

## Source:
# https://youtu.be/dJjQoxwyNCc

# Installing NMAP from Source
## Install all dependencies
sudo apt install libssl-dev autoconf make g++ subversion -y
cd ~
svn co https://svn.nmap.org/nmap/
cd ~/nmap
./configure --help
./configure
# make
## for Errors such as "...make: *** [Makefile:364: install-zenmap] Error 1"
## It is required to downgrade pip:setuptools to 62.0.0 as discussed here: https://github.com/nmap/nmap/issues/2714#issuecomment-1871329317
## REQUIRED FIX: https://askubuntu.com/questions/1471898/makefile372-install-zenmap-error-1

PYTHON_VERSION=$(python3 --version | awk '{print $2}' | cut -d. -f1,2)

cd /usr/lib/python$PYTHON_VERSION
sudo rm /usr/lib/$PYTHON_VERSION/EXTERNALLY-MANAGED.original
sudo pip install setuptools==62.0.0
pip show setuptools
cd ~/nmap
sudo make install

## Zenmap
### Run Zenmap:
cd ~/nmap/zenmap
./zenmap





