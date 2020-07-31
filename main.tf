terraform {
  required_version = ">=0.12.26"
}

variable "credentials" {
  type        = string
  description = "google cloud creds"
}

variable "public_key" {
  type        = string
  description = "my ssh public key"
}

variable "startup_script" {
  type        = string
  description = "scripts to run upon booting image"
}

# https://console.cloud.google.com/apis/credentials/serviceaccountkey

provider "google" {
  version     = ">=3.26.0"
  credentials = file(var.credentials)
  project     = "rodmena"
  region      = "europe-west2"
  zone        = "europe-west2-a"
}



resource "random_id" "instance_id" {
  byte_length = 8
}

resource "google_compute_instance" "default" {
  name         = "flask-vm-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = "europe-west2-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Make sure flask is installed on all new instances for later steps
  metadata_startup_script = var.startup_script

  // this allows access via ssh to the vm
  metadata = {
    ssh-keys = "rodmena:${file(var.public_key)}"
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

resource "google_compute_firewall" "default" {
  name    = "flask-app-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["5000", "80", "443", "8080", "22"]
  }
}

resource "google_compute_network" "default" {
  name = "flask-app-network"
}

output "ip" {
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}
