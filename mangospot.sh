#!/bin/bash

echo ">>> Installing MangoSpot <<<"

[[ -z $1 ]] && { echo "Database does not match! (sudo ./mangospot mysql or pgsql)"; exit 1; }

if [ -z $2 ] 
then
    echo ''
    read -sp "Confirm database password : " pswd
else
    pswd=$2
fi

if [ -z $3 ]
then
    echo ''
    read -p "Select Database : " dbmango
else
    dbmango=$3
fi

[[ -z $pswd ]] && { echo "Password is required!"; exit 1; }
[[ -z $dbmango ]] && { echo "Database is required!"; exit 1; }

# Download MangoSpot
if [ -d "/var/www/MangoSpot/" ]
then
    echo "Directory MangoSpot exists."
else
    cd /var/www
    sudo git clone https://github.com/mangospot-net/MangoSpot.git
    cd
fi

# Create virtualhost
sudo cat > /etc/apache2/conf-available/mangospot.conf << ENDOFFILE
Alias /mangospot /var/www/MangoSpot
<Directory />
    Options FollowSymLinks
    AllowOverride All
</Directory>
<Directory /var/www/MangoSpot/>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
    Order allow,deny
    allow from all
</Directory>
ENDOFFILE

# Edit connection to database
if [ $1 == 'mysql' ]
then
    sed -i 's/"TYPE", ".*"/"TYPE", "mysql"/' /var/www/MangoSpot/include/config.php
    sed -i 's/"DB_USER", ".*"/"DB_USER", "root"/' /var/www/MangoSpot/include/config.php
elif [ $1 == 'pgsql' ] 
then
    sed -i 's/"TYPE", ".*"/"TYPE", "pgsql"/' /var/www/MangoSpot/include/config.php
    sed -i 's/"DB_USER", ".*"/"DB_USER", "postgres"/' /var/www/MangoSpot/include/config.php
else
    echo "Database does not match!" 
    exit 1
fi

sed -i 's/"DB_PASSWORD", ".*"/"DB_PASSWORD", "'$pswd'"/' /var/www/MangoSpot/include/config.php
sed -i 's/"DB_DATABASE", ".*"/"DB_DATABASE", "'$dbmango'"/' /var/www/MangoSpot/include/config.php
chmod -R 777 /var/www/MangoSpot/dist/img
chmod -R 777 /var/www/MangoSpot/dist/img/bg
chmod -R 777 /var/www/MangoSpot/dist/img/users

# Enable htaccess
sudo a2enmod rewrite

# Enable mangospot.conf
sudo a2enconf mangospot.conf

# Restart apache
sudo /etc/init.d/apache2 restart

echo ">>> Finished Installing MangoSpot"
sleep 2
