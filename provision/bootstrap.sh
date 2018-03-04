#!/usr/bin/env bash

DATABASE_PW=''
DOMAIN="dms.dev"
DOMAIN_ROOT="/home/www/public"
DATABASE="dms"

yum clean all
yum -y install deltarpm
yum -y install epel-release
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
wget https://centos7.iuscommunity.org/ius-release.rpm
rpm -Uvh ius-release*.rpm

## NGINX
yum install nginx -y
sudo cp /home/vm-conf/conf/nginx.conf /etc/nginx/nginx.conf
service nginx start

if [ ! -d /var/www/html/ ]; then
    mkdir -p  /var/www/html
fi

## MARIA
cat >>  /etc/yum.repos.d/mariadb.repo << EOF
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.0/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
yum install -y mariadb-server
service mysql start


mysql -u root <<-EOF
UPDATE mysql.user SET Password=PASSWORD('$DATABASE_PW') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
FLUSH PRIVILEGES;
EOF

## PHP
yum install php70u-fpm php70u-fpm-nginx -y
yum install php70u-cli -y
sudo systemctl start php-fpm.service
sudo systemctl enable php-fpm.service
yum install php70u-gd php70u-imap php70u-mbstring php70u-json -y
yum install php70u-mysqlnd php70u-opcache php70u-pdo php70u-pecl-apcu -y

sudo cp /home/vm-conf/conf/www.conf /etc/php-fpm.d/www.conf

sudo service php-fpm restart

## TOOLS
yum -y install curl git
## Remove error 
##	fatal: unable to access 'https://github.com/drush-ops/drush.git/': 
##      Peer reports incompatible or unsupported protocol version.
#yum update
#yum upgrade
yum -y update nss

cd /opt
git clone https://github.com/drush-ops/drush.git
mkdir composer
cd composer
curl -sS https://getcomposer.org/installer | php -d suhosin.executor.include.whitelist=phar #PUT IN PHP.INI
cd ../drush
php -d suhosin.executor.include.whitelist=phar /opt/composer/composer.phar install

ln -s /opt/drush/drush /usr/bin/drush
ln -s /opt/composer/composer.phar /usr/bin/composer


## PROJECT
sudo iptables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT

## PROJECT SPECIFIC
cd /home/www/public
composer install

mysql -u root <<-EOF
CREATE DATABASE $DATABASE;
EOF

