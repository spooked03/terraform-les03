# ESXi Provider Variables
variable "esxi_hostname" {
  description = "ESXi hostname or IP address"
  type        = string
  default     = "192.168.1.12"
}

variable "esxi_hostport" {
  description = "ESXi host port"
  type        = number
  default     = 22
}

variable "esxi_hostssl" {
  description = "ESXi SSL port"
  type        = number
  default     = 443
}

variable "esxi_username" {
  description = "ESXi username"
  type        = string
  default = "root"
}

variable "esxi_password" {
  description = "ESXi password"
  type        = string
  sensitive   = true
  default     = "Welkom01!"
}

variable "disk_store" {
  description = "ESXi datastore name"
  type        = string
  default     = "datastore1"
}

# VM Configuration Variables
variable "vm_name" {
  description = "Name of the Ubuntu VM"
  type        = string
  default     = "ubuntu-vm"
}

variable "vm_memory" {
  description = "Memory size for the VM in MB"
  type        = number
  default     = 2048
}

variable "vm_cpus" {
  description = "Number of CPUs for the VM"
  type        = number
  default     = 2
}

variable "vm_network" {
  description = "Virtual network for the VM"
  type        = string
  default     = "VM Network"
}

variable "app_name" {
  description = "Application name for inventory"
  type        = string
  default     = "demoapp"
}

variable "ssh_private_key" {
  description = "Path to the SSH private key for VM access"
  type        = string
  default     = "/home/student/.ssh/id_ed25519-skylab"
  
}

variable "ssh_public_key" {
  description = "Path to the SSH public key for VM access"
  type        = string
  default     = "/home/student/.ssh/id_ed25519-skylab.pub"
  
}

variable "ovf_source" {
  description = "URL of the OVF source for the VM"
  type        = string
  default     = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.ova"
}
variable "vm_network" {
  description = "Virtual network for the VM"
  type        = string
  default     = "VM Network"
  
}

variable "userdata_file" {
  description = "Path to the cloud-init user data file"
  type        = string
  default     = "./cloud-init/userdata.yaml"
}

variable "metadata_file" {
  description = "Path to the cloud-init metadata file"
  type        = string
  default     = "./cloud-init/metadata.yaml"
}