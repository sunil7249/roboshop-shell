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

dnf module disable nodejs -y && $LOGFILE

VALIDATE $? "disabling current nodejs"

dnf module enable nodejs:18 -y && $LOGFILE

VALIDATE $? "Enabling Nodejs:18"

dnf install nodejs -y && $LOGFILE

VALIDATE $? "Installing Nodejs:18"

useradd roboshop && $LOGFILE

VALIDATE $? "creating user roboshop"

mkdir /app && $LOGFILE

VALIDATE $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip && $LOGFILE

VALIDATE $? "Downloading catalogue application"

cd /app 

unzip /tmp/catalogue.zip

VALIDATE $? "unzipping catalogue "

npm install 

VALIDATE $? "installing dependencies" 

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service  && $LOGFILE

VALIDATE $? "coping catalogue service file"

systemctl daemon-reload && $LOGFILE

VALIDATE $? "catalogue daemon reload"

systemctl enable catalogue && $LOGFILE

VALIDATE $? "Enabling catalogue"

systemctl start catalogue && $LOGFILE

VALIDATE $? "starting catalogue"

cp /home/centos/roboshop-shell/mongo.repo  /etc/yum.repos.d/mongo.repo

VALIDATE $? "coping momgodb repo"

dnf install mongodb-org-shell -y

VALIDATE $? "installing mongoDB client"

mongo --host $MONGODB_HOST </app/schema/catalogue.js

VALIDATE $? "Loading catalogue data into MongoDB"