#!/bin/bash

set -e

echo "🔧 Installing dependencies..."
apt update -y
apt install -y unzip curl gnupg lsb-release

echo "🔐 Installing Vault..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list
apt update -y
apt install -y vault

echo "🛠️ Creating systemd service for Vault (dev mode)..."

cat <<EOF > /etc/systemd/system/vault.service
[Unit]
Description=HashiCorp Vault - dev mode
Documentation=https://www.vaultproject.io/docs/
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/bin/vault server -dev -dev-listen-address=0.0.0.0:8200
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

echo "🔄 Reloading systemd and starting Vault..."
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable vault
systemctl restart vault

echo "🌐 Opening port 8200 for public access..."
if command -v ufw >/dev/null; then
    ufw allow 8200/tcp || true
elif command -v iptables >/dev/null; then
    iptables -I INPUT -p tcp --dport 8200 -j ACCEPT
    iptables-save > /etc/iptables/rules.v4 || true
fi

echo "✅ Vault is running and accessible publicly on port 8200"
echo "🌍 Access it via: http://<your-server-ip>:8200"
echo
echo "🔑 Your root token (for UI login) is below:"
echo "-------------------------------------------"
sudo journalctl -u vault -n 50 | grep 'Root Token'
echo "-------------------------------------------"
