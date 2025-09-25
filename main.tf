terraform {
  required_providers {
    esxi = {
      source = "josenk/esxi"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "esxi" {
  esxi_hostname = var.esxi_hostname
  esxi_hostport = var.esxi_hostport
  esxi_hostssl  = var.esxi_hostssl
  esxi_username = var.esxi_username
  esxi_password = var.esxi_password
}

resource "esxi_guest" "ubuntu-vm" {
  guest_name = "ubuntu-vm"
  disk_store = var.disk_store
  memsize    = var.vm_memory
  numvcpus   = var.vm_cpus

  ovf_source = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.ova"
  
  network_interfaces {
    virtual_network = var.vm_network
  }

  # Cloud-init configuration
  guestinfo = {
    "userdata.encoding" = "base64"
    "userdata"          = filebase64("userdata.yaml")

    "metadata.encoding" = "base64"
    "metadata"          = filebase64("metadata.yaml")
  }
}

# Generate Ansible inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.ini.tpl", {
    vm_ip    = esxi_guest.ubuntu-vm.ip_address
    vm_name  = var.vm_name
    app_name = var.app_name
  })
  filename = "${path.module}/inventory.ini"
}

# Outputs
output "vm_ip" {
  description = "IP of the Ubuntu VM"
  value       = esxi_guest.ubuntu-vm.ip_address
}

output "vm_name" {
  description = "Name of the Ubuntu VM"
  value       = esxi_guest.ubuntu-vm.guest_name
}

output "ssh_connection_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh -i ~/.ssh/id_ed25519-skylab ubuntu@${esxi_guest.ubuntu-vm.ip_address}"
}

output "ansible_inventory_file" {
  description = "Path to the generated Ansible inventory file"
  value       = "${path.module}/inventory.ini"
}
