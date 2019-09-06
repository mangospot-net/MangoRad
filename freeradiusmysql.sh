#!/bin/bash
echo ">>> Installing FreeRadius Mysql <<<"

if [ -z $1 ]
then
	echo ''
	read -sp "Confirm MySQL root password : " paswd
else 
	paswd=$1
fi
[[ -z $paswd ]] && { echo "Password is required!"; exit 1; }

# default version
RADIUS_VERSION='3.0'

# Install FreeRadius
 sudo apt-get install -y freeradius freeradius-utils freeradius-mysql

cd /etc/freeradius/$RADIUS_VERSION/mods-enabled
sudo ln -s ../mods-available/sql sql
sudo ln -s ../mods-available/sqlcounter sqlcounter
cd

# Create Database MySQL
if [ -z $2 ]
then
	echo ''
	read -p "Create database name : " db
else
	db=$2
fi
[[ -z $db ]] && { echo "Database is required!"; exit 1; }

mysql -uroot -p$paswd -e "CREATE DATABASE $db;"

# Import Schema
echo "Import Database?"
echo "  1) FreeRadius Default"
echo "  2) FreeRadius + MangoSpot" 

read n
case $n in
	1)
	   mysql -uroot -p$paswd $db < /etc/freeradius/$RADIUS_VERSION/mods-config/sql/main/mysql/schema.sql
	;;
	2)
	   mysql -uroot -p$paswd $db < ~/MangoRad/config/mysql/schema.sql
	   echo "Proccess....."
	   mysql -uroot -p$paswd $db < ~/MangoRad/config/mysql/data.sql
	   echo "Finish......."
	;;
esac

# Config Sites Default
    sudo mv /etc/freeradius/$RADIUS_VERSION/sites-available/default /etc/freeradius/$RADIUS_VERSION/sites-available/default.back
    sudo cp ~/MangoRad/config/default /etc/freeradius/$RADIUS_VERSION/sites-available/default

# Config Sites Tunnel
    sudo mv /etc/freeradius/$RADIUS_VERSION/sites-available/inner-tunnel /etc/freeradius/$RADIUS_VERSION/sites-available/inner-tunnel.back
    sudo cp ~/MangoRad/config/inner-tunnel /etc/freeradius/$RADIUS_VERSION/sites-available/inner-tunnel

# Config database
    sudo mv /etc/freeradius/$RADIUS_VERSION/mods-available/sql /etc/freeradius/$RADIUS_VERSION/mods-available/sql.back
    sudo cp ~/MangoRad/config/mysql/sql /etc/freeradius/$RADIUS_VERSION/mods-available/sql
	sed -i "s/mangopass/$paswd/" /etc/freeradius/$RADIUS_VERSION/mods-available/sql
	sed -i "s/mangodb/$db/" /etc/freeradius/$RADIUS_VERSION/mods-available/sql

# Config sqlcounter
	sudo mv /etc/freeradius/$RADIUS_VERSION/mods-available/sqlcounter /etc/freeradius/$RADIUS_VERSION/mods-available/sqlcounter.back
	sudo cp ~/MangoRad/config/sqlcounter /etc/freeradius/$RADIUS_VERSION/mods-available/sqlcounter

# Add query sqlcounter
	sudo cp ~/MangoRad/config/mysql/accessperiod.conf /etc/freeradius/$RADIUS_VERSION/mods-config/sql/counter/mysql/accessperiod.conf
	sudo cp ~/MangoRad/config/mysql/quotalimit.conf /etc/freeradius/$RADIUS_VERSION/mods-config/sql/counter/mysql/quotalimit.conf

# Change Group
sudo chgrp -h freerad /etc/freeradius/$RADIUS_VERSION/mods-enabled/sql
sudo pkill radius

# Start & Enable FreeRadius
sudo systemctl start freeradius
sudo systemctl enable freeradius

echo ">>> Finished Installing FreeRadius <<<"
sleep 2
