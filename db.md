# MariaDB Database Role

This Ansible role installs and configures MariaDB server, creates a database using the `db_name` variable, and sets up a database user with appropriate permissions.

## Requirements

- Ubuntu/Debian-based system
- Ansible 2.9+
- Python3 with pymysql module

## Role Variables

### Required Variables

- `db_name`: Name of the database to create (defined in host_vars)

### Optional Variables (with defaults)

- `mariadb_root_password`: Root password for MariaDB (default: "rootpassword")
- `db_user`: Database user name (default: "{{ db_name }}_user")
- `db_password`: Database user password (default: "dbpassword")
- `db_host`: Host from which the user can connect (default: "localhost")
- `mariadb_bind_address`: IP address to bind MariaDB to (default: "0.0.0.0")
- `mariadb_port`: Port for MariaDB service (default: 3306)

### Security Variables

- `mariadb_remove_anonymous_users`: Remove anonymous users (default: true)
- `mariadb_remove_test_database`: Remove test database (default: true)
- `mariadb_disallow_root_login_remotely`: Disallow root remote login (default: false)

## Dependencies

None

## Example Playbook

```yaml
- hosts: database_servers
  become: yes
  roles:
    - role_db
```

## Example Host Variables

```yaml
# host_vars/db-1/vars.yaml
db_name: "my_app"
mariadb_root_password: "secure_root_password"
db_password: "secure_db_password"
```

## What This Role Does

1. Updates package cache
2. Installs MariaDB server, client, and Python MySQL library
3. Starts and enables MariaDB service
4. Sets root password for MariaDB
5. Removes anonymous users and test database for security
6. Creates the application database specified by `db_name`
7. Creates a database user with full privileges on the application database
8. Configures MariaDB to bind to all interfaces
9. Ensures MariaDB service is running

## Handlers

- `restart mariadb`: Restarts the MariaDB service
- `reload mariadb`: Reloads the MariaDB service
- `stop mariadb`: Stops the MariaDB service
- `start mariadb`: Starts the MariaDB service

## Security Considerations

- Change default passwords in production
- Consider restricting `db_host` to specific IP addresses
- Review `mariadb_bind_address` setting based on your network requirements
- Use Ansible Vault for sensitive variables like passwords

## License

MIT

## Author Information

Created for Terraform Lesson 03 project.
