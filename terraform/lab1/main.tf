terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">=0.97.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">=2.4.0"
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

resource "yandex_compute_instance" "nginx" {
  name = "nginx-app"
  labels = {
    tags = "nginx-app"
  }

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
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "debian:${file(var.public_key_path)}"
  }
}
module "inventory" {
  count            = 1
  source           = "../modules/inventory"
  app_ip_addresses = yandex_compute_instance.nginx.network_interface[0].nat_ip_address
  app_name         = yandex_compute_instance.nginx.name
  depends_on       = [yandex_compute_instance.nginx]
}
resource "local_file" "generate_script" {
  content = templatefile("ansible_run_scripts.tpl", {
    app_ip = yandex_compute_instance.nginx.network_interface[0].nat_ip_address
  })
  filename = "ansible_run_scripts.sh"

  provisioner "local-exec" {
    command = "mv ansible_run_scripts.sh ../scripts/ansible_run_scripts.sh"
  }
  depends_on = [yandex_compute_instance.nginx]
}
resource "terraform_data" "ansible" {
  provisioner "local-exec" {
    command     = "sh ../scripts/ansible_run_scripts.sh"
    interpreter = ["/bin/sh", "-c"]
  }
  depends_on = [local_file.generate_script]
}