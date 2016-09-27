#!/bin/bash
# configure variables
MANIFEST_NAME_FILE=/etc/puppet/manifest
NODE_NAME_FILE=/etc/puppet/certname
LOCKFILE=/run/freepuppet-run.pid

# must be running as root
if [ "$EUID" -ne 0 ]; then
	echo "=================================================="
	echo "Puppet scripts must run as root - please use sudo."
	echo "=================================================="
	exit
fi

# Pull in our enviromental settings.
echo "=================================================="

# manifest file
if [ ! -f $MANIFEST_NAME_FILE ]; then
    echo "Unable to locate manifest name file ${MANIFEST_NAME_FILE}."
    exit
fi
MANIFEST_NAME=$(<$MANIFEST_NAME_FILE)
echo "Reading manifest name - ${MANIFEST_NAME}"

# node file
if [ ! -f $NODE_NAME_FILE ]; then
    echo "Unable to locate node name file $NODE_NAME_FILE."
    exit
fi
NODE_NAME=$(<$NODE_NAME_FILE)
echo "Reading node name - ${NODE_NAME}"

echo "=================================================="

# lockfile mechanic
echo "Checking for lockfile existance at: ${LOCKFILE}"
if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
    echo "freepuppet-run is already running."
    exit
fi

# make sure the lockfile is removed when we exit and then claim it
trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
echo $$ > ${LOCKFILE}

echo "Creating lockfile and running puppet apply."
echo "/usr/bin/puppet apply --certname $NODE_NAME --modulepath /etc/puppet/modules --logdest syslog /etc/puppet/manifests/${MANIFEST_NAME}.pp"
/usr/bin/puppet apply --certname $NODE_NAME --modulepath /etc/puppet/modules --logdest syslog /etc/puppet/manifests/${MANIFEST_NAME}.pp

echo "Cleaning up lockfile."
rm -f ${LOCKFILE}
echo "=================================================="