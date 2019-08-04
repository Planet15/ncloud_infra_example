#!/bin/bash
yum install -y httpd
/etc/init.d/httpd start
echo "NCP SERVER-$HOSTNAME" > /var/www/html/index.html
