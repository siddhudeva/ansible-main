#!/bin/bash
#author : siddhu
#date: 21-12-2021
#description: This file is for scripting practice
source common.sh

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG}
  Status $? "repository created"
yum install mysql-community-server -y &>>${LOG}
  Status $? "mysql installation"

systemctl enable mysqld &>>${LOG} && systemctl start mysqld &>>${LOG}
  Status $? "started and enabling of mysql"

echo 'show databases' | mysql -uroot -pRoboShop@1
if [ $? -ne 0 ]; then
temp_password=$(grep password /var/log/mysqld.log | awk '{print $NF}')
echo "ALTER USER 'root'@'roboshop' IDENTIFIED BY 'RoboShop@1'; flush privileges;" > /tmp/reset_pass.sql
mysql -u root --password="$temp_password" --connect-expired-password < /tmp/reset_pass.sql &>>${LOG}
  Status $? "user name and password setted"
  else
echo "\e[1;32m password is already updated\e[0m"
exit
fi
echo 'show plugins;' | mysql -uroot -pRoboShop@1 | grep 'validate_password' &>>${LOG}
if [ $? -ne 0 ]; then
  echo -e "\e[a+1;33m This plugin is removed already"
  else
echo 'uninstall validate_password;' | mysql -uroot -pRoboshop@1
  echo -e "\e[a+1;32mvalidation password plugin is uninstalled successfully\e[0m"
fi

curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>${LOG}
unzip -o /tmp/mysql.zip &>>${LOG} && cd /tmp/mysql-main/ && mysql -uroot -pRoboShop@1 <shipping.sql &>>${LOG}
  echo -e "\e[1;32mSchema loaded\e[0m"


