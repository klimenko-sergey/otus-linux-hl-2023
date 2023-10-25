terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">=2.4.0"
    }
  }
  required_version = ">= 0.14"
}

resource "local_file" "generate_backend_config" {
  content = templatefile("backend.tpl", {
    app_ip   = var.app_ip_addresses,
    db_ip   = var.db_internal_ip_addresses
  })
  filename = "backend"

  provisioner "local-exec" {
    command = "chmod a-x backend && mv backend ../../ansible/environments/lab2/group_vars/backend"
    interpreter = ["/bin/sh", "-c"]
  }
}
