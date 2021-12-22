#!/bin/bash

LOG=/tmp/mysql.log
rm -rf /tmp/mysql.log

Status() {
  if [ $1 -ne 0 ]; then
    echo -e "\e[1;31m ${2} is -failure"
     else
    echo -e "\e[1;31m ${2} is -success"
  fi
}
