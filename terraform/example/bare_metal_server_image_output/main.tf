provider "ncloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

data "ncloud_server_images" "image_by_filter" {
  infra_resource_detail_type_code = "BM"
  output_file = "server_images.json"
}


