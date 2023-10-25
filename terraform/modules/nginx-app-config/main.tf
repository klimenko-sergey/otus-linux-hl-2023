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
  content = templatefile("nginx.tpl", {
    backend_ip-0   = var.backend_ip_addresses-0,
    backend_ip-1   = var.backend_ip_addresses-1,
    app_external_ip_address = var.app_ip_addresses
  })
  filename = "nginx"

  provisioner "local-exec" {
    command = "chmod a-x nginx && mv nginx ../../ansible/environments/lab2/group_vars/nginx"
    interpreter = ["/bin/sh", "-c"]
  }
}