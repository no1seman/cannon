
#!/bin/bash

# Before you begin:
# 0. Install centos 7 (CentOS-7-x86_64-Minimal-2009.iso will be enough)
# 1. Setup network via nmtui with public internet available
# 2. Copy cannon-0.0.1-0.rpm to /tmp
# 3. Run this script anyways (root privileges needed)

# Disable selinux
sudo setenforce 0

# Stop firewall
sudo systemctl stop firewalld

# install Tarantool repo
curl -L https://tarantool.io/installer.sh | sudo -E bash -s -- --repo-only

# install dependencies
sudo yum -y install cartridge-cli tarantool

# Change dir to /tmp
cd /tmp

# install application
sudo yum -y install cannon-0.0.1-0.rpm

# Change dir to app dir
cd /usr/share/tarantool/cannon

# Run boostrap
make all
