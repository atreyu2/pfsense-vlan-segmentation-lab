# Firewall Policy

## Policy Goal

The firewall policy enforces least-privilege access between the User, Admin, and Server VLANs.

The goal is not to allow every machine to communicate freely. Each network receives only the access needed for its role.

## Network Summary

| Network | VLAN | Subnet |
|---|---:|---|
| USERS | 10 | 192.168.10.0/24 |
| ADMIN | 20 | 192.168.20.0/24 |
| SERVER | 30 | 192.168.30.0/24 |

## Key Hosts

| Host | IP Address |
|---|---|
| Employee Workstation | 192.168.10.50 |
| Admin Workstation | 192.168.20.101 |
| Internal Linux Server | 192.168.30.114 |

## USERS VLAN Policy

The Employee/User VLAN should only access approved services.

Allowed:

| Source | Destination | Port/Protocol | Purpose |
|---|---|---|---|
| USERS subnet | Linux Server | TCP 80/443 | Employee web portal |
| USERS subnet | Any | As needed | Internet access |

Blocked:

| Source | Destination | Purpose |
|---|---|---|
| USERS subnet | ADMIN subnet | Prevent user access to admin systems |
| USERS subnet | SERVER subnet except approved web ports | Block SSH, database, and other backend services |

## ADMIN VLAN Policy

The Admin VLAN has elevated access for management and testing.

Allowed:

| Source | Destination | Port/Protocol | Purpose |
|---|---|---|---|
| ADMIN subnet | Linux Server | TCP 80/443 | Web portal access |
| ADMIN subnet | Linux Server | TCP 22 | Server management, if SSH is running |
| ADMIN subnet | Any | As needed | Internet and management access |

## SERVER VLAN Policy

The Server VLAN hosts internal services but should not freely initiate traffic into workstation networks.

Allowed:

| Source | Destination | Port/Protocol | Purpose |
|---|---|---|---|
| SERVER subnet or Linux Server | Any | DNS 53 | Name resolution |
| SERVER subnet or Linux Server | Any | TCP 80/443 | Updates and package access |

Blocked:

| Source | Destination | Purpose |
|---|---|---|
| SERVER subnet | USERS subnet | Prevent server-initiated access to user workstations |
| SERVER subnet | ADMIN subnet | Prevent server-initiated access to admin systems |

## Stateful Firewall Behavior

pfSense is stateful. If an admin workstation initiates an approved connection to the Linux server, the server can reply as part of that session.

That does not mean the server should be allowed to start a brand-new connection back into the Admin VLAN.

This distinction is important for understanding firewall direction and lateral movement control.

## Rule Order Reminder

pfSense reads rules from top to bottom.

A broad allow rule placed above block rules can weaken the policy.

Example best practice for the SERVER tab:

```text
1. Block SERVER subnets to USERS subnets
2. Block SERVER subnets to ADMIN subnets
3. Allow SERVER DNS
4. Allow SERVER HTTP/HTTPS updates
5. Default deny everything else
```

## Notes

Firewall rules should be tested after changes. Existing connection states may need to be cleared if old traffic continues after a rule update.
