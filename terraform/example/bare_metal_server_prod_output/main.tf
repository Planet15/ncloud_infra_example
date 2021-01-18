provider "ncloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

data "ncloud_server_image" "image_by_filter" {
    infra_resource_detail_type_code = "BM"
    filter {
      name = "product_name"
      values = ["centos-7.8-64"]
  }
}


data "ncloud_server_products" "prod" {
  server_image_product_code = data.ncloud_server_image.image_by_filter.id
  output_file = "server_prod.json"
}
