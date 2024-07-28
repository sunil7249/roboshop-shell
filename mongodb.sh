#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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

cp mongo.repo  /etc/yum.repos.d/ &>> $LOGFILE
 
VALIDATE $? "copied Mongodb Repo"

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? "installing MongoDB"

systemctl enable MongoDB &>> $LOGFILE

VALIDATE $? "Enabling MongoDB"

systemctl start MongoDB &>> $LOGFILE

VALIDATE $? "starting MongoDB"

sed -i  's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf  &>> $LOGFILE

VALIDATE $? "remote access to Mongodb"

systemctl restart mongod  &>> $LOGFILE

VALIDATE $? "restarting  Mongodb"
