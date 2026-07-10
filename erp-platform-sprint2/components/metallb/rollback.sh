#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Rollback MetalLB"

require_kube

kubectl delete l2advertisement "$METALLB_L2_ADV_NAME" -n "$METALLB_NAMESPACE" --ignore-not-found=true
kubectl delete ipaddresspool "$METALLB_IP_POOL_NAME" -n "$METALLB_NAMESPACE" --ignore-not-found=true
kubectl delete -f "https://raw.githubusercontent.com/metallb/metallb/${METALLB_VERSION}/config/manifests/metallb-native.yaml" --ignore-not-found=true

log "MetalLB rollback completed."
