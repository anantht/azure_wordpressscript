#!/bin/bash

apt-get -y update

logger "Installing WordPress"

# Set up a silent install of MySQL
dbpass=$1

export DEBIAN_FRONTEND=noninteractive
echo mysql-server-5.6 mysql-server/root_password password $dbpass | debconf-set-selections
echo mysql-server-5.6 mysql-server/root_password_again password $dbpass | debconf-set-selections

# Install the LAMP stack and WordPress
apt-get -y install apache2 mysql-server php5 php5-mysql wordpress

# Setup WordPress
gzip -d /usr/share/doc/wordpress/examples/setup-mysql.gz
bash /usr/share/doc/wordpress/examples/setup-mysql -n wordpress localhost

ln -s /usr/share/wordpress /var/www/html/wordpress
mv /etc/wordpress/config-localhost.php /etc/wordpress/config-default.php

logger "Done installing WordPress; open /wordpress to configure"

sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
sudo -u Snow@123 -i -- wp core download
sudo -u Snow@123 -i -- wp core version

sudo -u Snow@123 -i -- wp config create --dbname=wordpress --dbuser=root --dbpass=mysql123

sudo -u Snow@123 -i -- wp core install --url=anascorp1.com --title=anascorp1 --admin_user=anantht --admin_password=Password@1 --admin_email=ananth.thangarajan@servicenow.com


# Restart Apache
apachectl restart
