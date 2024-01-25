# Kubernetes Setup Script

This script automates the setup process for Kubernetes on a Ubuntu 22 system using containerd as the container runtime. It installs the necessary dependencies and configures containerd according to Kubernetes requirements.

## Prerequisites

Make sure you have the following prerequisites installed on your system:

- root access
- Ubuntu 22 Linux distribution (the script is designed for Ubuntu)
- Internet connection for package downloads

## How to use:
execute install-requirements.sh, the script will execute init-master as last command.
to move on with join worker, use the output-node file to complete the kubeadm join

## docs
- https://www.itzgeek.com/how-tos/linux/ubuntu-how-tos/install-containerd-on-ubuntu-22-04.html
- https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart
- https://github.com/kubernetes/kubernetes/issues/112622 (issue for ubuntu 22, updated and set SystemdCgroup = true & sandbox_image = "registry.k8s.io/pause:3.9")
- 
