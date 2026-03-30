#!/bin/bash
set -e

# Re-run with sudo if not root
if [ "$EUID" -ne 0 ]; then
  echo "Not running as root — re-running with sudo"
  exec sudo bash "$0" "$@"
fi

apt-get update || yum update -y || true
if command -v apt-get >/dev/null 2>&1; then
  apt-get install -y git nodejs npm python3 python3-venv
else
  yum install -y git nodejs npm python3
fi

mkdir -p /opt
useradd -m ec2-user || true
chown ec2-user:ec2-user /opt

# If systemd is available, install systemd unit files. In WSL systemd is often not present,
# so skip unit creation there and print a message.
if command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd/system ]; then
  cat > /etc/systemd/system/service-a.service <<'UNIT'
[Unit]
Description=service-a
After=network.target
[Service]
Type=simple
User=ec2-user
ExecStart=/usr/bin/node /opt/service-a/service-a/app.js
Restart=on-failure
[Install]
WantedBy=multi-user.target
UNIT

  cat > /etc/systemd/system/service-b.service <<'UNIT'
[Unit]
Description=service-b
After=network.target
[Service]
Type=simple
User=ec2-user
ExecStart=/opt/service-b/service-b/.venv/bin/python /opt/service-b/service-b/app.py
Restart=on-failure
[Install]
WantedBy=multi-user.target
UNIT

  systemctl daemon-reload || true
  systemctl enable service-a || true
  systemctl enable service-b || true
else
  echo "systemd not detected — skipping creation/enabling of systemd unit files."
  echo "If you are on WSL run the app manually or deploy on an EC2 instance where systemd is available."
fi
