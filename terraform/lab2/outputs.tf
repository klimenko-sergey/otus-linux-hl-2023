output "external_ip_address_app" {
  value = module.nginx.m_external_ip_address_app
}
output "internal_ip_address_app" {
  value = module.nginx.m_internal_ip_address_app
}
output "app_name" {
  value = module.nginx.m_app_name
}
output "external_ip_address_db" {
  value = module.db.m_db_external_ip_addresses
}
output "internal_ip_address_db" {
  value = module.db.m_db_internal_ip_addresses
}
output "db_name" {
  value = module.db.m_db_name
}
output "external_ip_address_backend" {
  value = module.backend[*].m_backend_external_ip_addresses
}
output "internal_ip_address_backend" {
  value = module.backend[*].m_backend_internal_ip_addresses
}
output "backend_name" {
  value = module.backend[*].m_backend_name
}