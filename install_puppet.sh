#!/bin/bash

if cat /etc/issue | grep 14.04 >/dev/null ; then

	wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
	sudo dpkg -i puppetlabs-release-trusty.deb
	sudo apt-get update
	apt-get install -y puppet
fi

if cat /etc/issue | grep 12.04 >/dev/null; then

	wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
	sudo dpkg -i puppetlabs-release-precise.deb
	sudo apt-get update
	apt-get install -y puppet
fi

sed -i '/templatedir/d' /etc/puppet/puppet.conf

