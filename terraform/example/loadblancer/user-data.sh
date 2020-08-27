#!/bin/bash
yum install -y httpd
systemctl enable httpd
systemctl start httpd
echo "NCP SERVER-$HOSTNAME is working!!!!" > /var/www/html/index.html

data "template_file" "user_data" {
template = "${file("user-data.sh")}"
}
