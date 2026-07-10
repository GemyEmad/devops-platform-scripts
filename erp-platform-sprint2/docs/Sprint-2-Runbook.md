# Sprint 2 Runbook

## Order

1. MetalLB
2. NGINX Ingress
3. Metrics Server
4. cert-manager
5. Kubernetes Dashboard
6. Full validation

## Before Start

```bash
kubectl get nodes -o wide
kubectl get pods -A
```

All nodes must be `Ready`.

## MetalLB

MetalLB gives LoadBalancer services an external IP range on bare metal.

Set the range in:

```bash
environments/dev/platform.env
```

Example:

```bash
METALLB_IP_RANGE="0000"
```

## NGINX Ingress

The ingress controller service should receive an external IP from MetalLB.

```bash
kubectl get svc -n ingress-nginx
```

## Metrics Server

Validate:

```bash
kubectl top nodes
kubectl top pods -A
```

If not ready, wait 1-2 minutes and retry.

## cert-manager

Current setup uses a self-signed ClusterIssuer for DEV.

## Dashboard

Access through port-forward only.

## Rollback

```bash
./scripts/rollback-platform.sh
```
