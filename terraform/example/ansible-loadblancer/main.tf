provider "ncloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

data "ncloud_root_password" "rootpwd" {
  count         	    = "${var.instance_count}"
  server_instance_no 	    = ncloud_server.server[count.index].id
  private_key        	    = ncloud_login_key.key.private_key
}

data "ncloud_port_forwarding_rules" "rules" {
  count                    = "${var.instance_count}"
  zone 			   = ncloud_server.server[count.index].zone 
}

resource "random_id" "id" {
  byte_length = 4
}

resource "ncloud_login_key" "key" {
  key_name = "${var.login_key_name}${random_id.id.hex}"
}


resource "ncloud_server" "server" {
  count         	    = "${var.instance_count}"
  name 			    = "ncloud-terraform-test-vm-${count.index+1}"
  server_image_product_code = var.server_image_product_code
  server_product_code       = var.server_product_code
  description               = "ncloud-terraform-test-vm-${count.index+1} is best tip!!"
  login_key_name            = "${ncloud_login_key.key.key_name}"
  zone                      = "${var.zones[count.index]}" 
}

resource "ncloud_port_forwarding_rule" "forwarding" {
  count         		   = "${var.instance_count}"
  port_forwarding_configuration_no = data.ncloud_port_forwarding_rules.rules[count.index].id
  server_instance_no 	           = ncloud_server.server[count.index].id 
  port_forwarding_external_port    = "1100${count.index+1}"
  port_forwarding_internal_port    = "22"
}

resource "ncloud_load_balancer" "lb" {
  name           	           = "ncloud-terraform-test-lb"
  algorithm_type                   = "RR"
  description                      = "ncloud-terraform-test-lb is best!!"

  rule_list {
    protocol_type        = "HTTP"
    load_balancer_port   = 80
    server_port          = 80
    l7_health_check_path = "/"
  }

  server_instance_no_list = [ncloud_server.server[0].id, ncloud_server.server[1].id]
  internet_line_type      = "PUBLC"
  network_usage_type      = "PBLIP"
  region                  = "KR"
}

#playbook for ansible
resource "null_resource" "ansible" {
  provisioner "local-exec" {
    command = <<EOF
      echo "[ncloud]" > inventory
EOF

  }
}

resource "null_resource" "ssh" {
  count         		   = "${var.instance_count}"
  provisioner "local-exec" {
    command = <<EOF
      echo "${ncloud_server.server[count.index].name} ansible_host='${ncloud_port_forwarding_rule.forwarding[count.index].port_forwarding_public_ip}' ansible_port='${ncloud_port_forwarding_rule.forwarding[count.index].port_forwarding_external_port}' ansible_ssh_user=root ansible_ssh_pass='${data.ncloud_root_password.rootpwd[count.index].root_password}'" >> inventory
EOF

  }

  provisioner "local-exec" {
    command = <<EOF
      sleep 120; ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook -i inventory playbook.yml
    
EOF

  }
}
