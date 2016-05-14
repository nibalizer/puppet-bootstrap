#!/bin/bash

git pull

scp install_puppet.sh root@tesla.nibalizer.com:/var/www/html/install_puppet.sh
scp install_puppet4.sh root@tesla.nibalizer.com:/var/www/html/install_puppet4.sh
scp provision.sh root@tesla.nibalizer.com:/var/www/html/provision.sh
ssh root@tesla.nibalizer.com 'chmod 644 /var/www/html/{install_puppet.sh,install_puppet4.sh,provision.sh}'
