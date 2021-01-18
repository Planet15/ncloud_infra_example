provider "ncloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

resource "ncloud_login_key" "key" {
  key_name = var.login_key_name
}

# Barematal service for NCP support ncloud_server_image as below, 
# centos-6.9-64
# centos-7.4-64
# centos-7.8-64
# oracle-linux-6.9-64
# oracle-linux-7.4-64
# win-2016-64-en
# win-2012-64-R2-en
# mssql(2019std)-win-2016-64-en

data "ncloud_server_image" "image" {
    infra_resource_detail_type_code = "BM"
    filter {
      name = "product_name"
      values = ["centos-7.8-64"]
  }
}

# Barematal service for NCP support server_image_product_code as below,
# Dual Intel Xeon Gold 6154(3.0 GHz), 36 cores, 384GB RAM, 8 x 480GB SSD
# Dual Intel Xeon Gold 6154(3.0 GHz), 36 cores, 384GB RAM, 2 x 480GB SSD, 2 x 3.2TB NVMe
# Dual Intel Xeon Silver 4114(2.2 GHz), 20 cores, 128GB RAM, 8 x 480GB SSD
# Dual Intel Xeon Silver 4112(2.6 GHz) , 8 cores, 64GB RAM, 8 x 480GB SSD
# Single Intel Xeon Silver 4112(2.6 GHz), 4 cores, 32GB RAM, 8 x 480GB SSD
data "ncloud_server_product" "prod" {
  server_image_product_code = data.ncloud_server_image.image.id
    filter {
      name = "product_description"
      values = ["^(.*)2\\.2 GHz(.*)20 cores(.*)"]
      regex = true 
  }
}

resource "ncloud_server" "bm" {
  name                      = var.server_name
  server_image_product_code = data.ncloud_server_image.image.id
  server_product_code       = data.ncloud_server_product.prod.id
  login_key_name            = ncloud_login_key.key.key_name
  raid_type_name            = "5"
  zone                      = "KR-2"
}

resource "ncloud_public_ip" "public_ip" {
  server_instance_no = ncloud_server.bm.id
}

data "ncloud_root_password" "pwd" {
  server_instance_no = ncloud_server.bm.id
  private_key        = ncloud_login_key.key.private_key
}


resource "null_resource" "host_provisioner" {
  provisioner "remote-exec" {
    inline = [
      "groupadd mygrp",
      "useradd -d /home/otp_user -m -G mygrp -s /bin/bash otp_user",
      "echo 'otp_user:ncphero' | chpasswd"
    ]
  }

  connection {
    type     = "ssh"
    host     = ncloud_public_ip.public_ip.public_ip
    user     = "root"
    port     = "22" 
    password = data.ncloud_root_password.pwd.root_password
  }
}

output "cn_host_pw" {
  value = "sshpass -p '${data.ncloud_root_password.pwd.root_password}' ssh root@${ncloud_public_ip.public_ip.public_ip} -oStrictHostKeyChecking=no"
}
