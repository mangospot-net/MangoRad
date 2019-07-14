#!/bin/bash

echo ">>> Installing PostgreSQL <<<"
if [ -z $1 ]
then
	echo ''
	read -sp "Confirm PostgreSQL password : " pswd
else 
	pswd=$1
fi
[[ -z $pswd ]] && { echo "Password is required!"; exit 1; }
# Set some variables
POSTGRE_VERSION=10

# Install PostgreSQL
sudo apt-get install -y php-pgsql postgresql postgresql-contrib

# Listen for localhost connections
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/$POSTGRE_VERSION/main/postgresql.conf

# Identify users via "md5", rather than "ident", allowing us
echo "host    all             all             0.0.0.0/0             md5" | sudo tee -a /etc/postgresql/$POSTGRE_VERSION/main/pg_hba.conf
echo "host    all             all             ::0/0               	md5" | sudo tee -a /etc/postgresql/$POSTGRE_VERSION/main/pg_hba.conf

# Start & Enable PostgreSQL
sudo systemctl start postgresql.service
sudo systemctl enable postgresql.service

# Create new password superuser "postgres"
su - postgres -c "psql -U postgres -d postgres -c \"alter user postgres with password '$pswd';\""

# Make sure changes are reflected by restarting
sudo service postgresql restart

echo ">>> Finished Installing PostgreSQL <<<"
sleep 2