#!/bin/bash
echo ">>> Installing FreeRadius <<<"

if [ -z $1 ]
then
	echo ''
	read -sp "Confirm PostgreSQL password : " paswd
else 
	paswd=$1
fi
[[ -z $paswd ]] && { echo "Password is required!"; exit 1; }

# default version
RADIUS_VERSION='3.0'

# Install FreeRadius
 sudo apt-get install -y freeradius freeradius-utils freeradius-pgsql

cd /etc/freeradius/$RADIUS_VERSION/mods-enabled
sudo ln -s ../mods-available/sql sql
sudo ln -s ../mods-available/sqlcounter sqlcounter
cd

# Create Database PostgreSQL
echo ">>> Create Database"
if [ -z $2 ]
then
	echo ''
	read -p "Create database name : " db
else
	db=$2
fi
[[ -z $db ]] && { echo "Database is required!"; exit 1; }
sudo -u postgres psql -c "CREATE DATABASE $db;"

# Import Schema
echo "Import Database?"
echo "  1) FreeRadius Default"
echo "  2) FreeRadius + MangoSpot" 

read n
case $n in
	1)
	   sudo -u postgres psql $db < /etc/freeradius/$RADIUS_VERSION/mods-config/sql/main/postgresql/schema.sql
	;;
	2)
	   sudo -u postgres psql $db < ./config/postgresql/schema.sql
	   echo "Proccess....."
	   sudo -u postgres psql $db < ./config/postgresql/data.sql
	   echo "Finish......."
	;;
esac

# Config Sites Default
    sudo mv /etc/freeradius/$RADIUS_VERSION/sites-available/default /etc/freeradius/$RADIUS_VERSION/sites-available/default.back
    sudo cp ./config/default /etc/freeradius/$RADIUS_VERSION/sites-available/default

# Config Sites Tunnel
    sudo mv /etc/freeradius/$RADIUS_VERSION/sites-available/inner-tunnel /etc/freeradius/$RADIUS_VERSION/sites-available/inner-tunnel.back
    sudo cp ./config/inner-tunnel /etc/freeradius/$RADIUS_VERSION/sites-available/inner-tunnel

# Config database
    sudo mv /etc/freeradius/$RADIUS_VERSION/mods-available/sql /etc/freeradius/$RADIUS_VERSION/mods-available/sql.back
    sudo cp ./config/postgresql/sql /etc/freeradius/$RADIUS_VERSION/mods-available/sql
	sed -i "s/mangopass/$paswd/" /etc/freeradius/$RADIUS_VERSION/mods-available/sql
	sed -i "s/mangodb/$db/" /etc/freeradius/$RADIUS_VERSION/mods-available/sql

# Config sqlcounter
	sudo mv /etc/freeradius/$RADIUS_VERSION/mods-available/sqlcounter /etc/freeradius/$RADIUS_VERSION/mods-available/sqlcounter.back
	sudo cp ./config/sqlcounter /etc/freeradius/$RADIUS_VERSION/mods-available/sqlcounter

# Add query sqlcounter
	sudo cp ./config/postgresql/accessperiod.conf /etc/freeradius/$RADIUS_VERSION/mods-config/sql/counter/postgresql/accessperiod.conf
	sudo cp ./config/postgresql/quotalimit.conf /etc/freeradius/$RADIUS_VERSION/mods-config/sql/counter/postgresql/quotalimit.conf

# Change Group
sudo chgrp -h freerad /etc/freeradius/$RADIUS_VERSION/mods-enabled/sql
sudo pkill radius

# Start & Enable FreeRadius
sudo systemctl start freeradius
sudo systemctl enable freeradius

echo ">>> Finished Installing FreeRadius <<<"
sleep 2