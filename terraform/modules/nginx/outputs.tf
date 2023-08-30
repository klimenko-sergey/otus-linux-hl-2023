output "external_ip_address_app" {
  value = yandex_compute_instance.nginx.network_interface[0].nat_ip_address
}
output "app_name" {
  value = yandex_compute_instance.nginx.name
}
