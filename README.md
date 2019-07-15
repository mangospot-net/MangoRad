# MangoRad
Bash Script Installer MangoSpot Radius Server (Webserver, Mysql, PostgreSQL, FreeRadius) for Debian / Ubuntu
## Install 
```
- install git
```
```
- git clone https://github.com/mangospot-net/MangoRad.git
```
or
```
- wget https://github.com/mangospot-net/MangoRad/archive/master.zip
- unzip *.zip
```
```
- cd MangoRad
- sudo chmod +x install.sh
- sudo ./install.sh
```
### Custom Install
Install WebServer
```
sudo chmod +x webserver.sh
sudo ./webserver.sh
```
Install MariaDB
```
sudo chmod +x mariadb.sh
sudo ./mariadb.sh
```
Install PostgreSQL
```
sudo chmod +x postgresql.sh
sudo ./postgresql.sh
```
Install FreeRadius + MySQL
```
sudo chmod +x freeradiusmysql.sh
sudo ./freeradiusmysql.sh
```
Install FreeRadius + PostgreSQL
```
sudo chmod +x freeradiuspgsql.sh
sudo ./freeradiuspgsql.sh
```
Install MangoSpot + MySQL
```
sudo chmod +x mangospot.sh
sudo ./mangospot.sh mysql
```
Install MangoSpot PostgreSQL
```
sudo chmod +x mangospot.sh
sudo ./mangospot.sh pgsql
```
[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=8CRUEDLPLCFSQ)
