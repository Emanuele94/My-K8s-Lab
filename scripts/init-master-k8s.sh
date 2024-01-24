#!/bin/bash
# run as root

# Initialize the Kubernetes master node with kubeadm
kubeadm init --config kubeadm-config.yaml

export KUBECONFIG=/etc/kubernetes/admin.conf
