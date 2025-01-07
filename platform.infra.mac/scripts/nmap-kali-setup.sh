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
cd /usr/lib/python3.11
sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED.original
sudo pip install setuptools==62.0.0
pip show setuptools
cd ~/nmap
sudo make install

## Zenmap
### Run Zenmap:
cd ~/nmap/zenmap
./zenmap





