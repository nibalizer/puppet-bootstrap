#!/bin/bash

curl http://nibalizer.com/install_puppet.sh | bash

cp /etc/hiera.yaml /etc/puppet/hiera.yaml

if [ `facter osfamily` == 'RedHat' ] ; then
  puppet module install stahnma-epel
fi
if [ `facter osfamily` == 'Debian' ] ; then
  apt-get update
fi
puppet module install saz-vim
puppet module install puppetlabs-git
puppet module install puppetlabs-inifile

cat > /tmp/base.pp <<EOF
  # Fix puppet.conf
  ini_setting { 'disable_warnings':
    ensure  => present,
    path    => '/etc/puppet/puppet.conf',
    section => 'main',
    setting => 'disable_warnings',
    value   => 'deprecations',
  }
  ini_setting { 'templatedir':
    ensure => absent,
    path   => '/etc/puppet/puppet.conf',
  }

  # Install packages
  if $::osfamily == 'RedHat' {
    include epel
  }
  include git
  include vim
EOF
puppet apply /tmp/base.pp
rm /tmp/base.pp
