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
    app_ip   = var.app_ip_addresses
  })
  filename = "inventory"

  provisioner "local-exec" {
    command = "chmod a-x inventory && mv inventory ../../ansible/inventory"
    interpreter = ["/bin/sh", "-c"]
  }
}
