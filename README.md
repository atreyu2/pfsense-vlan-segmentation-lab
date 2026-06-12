# pfSense VLAN Segmentation Lab with Proxmox, Apache, and MariaDB

## Project Overview

This project is a mini company network built in a Proxmox homelab using pfSense as the firewall and inter-VLAN router.

The goal was to practice firewall policy design, VLAN segmentation, least-privilege access, Linux server hosting, and basic framework mapping in one environment.

This lab separates employee, admin, and server systems into different VLANs and uses pfSense firewall rules to control what each network can access.

## Architecture

| Network | VLAN | Subnet | Purpose |
|---|---:|---|---|
| USERS | 10 | 192.168.10.0/24 | Employee workstation network |
| ADMIN | 20 | 192.168.20.0/24 | Admin workstation network |
| SERVER | 30 | 192.168.30.0/24 | Internal Linux server network |

## Systems

| System | VLAN | IP Address | Role |
|---|---:|---|---|
| Employee Workstation | 10 | 192.168.10.50 | Standard user endpoint |
| Admin Workstation | 20 | 192.168.20.101 | Administrative endpoint |
| Internal Linux Server | 30 | 192.168.30.114 | Apache web server and MariaDB database server |

## Internal Services

The Linux server hosts:

- Apache web server
- Employee portal
- Restricted admin portal
- MariaDB database with fake employee, asset, and security-ticket data

## Security Policy Summary

### Employee Workstation

Allowed:

- Internet access
- Employee portal over HTTP/HTTPS

Blocked:

- Admin VLAN
- SSH to the Linux server
- MariaDB/database access
- Unauthorized backend server services

### Admin Workstation

Allowed:

- Internet access
- Employee portal
- Admin portal
- Approved server management services

### Server VLAN

Allowed:

- DNS
- HTTP/HTTPS for updates

Blocked:

- New connections from the server VLAN to the User VLAN
- New connections from the server VLAN to the Admin VLAN

## Screenshots

Add screenshots to the `screenshots/` folder using these suggested names:

```text
network-diagram.png
proxmox-vm-vlan-output.png
pfsense-vlan-interfaces.png
pfsense-users-rules.png
pfsense-server-rules.png
employee-portal.png
user-admin-portal-blocked.png
admin-portal-allowed.png
```

Example markdown links:

```markdown
![Network Diagram](screenshots/network-diagram.png)
![pfSense VLAN Interfaces](screenshots/pfsense-vlan-interfaces.png)
![User Blocked From Admin Portal](screenshots/user-admin-portal-blocked.png)
![Admin Portal Allowed](screenshots/admin-portal-allowed.png)
```

## Documentation

- [Full Setup Guide](docs/setup.md)
- [Firewall Policy](docs/firewall-policy.md)
- [Testing Results](docs/testing-results.md)
- [NIST Mapping](docs/nist-mapping.md)
- [Server Setup Script](commands/server-setup.sh)

## Tools Used

- Proxmox
- pfSense
- Ubuntu Server
- Apache
- MariaDB
- Windows VMs
- VLANs

## Key Lessons

This project helped reinforce:

- Firewall rule direction
- Stateful firewall behavior
- VLAN segmentation
- Inter-VLAN routing
- Least-privilege access
- Server network restrictions
- Framework mapping for technical projects

## Disclaimer

This is a homelab project using fake data. It is not a production-ready enterprise design. The purpose is hands-on learning, documentation, and demonstrating firewall policy concepts.
