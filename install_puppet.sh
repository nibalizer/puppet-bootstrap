#!/bin/bash

unsupported() {
  echo "This operating system is not yet supported."
  exit 1
}

debian_puppet_install() {
  local release=$1
  wget -O /tmp/puppetlabs-release-${release}.deb https://apt.puppetlabs.com/puppetlabs-release-${release}.deb
  dpkg -i /tmp/puppetlabs-release-${release}.deb
  rm /tmp/puppetlabs-release-${release}.deb
  apt-get update
  apt-get install -y puppet
}

redhat_puppet_install() {
  local release=$1
  rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-${release}.noarch.rpm
  yum install -y puppet
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
  if grep "release 5" /etc/redhat-release &>/dev/null ; then
    release=5
  elif grep "release 6" /etc/redhat-release &>/dev/null ; then
    release=6
  elif grep "release 7" /etc/redhat-release &>/dev/null ; then
    release=7
  else
    unsupported
  fi
  redhat_puppet_install $release
else
  unsupported
fi

if [ -f /etc/puppet/puppet.conf ] ; then
  sed -i '/templatedir/d' /etc/puppet/puppet.conf
else
  echo "Puppet setup failed."
fi
