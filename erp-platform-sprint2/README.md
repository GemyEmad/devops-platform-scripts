# Platform - Sprint 2

This sprint installs the Kubernetes platform foundation for `erp-dev`.

## Components

- MetalLB
- NGINX Ingress Controller
- Metrics Server
- cert-manager
- Kubernetes Dashboard
- Validation and rollback scripts

## Install

Copy this repo to `/opt/erp-platform-sprint2` on the control-plane node.

```bash
cd /opt
unzip erp-platform-sprint2.zip
cd /opt/erp-platform-sprint2
```

Edit:

```bash
vim environments/dev/platform.env
```

Important values:

```bash
METALLB_IP_RANGE="0000"
PROJECT_ROOT="/opt/erp-platform-sprint2"
```

Run:

```bash
chmod +x scripts/*.sh components/*/*.sh
sudo ./scripts/install-platform.sh
```

## Validate

```bash
./scripts/validate-platform.sh
```

## Dashboard Access

```bash
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 000
```

Open:

```text
https://127.0.0.1:000
```

Generate token:

```bash
./components/kubernetes-dashboard/token.sh
```

## Rollback

```bash
sudo ./scripts/rollback-platform.sh
```

## Notes

This is DEV setup. Do not use the dashboard admin ClusterRoleBinding in Production.
