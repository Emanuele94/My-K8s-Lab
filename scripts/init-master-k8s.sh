#!/bin/bash
# This script initializes a Kubernetes master node using kubeadm,
# installs Calico for networking, and performs additional configuration.

# Ensure the script is executed as root
# (since some commands require elevated privileges)
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root. Please use sudo."
  exit 1
fi

# Initialize the Kubernetes master node with kubeadm using a configuration file
kubeadm init --pod-network-cidr=192.168.0.0/16

# Set up kubeconfig for the root user to allow kubectl access
export KUBECONFIG=/etc/kubernetes/admin.conf

# Wait for 180 seconds to allow K8s pods to start
echo "Waiting for 180 seconds..."
sleep 180

# Install Calico on the cluster for networking
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/custom-resources.yaml

# Wait for 60 seconds to allow Calico pods to start
echo "Waiting for 60 seconds..."
sleep 60

# Watch the progress of Calico pods in the calico-system namespace
watch kubectl get pods -n calico-system
