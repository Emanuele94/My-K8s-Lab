#!/bin/bash
# run as root
# Specify the CIDR Range for Pods
CIDR_RANGE="10.244.0.0/16"

# Initialize the Kubernetes master node with kubeadm
kubeadm init --pod-network-cidr=$CIDR_RANGE

export KUBECONFIG=/etc/kubernetes/admin.conf
