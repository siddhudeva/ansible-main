#!/bin/bash

source common.sh


curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG}
Status $? "repositories downloading"

yum install mysql-community-server -y &>>${LOG}
Status $? "MySQL installation"

systemctl enable mysqld &>>${LOG} && systemctl start mysqld
Status $? "MySQL enabling and starting"

DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}' )
echo 'show databases;' | mysql -uroot -pRoboShop@1 &>>${LOG}
if [ $? -ne 0 ]; then
  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" >/tmp/pass.sql
  mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" </tmp/pass.sql &>>${LOG}
fi
Status $? "MySQL user and password added"

echo 'show plugins;' | mysql -uroot -pRoboShop@1 2>>${LOG} | grep validate_password &>>${LOG}
  if [ $? -eq 0 ]; then
    echo 'uninstall plugin validate_password;' | mysql -uroot -pRoboShop@1 &>>${LOG}
Status $? "Validation Plugin unistalation"
fi
DOWNLOAD mysql &>>${LOG}
Status $? "Validation Plugin unistalation"

cd /tmp/ && unzip -o mysql.zip &>>${LOG}
Status $? "unzipping the files"
cd ./mysql-main

mysql -u root -pRoboShop@1 <shipping.sql
Status $? "schema loading"