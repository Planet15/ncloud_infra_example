provider "ncloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

resource "random_id" "id" {
  byte_length = 4
}

resource "ncloud_login_key" "key" {
  key_name = "${var.login_key_name}${random_id.id.hex}"
}

data "ncloud_root_password" "rootpwd" {
  server_instance_no = ncloud_server.server.id
  private_key        = ncloud_login_key.key.private_key
}

data "ncloud_port_forwarding_rules" "rules" {
  zone = ncloud_server.server.zone
}

resource "ncloud_server" "server" {
  name                      = "${var.server_name}${random_id.id.hex}"
  server_image_product_code = var.server_image_product_code 
  server_product_code       = var.server_product_code 
  login_key_name            = ncloud_login_key.key.key_name
  zone                      = var.zone
}

#port forwarding 22 port for this host
resource "ncloud_port_forwarding_rule" "forwarding" {
  port_forwarding_configuration_no = data.ncloud_port_forwarding_rules.rules.id
  server_instance_no               = ncloud_server.server.id
  port_forwarding_external_port    = var.port_forwarding_external_port
  port_forwarding_internal_port    = "22"
}

#public ip service
resource "ncloud_public_ip" "public_ip" {
  server_instance_no = ncloud_server.server.id
}

#playbook for ansible
resource "null_resource" "ssh" {
  provisioner "local-exec" {
    command = <<EOF
      echo "[ncloud]" > inventory
      echo "${ncloud_server.server.name} ansible_host='${ncloud_port_forwarding_rule.forwarding.port_forwarding_public_ip}' ansible_port='${ncloud_port_forwarding_rule.forwarding.port_forwarding_external_port}' ansible_ssh_user=root ansible_ssh_pass='${data.ncloud_root_password.rootpwd.root_password}'" >> inventory
    
EOF

  }

  provisioner "local-exec" {
    command = <<EOF
      ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook -i inventory playbook.yml
    
EOF

  }
}
