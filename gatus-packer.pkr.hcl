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

  provisioner "file" {
    source = "vultr-helper.sh"
    destination = "/root/vultr-helper.sh"
  }

  provisioner "shell" {
    script = "setup.sh"
    remote_folder = "/root"
    remote_file = "setup.sh"
  }
}
