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
variable "public_key_path" {
  description = "Public key path"
}
variable "image_id" {
  description = "Disk image"
}
variable "subnet_id" {
  description = "Subnet"
}
variable "service_account_key_file" {
  description = "Service Account Key File"
  default     = "keys/terraform-svc-acc-key.json"
}
variable "private_key_path" {
  description = "Path to private key"
  default     = "~/.ssh/yakey"
}
variable "disk_name" {
  type = string
}
variable "disk_type" {
  type = string
}