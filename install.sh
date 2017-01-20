#!/bin/sh
#
#
# This script install puppet sources
#
# Usage : install.sh [agent|server] [hostname] [puppet_ip] [puppet_dns]

PACKAGE_NAME=""
FILENAME="puppetlabs-release-pc1-jessie.deb"

case $1 in
 "agent")
    PACKAGE_NAME="puppet-agent"
    [ "$#" -ne 4 ] && echo "Agent parameters are wrong" && exit 1
    echo "$3\t$4" >> /etc/hosts
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
apt-get install -y ca-certificates >/dev/null 2>&1

[ $? -ne 0 ] && echo "Packages / Download failed" && exit 1

wget -P /tmp/ -q https://apt.puppetlabs.com/$FILENAME

[ $? -ne 0 ] && echo "Puppetlabs / Downlaod failed" && exit 1

dpkg -i /tmp/puppetlabs-release-pc1-jessie.deb >/dev/null 2>&1

[ $? -ne 0 ] && echo "Puppetlabs / Installation failed" && exit 1

apt-get update >/dev/null 2>&1

[ $? -ne 0 ] && echo "Update failed" && exit 1

apt-get install -y $PACKAGE_NAME >/dev/null 2>&1

if [ $? -eq 0 ]; then
  if [ $1 = "agent" ]; then
    [ ! -f /etc/puppetlabs/puppet/puppet.conf ] && echo "Puppet Agent .conf not found" && exit 1
    cat << EOF > /etc/puppetlabs/puppet/puppet.conf
[main]
certname = $2.ynov.co
server = $4
environment = production
runinterval = 10m
EOF
  fi
  echo "Successfully"
  echo "##"
  echo "## Please run : /opt/puppetlabs/bin/puppet agent -t"
  echo "##"
else
  echo "$PACKAGE_NAME installation failed"
  exit 1
fi
