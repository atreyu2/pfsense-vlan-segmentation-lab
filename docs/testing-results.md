# Testing Results

## Testing Goal

The goal of testing was to prove that the firewall rules matched the intended access-control design.

The lab was tested from the Employee workstation, Admin workstation, and Linux server.

## Test Matrix

| Test | Source | Destination | Expected Result | Status |
|---|---|---|---|---|
| Employee opens employee portal | Employee Workstation | Linux Server `/employee/` | Allowed | Passed |
| Employee opens admin portal | Employee Workstation | Linux Server `/admin/` | Blocked/Forbidden | Passed |
| Employee attempts SSH | Employee Workstation | Linux Server TCP 22 | Blocked | Passed |
| Employee attempts MariaDB | Employee Workstation | Linux Server TCP 3306 | Blocked | Passed |
| Admin opens employee portal | Admin Workstation | Linux Server `/employee/` | Allowed | Passed |
| Admin opens admin portal | Admin Workstation | Linux Server `/admin/` | Allowed | Passed |
| Server initiates traffic to User VLAN | Linux Server | USERS subnet | Blocked | Passed |
| Server initiates traffic to Admin VLAN | Linux Server | ADMIN subnet | Blocked | Passed |
| Server resolves DNS | Linux Server | DNS | Allowed | Passed |
| Server reaches HTTP/HTTPS updates | Linux Server | Internet | Allowed | Passed |

## Strongest Visual Evidence

The strongest screenshots for this project are:

1. Network diagram
2. Proxmox VM-to-VLAN output
3. pfSense VLAN interface assignments
4. User workstation blocked from admin portal
5. Admin workstation allowed to access admin portal
6. pfSense SERVER firewall rules after cleanup

## Example Screenshot File Names

Use these names inside the `screenshots/` folder:

```text
network-diagram.png
proxmox-vm-vlan-output.png
pfsense-vlan-interfaces.png
pfsense-server-rules.png
user-admin-portal-blocked.png
admin-portal-allowed.png
```

## Evidence Summary

The testing proved that the firewall policy was role-based.

The Employee workstation had limited access and could not reach restricted admin resources.

The Admin workstation had elevated access to the internal server.

The Server VLAN was restricted from initiating new connections into the User and Admin VLANs.

This validated the main security goal of the lab: segmentation with least-privilege access.
