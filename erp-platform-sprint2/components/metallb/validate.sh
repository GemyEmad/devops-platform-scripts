#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Validate MetalLB"

require_kube

run kubectl get pods -n "$METALLB_NAMESPACE" -o wide
run kubectl get ipaddresspool -n "$METALLB_NAMESPACE"
run kubectl get l2advertisement -n "$METALLB_NAMESPACE"

log "MetalLB validation completed."
