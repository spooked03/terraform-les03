## Terraform Ubuntu VM Deployment

1. **Initialiseer Terraform:**
download needed providers
   ```bash
   terraform init
   ```

2. **Validate configuration:**
Check if config syntax is correct
   ```bash
   terraform validate
   ```
3. **Plan configuration:**
Checks execution plan without deploying
   ```bash
   terraform plan
   ```
4. **Deploy de VM:**
Apply terrafrom config
   ```bash
   terraform apply
   ```
### Cleanup
destroy all resources
```bash
terraform destroy
```

## Ansible Ubuntu VM Configuration
1. **Run playbook:**
   ```bash
   ansible-playbook playbook.yaml
   ```
2. **Connect to VM**
   ```bash
   ssh -i ~/.ssh/id_ed25519-skylab nessie@<VM_IP_ADDRESS>
   ```
 
