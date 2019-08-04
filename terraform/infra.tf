variable "ncloud_zones" {
  type    = "list"
  default = ["KR-1", "KR-2"]
}

variable "server_image_prodict_code" {
  default = "SPSW0LINUX000032"
}

variable "server_product_code" {
  default = "SPSVRSTAND000004"
}

# keypair create
# NEED CHECK YOUR login key
resource "ncloud_login_key" "loginkey" {
  "key_name" = ""
}

data "template_file" "user_data" {
  template = "${file("user-data.sh")}"
}

#server create
#NOTE: CAUTION!! Firstly, access_control_group_configuration_no_list will create on ncloud console
#AND THEN open port 80
resource "ncloud_server" "server" {
  "count"                                      = "2"
  "name"                                = "tf-vm-${count.index+1}"
  "server_image_product_code"                  = "${var.server_image_prodict_code}"
  "server_product_code"                        = "${var.server_product_code}"
  "description"                         = "tf-vm-${count.index+1}"
  "login_key_name"                             = "${ncloud_login_key.loginkey.key_name}"
  "access_control_group_configuration_no_list" = [""]
  "zone"                                  = "${var.ncloud_zones[count.index]}"
  "user_data"                           = "${data.template_file.user_data.rendered}"
}

resource "ncloud_load_balancer" "lb" {
  	"name"                = "tf_lb"
  	"algorithm_type" = "RR"
 	 "description"         = "tf_lb"

 	 "rule_list" = [
  	  {
           "protocol_type"   = "HTTP"
           "load_balancer_port"   = 80
           "server_port"          = 80
           "l7_health_check_path" = "/"
          },
  	]

  "server_instance_no_list" = ["${ncloud_server.server.*.id[0]}", "${ncloud_server.server.*.id[1]}"]
  "internet_line_type" = "PUBLC"
  "network_usage_type" = "PBLIP"
  "region"               = "KR"
}


