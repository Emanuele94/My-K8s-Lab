#!/bin/bash

# Ensure the script is executed as root
# (since some commands require elevated privileges)
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root. Please use sudo."
  exit 1
fi

# Update system
sudo apt update

# Install required packages
sudo apt install -y ca-certificates curl gnupg lsb-release apt-transport-https gpg

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# Update again after adding repository
sudo apt update

# Install containerd.io
sudo apt install -y containerd.io

# Configure containerd for kubeadm
cat <<EOF | sudo tee -a /etc/containerd/config.toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
EOF

# Uncomment the disabled_plugins line
sudo sed -i 's/^disabled_plugins \=/\#disabled_plugins \=/g' /etc/containerd/config.toml

# Restart containerd
sudo systemctl restart containerd

# Install Kube components
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Add overlay and br_netfilter modules to modules-load.d/k8s.conf
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

# Load overlay and br_netfilter modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Configure sysctl parameters
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Verify loaded modules
echo "Checking loaded modules..."
if lsmod | grep -q br_netfilter && lsmod | grep -q overlay; then
    echo "Modules br_netfilter and overlay are loaded."
else
    echo "Error: Modules br_netfilter and/or overlay are not loaded."
fi

# Verify sysctl config
echo "Checking sysctl config..."
if [ "$(sysctl -n net.bridge.bridge-nf-call-iptables)" -eq 1 ] && \
   [ "$(sysctl -n net.bridge.bridge-nf-call-ip6tables)" -eq 1 ] && \
   [ "$(sysctl -n net.ipv4.ip_forward)" -eq 1 ]; then
    echo "Sysctl parameters are set correctly."
else
    echo "Error: Sysctl parameters are not set correctly."
fi

echo "Kubernetes setup completed!"
