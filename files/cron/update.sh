#!/bin/bash
# this code will wrap the run script and provide a process to update the puppet repository from
# a central location once the code is on github.

# move to puppet repo
echo "Starting to update /etc/puppet"
cd /etc/puppet

# update our puppet repository
git pull

# ensure the dependencies are installed
echo "Running librarian-puppet to enusre all puppet modules are installed correctly."
librarian-puppet install --verbose

# and perform our puppet run
freepuppet-run