output "m_backend_external_ip_addresses" {
  value = yandex_compute_instance.backend[*].network_interface[0].nat_ip_address
}
output "m_backend_internal_ip_addresses" {
  value = yandex_compute_instance.backend[*].network_interface[0].ip_address
}
output "m_backend_name" {
  value = yandex_compute_instance.backend[*].name
}