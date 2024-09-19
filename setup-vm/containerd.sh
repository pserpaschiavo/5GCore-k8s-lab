#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y

### Preparation for Container Runtime (containerd):
# sysctl params required by setup, params persist across reboots
echo "Preparation for Container Runtime (containerd)"

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

# Apply sysctl params without reboot:

sudo sysctl --system

echo "Done!"

# Verify that net.ipv4.ip_forward is set to 1: 
sysctl net.ipv4.ip_forward

## Install Docker Engine:
# Add Docker's official GPG key:
echo "Add Docker's official GPG key"

sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Done!"

# Add the repository to Apt sources:
echo "Add the repository to Apt sources"

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

echo "Done!"

# To install the latest version:
echo "Installing Docker packages"

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Done!"
 
## Containerd Config Default:
echo "Setup Containerd Config Default"

containerd config default > /etc/containerd/config.toml

systemctl restart containerd
