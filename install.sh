#! /bin/bash

# Update & Upgrade
read -p "Are you want to Update this system [y/n] " update
if [[ $update =~ ^[Yy]$ ]]
	then
		sudo apt-get update -y
		read -p "Are you want to upgrade this system [y/n] " upgrade
		if [[ $upgrade =~ ^[Yy]$ ]]
		then 
			sudo apt-get upgrade -y
		fi

fi 

# Install modul
read -p "Install wget, curl, git, zip, unzip [y/n] " modul
if [[ $modul =~ ^[Yy]$ ]]
	then
		sudo apt-get install -y wget curl git zip unzip
fi

# Install webserver
read -p "Install Webserver (Apache2 & PHP) [y/n] " webserver
if [[ $webserver =~ ^[Yy]$ ]]
then
	sudo chmod +x webserver.sh
	sudo ./webserver.sh
fi

read -p "Create New Database : " databases
echo ''
read -sp "Password Database : " pswdsql
echo ''
# Change database
echo "Select the database?"
echo "  1) MariaDB (MySQL)"
echo "  2) PostgreSQL" 
read n
case $n in
	1)
		# Install MariaDB
		sudo chmod +x mariadb.sh
		sudo ./mariadb.sh $pswdsql

		# Install FreeRadius + MySQL
		sudo chmod +x freeradiusmysql.sh
		sudo ./freeradiusmysql.sh $pswdsql $databases

		# Download MangoSpot
		sudo chmod +x mangospot.sh
		sudo ./mangospot.sh mysql $pswdsql $databases
	;;
	2) 
		# Install PostgreSQL
		sudo chmod +x postgresql.sh
		sudo ./postgresql.sh $pswdsql

		# Install FreeRadius + PostgreSQL
		sudo chmod +x freeradiuspgsql.sh
		sudo ./freeradiuspgsql.sh $pswdsql $databases

		# Download MangoSpot
		sudo chmod +x mangospot.sh
		sudo ./mangospot.sh pgsql $pswdsql $databases
	;;
esac
