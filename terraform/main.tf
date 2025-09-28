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
  guest_name = "db-${count.index + 1}"
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


# Wait for VMs to get IP addresses
resource "null_resource" "wait_for_ips" {
  count = length(esxi_guest.web) + length(esxi_guest.db)
  
  provisioner "local-exec" {
    command = <<-EOT
      echo "Waiting for VM IP addresses to be assigned..."
      timeout=300
      elapsed=0
      while [ $elapsed -lt $timeout ]; do
        if terraform show -json | jq -r '.values.root_module.resources[] | select(.type=="esxi_guest") | .values.ip_address' | grep -v null > /dev/null; then
          echo "IP addresses detected!"
          break
        fi
        echo "Still waiting for IP addresses... ($elapsed/$timeout seconds)"
        sleep 10
        elapsed=$((elapsed + 10))
      done
    EOT
  }
  
  depends_on = [esxi_guest.web, esxi_guest.db]
}

# Generate Ansible inventory after IPs are available
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.yaml.tpl", {
    web_vms = esxi_guest.web
    db_vms  = esxi_guest.db
  })
  filename = "${path.module}/ansible/inventory.yaml"
  
  depends_on = [null_resource.wait_for_ips]
}

# Outputs
output "vm_ip" {
  description = "IP of the Ubuntu VM"
  value       = esxi_guest.web[0].ip_address
}

output "vm_name" {
  description = "Name of the Ubuntu VM"
  value       = esxi_guest.web[0].guest_name
}

output "ssh_connection_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh -i ~/.ssh/id_ed25519-skylab ubuntu@${esxi_guest.web[0].ip_address}"
}

output "ansible_inventory_file" {
  description = "Path to the generated Ansible inventory file"
  value       = "${path.module}/ansible/inventory.yaml"
}
