#!/bin/bash

if grep Ubuntu /etc/*-release &>/dev/null ; then
  for release in trusty precise ; do
    if grep $release /etc/*-release &>/dev/null ; then
      wget -O /tmp/puppetlabs-release-${release}.deb https://apt.puppetlabs.com/puppetlabs-release-${release}.deb
      dpkg -i /tmp/puppetlabs-release-${release}.deb
      rm /tmp/puppetlabs-release-${release}.deb
    fi
  done
  apt-get update
  apt-get install -y puppet
elif grep "\(CentOS\|RedHat\)" /etc/*-release &>/dev/null ; then
  for release in 5 6 7 ; do
    if grep "release $release" /etc/*-release &>/dev/null ; then
      rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-${release}.noarch.rpm
      yum install -y puppet
      break
    fi
  done
else
  echo "This operating system is not yet supported."
fi

if [ -f /etc/puppet/puppet.conf ] ; then
  sed -i '/templatedir/d' /etc/puppet/puppet.conf
else
  echo "Puppet setup failed."
fi
