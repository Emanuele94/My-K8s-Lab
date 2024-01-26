# Kubernetes Setup Script

This script automates the setup process for Kubernetes on a Ubuntu 22 system using containerd as the container runtime. It installs the necessary dependencies and configures containerd according to Kubernetes requirements.

## Prerequisites

Make sure you have the following prerequisites installed on your system:

- root access
- Ubuntu 22 Linux distribution (the script is designed for Ubuntu)
- Internet connection for package downloads

## How to use:
On Control-plane node:
- execute install-requirements.sh.
- execute init-master-k8s.sh
On Worker node:
- use the output-node file (in control-plane node) to complete the kubeadm join using the string present at the end of the file

## Docs used
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
- https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart
- https://www.itzgeek.com/how-tos/linux/ubuntu-how-tos/install-containerd-on-ubuntu-22-04.html
- [https://github.com/kubernetes/kubernetes/issues/112622](https://github.com/kubernetes/kubernetes/issues/110177) (issue for ubuntu 22, updated and set SystemdCgroup = true & sandbox_image = "registry.k8s.io/pause:3.9")
