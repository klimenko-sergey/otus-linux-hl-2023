variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable image_id {
  description = "Disk image"
}
variable "cloud_id" {
  description = "Cloud"
}
variable "folder_id" {
  description = "Folder"
}
variable "zone" {
  description = "Zone of compute instance"
  default     = "ru-central1-a"
}
variable "service_account_key_file" {
  description = "Service Account Key File"
  default     = "keys/terraform-svc-acc-key.json"
}
variable m_subnet_id {
  description = "Subnets for modules"
}