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

resource "yandex_vpc_network" "network_lab2" {
  name = "net_lab2"
}

resource "yandex_vpc_subnet" "subnet_lab2" {
  name           = "subnet_lab2"
  zone           = var.zone
  network_id     = yandex_vpc_network.network_lab2.id
  v4_cidr_blocks = ["192.168.1.0/24"]
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

resource "yandex_vpc_subnet" "subnet_lab2_nat" {
  name           = "subnet_lab2_nat"
  zone           = var.zone
  network_id     = yandex_vpc_network.network_lab2.id
  v4_cidr_blocks = ["192.168.100.0/24"]
}

resource "yandex_vpc_security_group" "nat-instance-sg" {
  name       = "nat-instance-sg"
  network_id = yandex_vpc_network.network_lab2.id

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  # ingress {
  #   protocol       = "ANY"
  #   description    = "any"
  #   v4_cidr_blocks = ["0.0.0.0/0"]
  # }
}

resource "yandex_compute_image" "nat-instance-ubuntu" {
  source_family = "nat-instance-ubuntu"
}

module "nginx" {
  source                   = "../modules/nginx"
  image_id                 = var.image_id
  public_key_path          = var.public_key_path
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
  m_subnet_id              = yandex_vpc_subnet.subnet_lab2.id
}
module "db" {
  source                   = "../modules/db"
  image_id                 = var.image_id
  public_key_path          = var.public_key_path
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
  m_subnet_id              = yandex_vpc_subnet.subnet_lab2.id
}
module "backend" {
  source                   = "../modules/backend"
  image_id                 = var.image_id
  public_key_path          = var.public_key_path
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
  m_subnet_id              = yandex_vpc_subnet.subnet_lab2.id
}
module "inventory" {
  source                     = "../modules/inventory"
  app_ip_addresses           = module.nginx.m_external_ip_address_app
  app_name                   = module.nginx.m_app_name
  db_ip_addresses            = module.db.m_db_external_ip_addresses
  db_int_ip_addresses        = module.db.m_db_internal_ip_addresses
  db_name                    = module.db.m_db_name
  backend_ip_addresses-0     = module.backend.m_backend_external_ip_addresses[0]
  backend_int_ip_addresses-0 = module.backend.m_backend_internal_ip_addresses[0]
  backend_name-0             = module.backend.m_backend_name[0]
  backend_ip_addresses-1     = module.backend.m_backend_external_ip_addresses[1]
  backend_int_ip_addresses-1 = module.backend.m_backend_internal_ip_addresses[1]
  backend_name-1             = module.backend.m_backend_name[1]
  depends_on = [
    module.nginx,
    module.db,
    module.backend,
  ]
}
module "nginx-app-config" {
  source                 = "../modules/nginx-app-config"
  backend_ip_addresses-0 = module.backend.m_backend_internal_ip_addresses[0]
  backend_ip_addresses-1 = module.backend.m_backend_internal_ip_addresses[1]
  app_ip_addresses       = module.nginx.m_external_ip_address_app
  depends_on = [
    module.nginx,
    module.db,
    module.backend,
  ]
}
module "backend_config" {
  source                   = "../modules/backend_config"
  app_ip_addresses         = module.nginx.m_external_ip_address_app
  db_internal_ip_addresses = module.db.m_db_internal_ip_addresses
  depends_on = [
    module.nginx,
    module.db,
  ]
}

resource "local_file" "generate_script" {
  content = templatefile("ansible_run_scripts.tpl", {
    app_ip = module.nginx.m_external_ip_address_app
    # db_ip  = module.db.m_db_ip_addresses
  })
  filename = "ansible_run_scripts.sh"

  provisioner "local-exec" {
    command = "mv ansible_run_scripts.sh ../scripts/ansible_run_scripts.sh"
  }
  depends_on = [
    module.nginx,
    module.db,
    module.backend,
  ]
}
resource "terraform_data" "ansible" {
  provisioner "local-exec" {
    command     = "sh ../scripts/ansible_run_scripts.sh"
    interpreter = ["/bin/sh", "-c"]
  }
  depends_on = [
    local_file.generate_script
  ]
}

resource "yandex_vpc_route_table" "nat-instance-route" {
  name       = "nat-instance-route"
  network_id = yandex_vpc_network.network_lab2.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat-instance.network_interface.0.ip_address
  }
}

resource "yandex_compute_instance" "nat-instance" {
  name        = "nat-instance"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"
  hostname    = "nat-instance"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.nat-instance-ubuntu.id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet_lab2_nat.id
    security_group_ids = [yandex_vpc_security_group.nat-instance-sg.id]
    nat                = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.vm_user_nat}\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("${var.public_key_path}")}"
    ssh-keys  = "debian:${file(var.public_key_path)}"
  }
}