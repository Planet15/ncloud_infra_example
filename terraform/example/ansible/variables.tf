variable "access_key" { # export TF_VAR_access_key=...
  default = ""
}

variable "secret_key" { # export TF_VAR_secret_key=...
  default = ""
}

variable "region" {
  default = "KR"
}

variable "zone" {
  default = "KR-2"
}

variable "login_key_name" {
  default = "tf-test-key"
}

variable "server_name" {
  default = "tf-test-vm"
}

variable "server_image_product_code" { # centos-7.3-64
  default = "SPSW0LINUX000046"
}

variable "server_product_code" { # vCPU 2EA, Memory 4GB, Disk 50GB
  default = "SPSVRSTAND000004" #SPSVRSTAND000056
}

variable "port_forwarding_external_port" {
  default = "5088"
}
