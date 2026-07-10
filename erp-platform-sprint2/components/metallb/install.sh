#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Install MetalLB"

require_kube

run kubectl apply -f "https://raw.githubusercontent.com/metallb/metallb/${METALLB_VERSION}/config/manifests/metallb-native.yaml"

log "Waiting for MetalLB controller and speakers..."
run kubectl -n "$METALLB_NAMESPACE" rollout status deployment/controller --timeout=300s
run kubectl -n "$METALLB_NAMESPACE" rollout status daemonset/speaker --timeout=300s

log "MetalLB installed."
