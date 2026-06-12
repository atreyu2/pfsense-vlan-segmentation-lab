# NIST SP 800-41 Rev. 1 Mapping

## Purpose

This project was mapped to selected areas of NIST SP 800-41 Rev. 1, *Guidelines on Firewalls and Firewall Policy*.

The goal was not to claim full compliance. The goal was to connect the technical design of the homelab to recognized firewall guidance.

## Mapping Summary

| NIST SP 800-41 Area | Project Mapping |
|---|---|
| Stateful Inspection | pfSense tracks established sessions and allows valid response traffic without requiring a separate reverse allow rule for every connection. |
| Firewalls for Virtual Infrastructures | The environment uses virtual machines, Proxmox bridges, VLAN tagging, and a virtual pfSense firewall. |
| Network Layouts with Firewalls | pfSense separates networks with different security requirements: User, Admin, and Server. |
| Policies Based on IP Addresses and Protocols | Firewall rules are based on source networks, destination networks, IP addresses, protocols, and ports. |

## 1. Stateful Inspection

pfSense is a stateful firewall.

If the Admin workstation initiates an approved connection to the Linux server, pfSense allows the server to respond because the traffic is part of an established session.

However, the server is still blocked from starting new unauthorized connections back into the Admin VLAN.

This helped reinforce the difference between response traffic and newly initiated traffic.

## 2. Firewalls for Virtual Infrastructures

This lab was fully virtualized.

The network used:

- Proxmox virtual machines
- VLAN-aware bridges
- VLAN tags
- pfSense as a virtual firewall/router

This made the lab useful for understanding firewall placement in virtual environments.

## 3. Network Layouts with Firewalls

The lab separated systems based on security role:

- Employee/User systems
- Admin systems
- Server systems

pfSense sat between those networks and controlled traffic between them.

This helped demonstrate why firewalls are commonly placed at logical boundaries between networks with different security requirements.

## 4. Policies Based on IP Addresses and Protocols

The firewall rules used:

- Source networks
- Destination networks
- Individual host IP addresses
- TCP ports
- UDP/TCP DNS
- ICMP behavior
- HTTP/HTTPS
- SSH
- MariaDB

This mapped directly to practical firewall-policy design.

## Important Note

This project should not be described as a full compliance implementation.

A better description is:

```text
This homelab maps selected firewall design concepts to NIST SP 800-41 Rev. 1 guidance.
```

## What This Added to the Project

Mapping the project to NIST helped show that the lab was not only technical, but also security-focused.

It connected hands-on configuration to the reasoning behind the controls:

- Why networks are separated
- Why some traffic is allowed
- Why other traffic is blocked
- How firewall rules reduce risk
- How a security control can be explained during an assessment or interview
