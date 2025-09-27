all:
  hosts:
%{ for i, web in web_vms ~}
    ${web.guest_name}:
      ansible_host: ${web.ip_address}
%{ endfor ~}
%{ for i, database in db_vms ~}
    ${database.guest_name}:
      ansible_host: ${database.ip_address}
%{ endfor ~}
  vars:
    ansible_user: nessie
    ansible_ssh_common_args: "-o StrictHostKeyChecking=no"
    ansible_ssh_private_key_file: ~/.ssh/id_ed25519-skylab
  children:
    web:
      hosts:
%{ for i, web in web_vms ~}
        ${web.guest_name}:
          ansible_host: ${web.ip_address}
%{ endfor ~}
    db:
      hosts:
%{ for i, database in db_vms ~}
        ${database.guest_name}:
          ansible_host: ${database.ip_address}
%{ endfor ~}
