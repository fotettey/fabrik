#!/bin/bash

## Source:
# https://youtu.be/dJjQoxwyNCc

## Updating packages and cleanup
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get autoremove
sudo apt-get clean

## Setting up ProxyChains
# 1. Review ProxyChains conf to ensure that only default OR dynamic mode is enabled/uncommented, 
# proxy_dns - uncommented, and lastly that proxy IPs in last section are configured based on video guide: https://youtu.be/dJjQoxwyNCc?t=730

## Copying proxychains config:
sudo cp /vagrant/projects/codebank/scripts/proxychains4.conf /etc/
sudo chown $whoami:$whoami /etc/proxychains4.conf

# 2. Install TOR service/browser on Kali instance
sudo apt install tor -y

# 3. Start Tor service
sudo service tor start
## sudo service tor status
systemctl --no-pager status tor

# 4. Start/Use Proxychains
proxychains firefox





