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

cd /app && $LOGFILE

unzip /tmp/catalogue.zip

VALIDATE $? "unzipping catalogue "

npm install && $LOGFILE

VALIDATE $? "installing dependencies" 

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service  && $LOGFILE

VALIDATE $? "coping catalogue service file"

systemctl daemon-reload && $LOGFILE

VALIDATE $? "catalogue daemon reload"

systemctl enable catalogue && $LOGFILE

VALIDATE $? "Enabling catalogue"

systemctl start catalogue && $LOGFILE

VALIDATE $? "starting catalogue"

cp /home/centos/roboshop-shell/mongo.repo  /etc/yum.repos.d/mongo.repo && $LOGFILE

VALIDATE $? "coping momgodb repo"

dnf install mongodb-org-shell -y && $LOGFILE

VALIDATE $? "installing mongoDB client"

mongo --host $MONGODB_HOST </app/schema/catalogue.js && $LOGFILE

VALIDATE $? "Loading catalogue data into MongoDB"