#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Validate NGINX Ingress"

require_kube

run kubectl get pods -n "$INGRESS_NAMESPACE" -o wide
run kubectl get svc -n "$INGRESS_NAMESPACE" -o wide
run kubectl get ingressclass

log "Look for EXTERNAL-IP assigned from MetalLB range: ${METALLB_IP_RANGE}"
