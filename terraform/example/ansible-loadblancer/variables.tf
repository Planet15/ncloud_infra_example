variable "access_key" { # export TF_VAR_access_key=...
  default = ""
}

variable "secret_key" { # export TF_VAR_secret_key=...
  default = ""
}

variable "server_image_product_code" { # centos-7.8-64
  default = "SPSW0LINUX000139" #SPSW0LINUX000046
}

variable "server_product_code" { # vCPU 2EA, Memory 8GB, Disk 50GB[SSD]
  default = "SPSVRSTAND000072" #SPSVRSSD00000003
}

variable "login_key_name" {
  default = "tf-test-key"
}

variable "instance_count" {
  default = "2"
}

variable "zones" {
        type = list
        default = ["KR-1", "KR-2"]
}

variable "region" {
  default = "KR"
}

variable "site" {
  default = "www.ncloud.com"
}
