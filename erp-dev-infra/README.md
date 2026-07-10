# Dev Infrastructure - Sprint 1

This repository bootstraps the first Kubernetes control-plane node for the ERP Dev environment.

## Target OS

- Rocky Linux 9 / RHEL 9 compatible

## Sprint 1 Scope

- Base OS packages
- Hostname and `/etc/hosts`
- Timezone and Chrony
- Kernel prerequisites
- Containerd
- Kubernetes packages
- kubeadm control-plane initialization
- Calico CNI
- Basic validation

## Files

```text
erp-dev-infra/
├── README.md
├── env/
│   └── dev.env
├── scripts/
│   ├── common.sh
│   ├── 01-base.sh
│   ├── 02-network.sh
│   ├── 03-chrony.sh
│   ├── 04-containerd.sh
│   ├── 05-kubernetes.sh
│   ├── 06-control-plane.sh
│   ├── 08-validation.sh
│   └── install-control-plane.sh
├── manifests/
├── helm/
├── pipeline/
├── docs/
└── logs/
```

## Before running

Edit:

```bash
vim env/dev.env
```

Update these values:

```bash
CONTROL_PLANE_IP="00000"
WORKER01_IP="0000"
WORKER02_IP="0000"
```

## Run on control-plane01

```bash
cd /opt
sudo cp -r erp-dev-infra /opt/erp-dev-infra
cd /opt/erp-dev-infra
sudo chmod +x scripts/*.sh
sudo ./scripts/install-control-plane.sh
```

## After success

Check:

```bash
kubectl get nodes -o wide
kubectl get pods -A
cat /opt/erp-dev-infra/join-worker.sh
```

Use `join-worker.sh` later on worker nodes.