#!/bin/bash

###############
#  VARIABLES  #
###############

if ! $1; then
    echo "Please specify the server type"
    echo "* available: --real --sorry"
    exit 1
fi
SERVER=${1/--/}

########################
#  INSTALL KEEPALIVED  #
########################

# Install keepalived
apt-get install keepalived -y

# Overwrite keepalived configuration
rm -rf /etc/keepalived/keepalived.conf
curl https://raw.githubusercontent.com/haeramkeem/infra-exercise/main/KubernetesEnv/online-ubuntu-20.04-HA/keepalived.$SERVER.conf -o /etc/keepalived/keepalived.conf
systemctl restart keepalived