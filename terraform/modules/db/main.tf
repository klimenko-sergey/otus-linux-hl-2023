terraform {
  required_providers {
    local = {
      source  = "yandex-cloud/yandex"
      version = ">=0.97.0"
    }
  }
  required_version = ">= 0.14"
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_compute_instance" "db" {
  name = "db-0"
  labels = {
    tags = "db-0"
  }
  hostname = "db-0"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = var.m_subnet_id
    nat       = false
  }

  metadata = {
    ssh-keys = "debian:${file(var.public_key_path)}"
  }
}