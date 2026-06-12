#!/bin/bash

set -e

DB_NAME="company_portal"
DB_USER="portal_reader"
DB_PASS="trey"
SERVER_IP="192.168.30.114"

apt update
apt install -y apache2 mariadb-server

systemctl enable apache2
systemctl enable mariadb
systemctl start apache2
systemctl start mariadb

mkdir -p /var/www/html/employee
mkdir -p /var/www/html/admin

cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Internal Company Server</title>
    <style>
        body { font-family: Arial, sans-serif; background: #111827; color: #f9fafb; padding: 40px; }
        .card { background: #1f2937; padding: 30px; border-radius: 12px; max-width: 800px; margin: auto; }
        h1 { color: #38bdf8; }
        a { color: #93c5fd; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Internal Company Server</h1>
        <p>This server represents an internal business system hosted in the SERVER VLAN.</p>
        <p>Available portals:</p>
        <ul>
            <li><a href="/employee/">Employee Portal</a></li>
            <li><a href="/admin/">Admin Portal</a></li>
        </ul>
        <p><em>Thanks AI for helping build this site before the firewall blocked somebody.</em></p>
    </div>
</body>
</html>
EOF

cat > /var/www/html/employee/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Employee Portal</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f3f4f6; color: #111827; padding: 40px; }
        .card { background: white; padding: 30px; border-radius: 12px; max-width: 800px; margin: auto; box-shadow: 0 4px 12px rgba(0,0,0,.1); }
        h1 { color: #2563eb; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Employee Portal</h1>
        <p>This page is intended for normal employee access.</p>
        <p>Users in VLAN 10 should be able to access this portal.</p>
    </div>
</body>
</html>
EOF

cat > /var/www/html/admin/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Admin Portal</title>
    <style>
        body { font-family: Arial, sans-serif; background: #0f172a; color: #f8fafc; padding: 40px; }
        .card { background: #1e293b; padding: 30px; border-radius: 12px; max-width: 800px; margin: auto; }
        h1 { color: #f87171; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Admin Portal</h1>
        <p>This page represents a restricted administrative web portal.</p>
        <p>Only the Admin VLAN should be able to access this resource.</p>
    </div>
</body>
</html>
EOF

mysql <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};

CREATE TABLE IF NOT EXISTS ${DB_NAME}.employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(100),
    role VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS ${DB_NAME}.assets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hostname VARCHAR(100),
    ip_address VARCHAR(50),
    asset_type VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS ${DB_NAME}.security_tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150),
    severity VARCHAR(50),
    status VARCHAR(50)
);

INSERT INTO ${DB_NAME}.employees (name, department, role) VALUES
('Jane Miller', 'Finance', 'Analyst'),
('Marcus Lee', 'IT', 'Systems Administrator'),
('Trey Kemp', 'Security', 'Cybersecurity Analyst')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO ${DB_NAME}.assets (hostname, ip_address, asset_type) VALUES
('EMP-WS-01', '192.168.10.50', 'Employee Workstation'),
('ADM-WS-01', '192.168.20.101', 'Admin Workstation'),
('INT-SRV-01', '192.168.30.114', 'Linux Server')
ON DUPLICATE KEY UPDATE hostname=hostname;

INSERT INTO ${DB_NAME}.security_tickets (title, severity, status) VALUES
('User attempted access to restricted admin portal', 'Medium', 'Closed'),
('Server outbound access reviewed', 'Low', 'Open'),
('Firewall segmentation validation', 'High', 'Closed')
ON DUPLICATE KEY UPDATE title=title;

DROP USER IF EXISTS '${DB_USER}'@'localhost';
CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT SELECT ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

chown -R www-data:www-data /var/www/html
systemctl restart apache2

echo "Server setup complete."
echo "Main portal: http://${SERVER_IP}/"
echo "Employee portal: http://${SERVER_IP}/employee/"
echo "Admin portal: http://${SERVER_IP}/admin/"
