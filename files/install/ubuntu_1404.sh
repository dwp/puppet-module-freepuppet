#!/bin/bash
# Bash installation script for Ubuntu to install the requied packages, tested on Ubuntu 14.04

MANIFEST_NAME_FILE=/etc/puppet/manifest
NODE_NAME_FILE=/etc/puppet/certname

# setup required modules
apt-get update
apt-get upgrade -y
apt-get install puppet-common git rubygems-integration -y

# install librarian pupet
gem install librarian-puppet

# clean out the existing puppet install and pull in our repository
rm -rf /etc/puppet
git clone https://github.com/dwpdigitaltech/innovation-puppet.git /etc/puppet

# then run a librarian-puppet install
cd /etc/puppet
/usr/local/bin/librarian-puppet install --verbose

# setup manifest file to run
echo "Please enter the name of the manifest file you wish to run:"
read MANIFEST_NAME
if [ ! -f "${MANIFEST_NAME_FILE}" ]
then 
    echo -n "${MANIFEST_NAME}" > "${MANIFEST_NAME_FILE}"
fi

# setup and dump out certname
echo "Please enter the node name you wish to configure for this server:"
read NODE_NAME
if [ ! -f NODE_NAME_FILE ]
then 
    echo -n "${NODE_NAME}" > "${NODE_NAME_FILE}"
fi

# now perform our first puppet run
/usr/bin/puppet apply --certname $NODE_NAME --modulepath /etc/puppet/modules /etc/puppet/manifests/${MANIFEST_NAME}.pp