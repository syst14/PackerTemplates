#!/bin/bash

#get updates and lamp stack
sudo apt-get update;
sudo apt-get -y install mysql-server mysql-client;
sudo apt-get -y install apache2 php7.0 php7.0-fpm php7.0-gd php7.0-mysql;
#grant required access
sudo chown -R $USER:$USER /var/www/;
sudo chmod 755 -R /var/www/;
#enable php
sudo printf "<?php\nphpinfo();\n?>" > /var/www/html/info.php;
sudo service apache2 enable;
sudo a2enmod proxy_fcgi setenvif;
sudo a2enconf php7.0-fpm;
sudo service apache2 restart;
#create user for WP
sudo service mysql start;
sudo mysql -uroot -e "CREATE DATABASE blog DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci"
sudo mysql -uroot -e "GRANT ALL ON blog.* TO 'wpuser'@'localhost' IDENTIFIED BY 'password'"
sudo mysql -uroot -e "FLUSH PRIVILEGES"
# Download and extract Wordpress
cd /var/www/html;
sudo wget https://wordpress.org/$wp_version.tar.gz;
sudo tar -xzf $wp_version.tar.gz;
# Rename wordpress directory to blog
sudo mv wordpress blog;
cd /var/www/html/blog/;
# Create a WordPress config file 
sudo mv wp-config-sample.php wp-config.php;
#set database details for WP
sudo sed -i "s/database_name_here/blog/g" /var/www/html/blog/wp-config.php;
sudo sed -i "s/username_here/wpuser/g" /var/www/html/blog/wp-config.php;
sudo sed -i "s/password_here/password/g" /var/www/html/blog/wp-config.php;
#create uploads folder and set permissions
sudo mkdir wp-content/uploads;
sudo chmod 777 wp-content/uploads;
#remove wp file
sudo rm /var/www/html/$wp_version.tar.gz;
sudo service apache2 restart;

echo "Ready, go to http://ip-adress/blog for WP installation.";
/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync;