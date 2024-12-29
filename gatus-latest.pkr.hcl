variable "vultr_api_key" {
  type      = string
  default   = "${env("VULTR_API_KEY")}"
  sensitive = true
}

packer {
    required_plugins {
        vultr = {
            version = ">=v2.3.2"
            source = "github.com/vultr/vultr"
        }
    }
}

source "vultr" "gatus-packer" {
  api_key              = "${var.vultr_api_key}"
  os_id                = "387"
  plan_id              = "marketplace-2c-2gb"
  region_id            = "ewr"
  snapshot_description = "Gatus"
  ssh_username         = "root"
  state_timeout        = "25m"
}

build {
  sources = ["source.vultr.gatus-packer"]

  # First, copy vultr-helper.sh
  provisioner "file" {
    source = "vultr-helper.sh"
    destination = "/root/vultr-helper.sh"
  }

  # Then copy cloud-init template
  provisioner "file" {
    source = "cloud-init-template.yaml"
    destination = "/etc/cloud/cloud.cfg.d/99_gatus.cfg"
  }

  # Run cleanup operations
  provisioner "shell" {
    inline = [
      "chmod +x /root/vultr-helper.sh",
      "source /root/vultr-helper.sh",
      "chmod 644 /etc/cloud/cloud.cfg.d/99_gatus.cfg",
      "cloud-init clean",
      "clean_system"
    ]
  }
}
