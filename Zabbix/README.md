Sure, here's a sample README.md documentation for your Kubernetes configuration:

# Zabbix Kubernetes Deployment

This repository contains Kubernetes manifests for deploying Zabbix monitoring components using Kubernetes. The deployment includes a PostgreSQL database, Zabbix server instances, and a Zabbix web frontend.

## Prerequisites

Make sure you have a Kubernetes cluster up and running. Additionally, ensure that `kubectl` is configured to communicate with your cluster.

## Deploy PostgreSQL Database

### StatefulSet and Service

Create a StatefulSet and Service for the PostgreSQL database:

```bash
kubectl apply -f postgres-statefulset-service.yaml
```

This deploys a PostgreSQL database with a single replica and exposes it as a Kubernetes service.

## Deploy Zabbix Server Instances

### Zabbix Server 01

Deploy the first Zabbix server instance:

```bash
kubectl apply -f zabbix-server-01-deployment.yaml
```

### Zabbix Server 02

Deploy the second Zabbix server instance:

```bash
kubectl apply -f zabbix-server-02-deployment.yaml
```

These deployments include Zabbix server instances configured to connect to the PostgreSQL database.

## Deploy Zabbix Frontend

Deploy the Zabbix frontend:

```bash
kubectl apply -f zabbix-frontend-deployment.yaml
```

This deployment includes the Zabbix web frontend configured to connect to the Zabbix server instances.

## Autoscaling (Optional)

If you want to enable horizontal pod autoscaling for the Zabbix frontend based on CPU utilization:

```bash
kubectl apply -f autoscaler.yaml
```

This deploys a HorizontalPodAutoscaler that adjusts the number of frontend replicas based on CPU utilization.

## Storage Configuration

This deployment uses a StorageClass named "standard" and a PersistentVolume named "pv01" for PostgreSQL data storage. Adjust the storage configurations as needed for your environment.

```bash
kubectl apply -f storage-class-pv.yaml
```

## Cleanup

To remove the deployed resources:

```bash
kubectl delete -f .
```

This will delete all resources defined in the YAML files.

## Notes

- Make sure to update environment variables such as passwords, IP addresses, and other configuration parameters according to your requirements.

- Adjust resource requests and limits, especially for CPU and memory, based on your cluster specifications and workload.

Feel free to modify the provided YAML files to suit your specific deployment requirements. For more details on Zabbix configuration, consult the official Zabbix documentation: [Zabbix Documentation](https://www.zabbix.com/documentation).

Happy monitoring with Zabbix on Kubernetes!
