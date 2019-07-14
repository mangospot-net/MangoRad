#!/bin/bash

echo ">>> Installing MariaDB <<<"

# default version
MARIADB_VERSION='10.1'

# Install MariaDB
sudo apt-get install -y php-mysql mariadb-server mariadb-client
sudo mysql_secure_installation

# Make Maria connectable from outside world without SSH tunnel
echo ''
read -p "Enable remote access this MariaDB [y/n] " remotemysql
if [[ $remotemysql =~ ^[Yy]$ ]]
then
    if [ -z $1 ]
    then
        echo ''
        read -sp "Confirm MySQL root password : " pswd
    else
        pswd=$1
    fi
    if [ -z $pswd ]
    then
        echo "Password is required!"
		exit 1
	else
    	# enable remote access
    	sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

    	# adding grant privileges to mysql root user from everywhere
    	MYSQL='mysql'
        Q1="GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$pswd' WITH GRANT OPTION;"
        Q2="FLUSH PRIVILEGES;"
        Q3="UPDATE mysql.user SET plugin='' WHERE user='root';"
        Q4="FLUSH PRIVILEGES;"
        SQL="${Q1}${Q2}${Q3}${Q4}"

    	$MYSQL -uroot -p$pswd -e "$SQL"

		# Restart MySQL
    	sudo service mysql restart
    fi
fi
echo ">>> Finished Installing MariaDB"
sleep 2