#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODB_HOST=mongodb.devops33.online

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script is executed at $TIMESTAMP" &>> $LOGFILE


VALIDATE(){

  if [ $1 -ne 0 ]
  then
      echo -e "$2 ... $R failed $N"
  else
      echo -e "$2 ... $G Success $N"  
  fi     
}

if [ $ID -ne 0 ]

then
  echo -e  "$R ERROR :: please run this srcipt with root user $N"
  exit 1
else
     echo  "you are root user"
fi



