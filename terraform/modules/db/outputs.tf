output "m_db_external_ip_addresses" {
  value = yandex_compute_instance.db.network_interface[0].nat_ip_address
}
output "m_db_internal_ip_addresses" {
  value = yandex_compute_instance.db.network_interface[0].ip_address
}
output "m_db_name" {
  value = yandex_compute_instance.db.name
}