#!/bin/sh
#
#
# This script install puppet sources
# 
# Usage : install.sh [agent|server]

PACKAGE_NAME=""
FILENAME="puppetlabs-release-pc1-jessie.deb"

if [ $# -ne 1 ]; then
  echo "This script must be contains 1 argument [agent|server]"
  exit 1
fi

case $1 in
 "agent")
    PACKAGE_NAME="puppet-agent"
    ;;
  "server")
    PACKAGE_NAME="puppetserver"
    ;;
  *)
    echo "Wrong argument (agent|server)"
    exit 1
    ;;
esac

echo "Install required packages..."
apt-get install ca-certificates &>/dev/null

[ $? -ne 0 ] && echo "Packages / Download failed" && exit 1

wget -P /tmp/ -q https://apt.puppetlabs.com/$FILENAME

[ $? -ne 0 ] && echo "Puppetlabs / Downlaod failed" && exit 1

dpkg -i --force /tmp/puppetlabs-release-pc1-jessie.deb &>/dev/null

[ $? -ne 0 ] && echo "Puppetlabs / Installation failed" && exit 1

apt-get update &>/dev/null

[ $? -ne 0 ] && echo "Update failed" && exit 1

apt-get install $PACKAGE_NAME &>/dev/null

if [ $? -eq 0 ]; then
  echo "Successfully"
else
  echo "$PACKAGE_NAME installation failed"
  exit 1
fi
