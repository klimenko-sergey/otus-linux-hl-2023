terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">=2.4.0"
    }
  }
  required_version = ">= 0.14"
}

resource "local_file" "generate_inventory" {
  content = templatefile("inventory.tpl", {
    app_name = var.app_name,
    app_ip   = var.app_ip_addresses,
    db_name = var.db_name,
    db_ip   = var.db_int_ip_addresses,
    backend_name-0 = var.backend_name-0,
    backend_ip-0   = var.backend_int_ip_addresses-0,
    backend_name-1 = var.backend_name-1,
    backend_ip-1   = var.backend_int_ip_addresses-1
  })
  filename = "inventory"

  provisioner "local-exec" {
    command = "chmod a-x inventory && mv inventory ../../ansible/environments/lab2/inventory"
    interpreter = ["/bin/sh", "-c"]
  }
}
