resource "esxi_guest" "web" {
  count      = 2
  guest_name = "web-${count.index + 1}"
  disk_store = var.disk_store
  memsize    = var.vm_memory
  numvcpus   = var.vm_cpus

  ovf_source = var.ovf_source

  network_interfaces {
    virtual_network = var.vm_network
  }

  # Cloud-init configuration
  guestinfo = {
    "userdata.encoding" = "base64"
    "userdata"          = filebase64(var.userdata_file)

    "metadata.encoding" = "base64"
    "metadata"          = filebase64(var.metadata_file)
  }
}

resource "esxi_guest" "db" {
  count      = 1
  guest_name = "db-${count.index}"
  disk_store = var.disk_store
  memsize    = 2048
  numvcpus   = 2

  ovf_source = var.ovf_source
  network_interfaces {
    virtual_network = var.vm_network
  }

  # Cloud-init configuration
  guestinfo = {
    "userdata.encoding" = "base64"
    "userdata"          = filebase64(var.userdata_file)

    "metadata.encoding" = "base64"
    "metadata"          = filebase64(var.metadata_file)
  }
}


# Generate Ansible inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.yaml.tpl", {
    web_vms = esxi_guest.web
    db_vms  = esxi_guest.db
  })
  filename = "${path.module}/inventory.yaml"
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
