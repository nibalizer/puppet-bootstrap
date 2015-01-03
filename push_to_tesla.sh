#!/bin/bash

git pull

scp install_puppet.sh root@tesla.nibalizer.com:/var/www/html/install_puppet.sh
scp provision.sh root@tesla.nibalizer.com:/var/www/html/provision.sh
