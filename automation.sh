#!/bin/bash


s3bucket="upgrad-ramprasadh/logs"
name="ramprasadh"

#------------------install apache---------
  sudo apt install apache2 -y
        echo "apache installed"

#------------------------------------

sudo systemctl unmask apache2
#------------------Check apache running---------

if [ `service apache2 status | grep running | wc -l` == 1 ]
then
        echo "Apache2 running"
else
                sudo service apache2 start
        echo "apache2 started"



fi
#----------------------------------------------


#------------------Check apache enabled---------
if [ `service apache2 status | grep enabled | wc -l` == 1 ]
then
        echo "Apache2 already enabled"
else
                sudo systemctl enable apache2
        echo "Apache2 enabled"
fi
#-----------------------------------------

timestp=$(date '+%d%m%Y-%H%M%S')

#------------------Converting to tar---------

cd /var/log/apache2/
tar -cvf /tmp/${name}-httpd-logs-${timestp}.tar *.log
#-------------------------------------------------------


#------------------Copy to s3r---------
sudo apt-get install awscli -y

aws s3 \
cp /tmp/${name}-httpd-logs-${timestp}.tar \
s3://${s3bucket}/${name}-httpd-logs-${timestp}.tar
