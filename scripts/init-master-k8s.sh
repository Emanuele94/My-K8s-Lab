#!/bin/bash
# This script initializes a Kubernetes master node using kubeadm,
# installs Calico for networking, and performs additional configuration.

# Ensure the script is executed as root
# (since some commands require elevated privileges)
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root. Please use sudo."
  exit 1
fi

# Request user input for pod-network-cidr
read -p "Enter the desired pod-network-cidr (e.g., 10.154.0.0/16): " pod_network_cidr

# Initialize the Kubernetes master node with kubeadm using the provided pod-network-cidr
kubeadm init --pod-network-cidr="$pod_network_cidr" > output-node

# Set up kubeconfig for the root user to allow kubectl access
export KUBECONFIG=/etc/kubernetes/admin.conf

# Wait for 60 seconds to allow K8s pods to start
echo "Waiting for 60 seconds..."
sleep 60


# Install Calico on the cluster for networking
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml

# Download Calico custom resources YAML file
calico_yaml_url="https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/custom-resources.yaml"
calico_yaml_local="custom-resources.yaml"

read -p "Enter the desired CIDR (e.g., 192.168.0.0/16): " cidr_input

# Replace the placeholder CIDR in the downloaded file
curl -o "$calico_yaml_local" "$calico_yaml_url"
sed -i "s|cidr: 192.168.0.0/16|cidr: $cidr_input|g" "$calico_yaml_local"

# Apply Calico custom resources
kubectl create -f "$calico_yaml_local"

echo "Calico custom resources applied successfully."
sleep 5
echo "K8s + CNI configured"
