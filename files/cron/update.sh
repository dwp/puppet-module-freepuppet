#!/bin/bash
# this code will wrap the run script and provide a process to update the puppet repository from
# a central location once the code is on github.

# update our puppet repository
git -C /etc/puppet git pull

# run freepuppet
/usr/local/bin/freepuppet-run