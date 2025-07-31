# Secret-Manager-HashiCorp-Vault
One-click script to install and run HashiCorp Vault in developer mode with public access and root token auto-display.

# 🚀 HashiCorp Vault Dev Mode Installer

This repository contains a simple bash script to install and configure [HashiCorp Vault](https://www.vaultproject.io/) in **developer mode** on a Debian-based Linux server.

### ✅ Features

- Installs latest version of Vault
- Runs Vault in **dev mode** (for testing and development only)
- Exposes Vault UI at `http://<your-server-ip>:8200`
- Automatically sets up a `systemd` service
- Prints the **root token** required to log into the UI
- Opens required firewall port (8200) if `ufw` or `iptables` is available
---

### 📦 Requirements

- Ubuntu/Debian-based system
- Root or sudo privileges
- Internet access

---

### 🚀 Usage

```bash
git clone https://github.com/<your-username>/vault-dev-mode-installer.git
cd vault-dev-mode-installer
chmod +x install_vault.sh
sudo ./install_vault.sh
