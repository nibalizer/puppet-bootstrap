#!/bin/bash

unsupported() {
  echo "This operating system is not yet supported."
  exit 1
}

debian_puppet_install() {
  local release=$1
  wget -O /tmp/puppetlabs-release-${release}.deb https://apt.puppetlabs.com/puppetlabs-release-pc1-${release}.deb
  dpkg -i /tmp/puppetlabs-release-${release}.deb
  rm /tmp/puppetlabs-release-${release}.deb
  sudo apt-get update
  apt-get update
  apt-get install -y puppet-agent
}

redhat_puppet_install() {
  local release=$1
  rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-pc1-${release}.noarch.rpm
  yum install -y puppet-agent
}

if [ -f /etc/lsb-release ] ; then
  if grep precise /etc/lsb-release &>/dev/null ; then
    release=precise
  elif grep trusty /etc/lsb-release &>/dev/null ; then
    release=trusty
  else
    unsupported
  fi
  debian_puppet_install $release
elif [ -f /etc/debian_version ] ; then
  if grep ^6 /etc/debian_version ; then
    release='squeeze'
  elif grep ^7 /etc/debian_version ; then
    release='wheezy'
  else
    unsupported
  fi
  debian_puppet_install $release
elif [ -f /etc/redhat-release ] ; then
  if grep "Red Hat" /etc/redhat-release || grep "CentOS" /etc/redhat-release; then
    platform='el'
  elif grep "Fedora" /etc/redhat-release ; then
    platform='fedora'
  else
    unsupported
  fi
  release=$(grep ' release [0-9]' /etc/redhat-release | sed -n 's/.* release \([0-9]*\).*$/\1/p')
  redhat_puppet_install "${platform}-${release}"
else
  unsupported
fi

if [ -f /etc/puppet/puppet.conf ] ; then
  sed -i '/templatedir/d' /etc/puppet/puppet.conf
else
  echo "Puppet setup failed."
  exit 1
fi
