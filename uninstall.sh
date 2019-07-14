#! /bin/bash

read -p "Are you want to remove FreeRadius [y/n] " update
if [[ $update =~ ^[Yy]$ ]]
	then
		sudo apt-get purge --auto-remove -y wget curl git zip unzip apache2 php php-curl php-mbstring php-xml php-gd php-dev php-ssh2 mcrypt libmcrypt-dev php-pear make php-mysql mariadb-server mariadb-client freeradius freeradius-utils freeradius-mysql
		sudo apt-get remove --auto-remove -y wget curl git zip unzip apache2 php php-curl php-mbstring php-xml php-gd php-dev php-ssh2 mcrypt libmcrypt-dev php-pear make php-mysql mariadb-server mariadb-client freeradius freeradius-utils freeradius-mysql
		sudo rm -r /etc/apache2
		sudo rm -r /etc/php
		sudo rm -r /etc/mysql
		sudo rm -r /etc/freeradius
		sudo rm -r /var/www/MangoSpot
fi 
