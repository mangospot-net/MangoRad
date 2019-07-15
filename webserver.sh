#! /bin/bash
echo ">>> Installing WebServer <<<"
sudo apt-get install -y apache2 php php-curl php-mbstring php-xml php-gd php-dev php-pear php-ssh2 libmcrypt-dev mcrypt make
sleep 2
sudo pecl install mcrypt-1.0.1
echo -ne '\n'
echo ">>> Finished Installing WebServer"
sleep 2
