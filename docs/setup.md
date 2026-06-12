# Full Setup Guide

## 1. Lab Goal

Build a segmented company-style network using Proxmox and pfSense.

The design separates users, admins, and servers into different VLANs and uses firewall rules to control traffic between them.

## 2. Network Plan

| Role | VLAN | Subnet | Gateway |
|---|---:|---|---|
| USERS | 10 | 192.168.10.0/24 | 192.168.10.1 |
| ADMIN | 20 | 192.168.20.0/24 | 192.168.20.1 |
| SERVER | 30 | 192.168.30.0/24 | 192.168.30.1 |

## 3. VM Addressing

| VM | IP Address | Gateway | DNS |
|---|---|---|---|
| Employee Workstation | 192.168.10.50 | 192.168.10.1 | 8.8.8.8 |
| Admin Workstation | 192.168.20.101 | 192.168.20.1 | 8.8.8.8 |
| Internal Linux Server | 192.168.30.114 | 192.168.30.1 | 8.8.8.8 |

## 4. Proxmox Bridge Requirements

The Proxmox bridge carrying VLAN traffic must be VLAN-aware.

Example bridge settings:

```text
bridge-vlan-aware yes
bridge-vids 2-4094
```

The pfSense LAN NIC should be connected to the trunk bridge without a VLAN tag.

The project VMs should be tagged:

| VM | Bridge | VLAN Tag |
|---|---|---:|
| Employee Workstation | vmbr3 | 10 |
| Admin Workstation | vmbr3 | 20 |
| Internal Linux Server | vmbr3 | 30 |

## 5. pfSense VLAN Creation

In pfSense:

```text
Interfaces > Assignments > VLANs
```

Create:

| Parent Interface | VLAN Tag | Description |
|---|---:|---|
| LAN parent interface | 10 | USERS |
| LAN parent interface | 20 | ADMIN |
| LAN parent interface | 30 | SERVER |

## 6. pfSense Interface Assignment

Go to:

```text
Interfaces > Assignments
```

Assign each VLAN as an interface:

| Interface | VLAN | Static IP |
|---|---:|---|
| USERS | 10 | 192.168.10.1/24 |
| ADMIN | 20 | 192.168.20.1/24 |
| SERVER | 30 | 192.168.30.1/24 |

Enable each interface and apply changes.

## 7. Temporary Test Rules

Before applying the final policy, create temporary allow rules on each VLAN tab to test connectivity.

Example:

```text
Action: Pass
Protocol: Any
Source: USERS subnets
Destination: Any
Description: TEMP allow USERS to any
```

Repeat for ADMIN and SERVER.

Once connectivity is verified, replace the temporary rules with the final security policy.

## 8. Outbound NAT

Go to:

```text
Firewall > NAT > Outbound
```

Set:

```text
Automatic outbound NAT rule generation
```

This allows the VLAN networks to reach the internet through pfSense.

## 9. Linux Server Services

The Linux server hosts Apache and MariaDB.

The full copy/paste setup script is located at:

```text
commands/server-setup.sh
```

## 10. Final Validation

Validate:

- Each VM can ping its pfSense VLAN gateway
- Employee can access the employee portal
- Employee cannot access the admin portal
- Employee cannot access SSH or MariaDB
- Admin can access the admin portal
- Server cannot initiate new connections to User/Admin VLANs
