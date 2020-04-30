#!/bin/sh

#installing require packages
pass="password" 	##please enter password for mysql

sudo apt-get update
sudo apt-get install default-jdk -y
sudo apt-get install tomcat7 -y

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $pass"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $pass"
sudo apt-get -y install mysql-server

#Restart all services
sudo systemctl enable tomcat7
sudo systemctl enable mysql

sudo systemctl restart tomcat7
sudo systemctl restart mysql
