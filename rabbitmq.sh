#!/bin/bash


ID=$(id -u)


TIMESTAMP=$(date +%F-%H-%M-%S)


LOGFILE="/tmp/$0-$TIMESTAMP.log"


echo "Script started at $TIMESTAMP" &>> $LOGFILE


RED="\e[31m"
G="\e[32m"
Yel="\e[33m"
NORMAL="\e[0m"



VALIDATE(){
    if [ $1 = 0 ]
    then
      echo -e "$2... $G Sucessful $NORMAL"    
    else
      echo -e "$2...$RED failed $NORMAL"
      exit 1
    fi
}


if [ $ID != 0 ]
then
 echo "Error: $RED Pleae run as root user $NORMAL"
 exit 1
else
 echo "Suessful: You are a root user"
fi


curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE
VALIDATE $? "Curl"


curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE
VALIDATE $? "Curl"


dnf install rabbitmq-server -y  &>> $LOGFILE
VALIDATE $? "Installing Rabbitmq"


systemctl enable rabbitmq-server  &>> $LOGFILE
VALIDATE $? "Enabling rabbitmq"


systemctl start rabbitmq-server &>> $LOGFILE
VALIDATE $? "Starting rabbitmq"


rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE
VALIDATE $? "Adding user roboshop"


rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE
VALIDATE $? "Password setup"