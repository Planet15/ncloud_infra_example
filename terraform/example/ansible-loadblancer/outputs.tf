#output "load_balancer_instance_id" {
#  value = ncloud_load_balancer.lb.id
#}

output "server_name_list" {
  value = join(",", ncloud_server.server.*.name)
}
