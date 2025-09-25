[ubuntu_vms]
${vm_name} ansible_host=${vm_ip} ansible_user=nessie ansible_ssh_private_key_file=/home/student/.ssh/id_ed25519-skylab app_name="${app_name}"

[ubuntu_vms:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'