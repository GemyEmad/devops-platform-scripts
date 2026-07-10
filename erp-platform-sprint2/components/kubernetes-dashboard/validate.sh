#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Validate Kubernetes Dashboard"

require_kube

run kubectl get pods -n "$DASHBOARD_NAMESPACE" -o wide
run kubectl get svc -n "$DASHBOARD_NAMESPACE"
run kubectl get sa -n "$DASHBOARD_NAMESPACE" "$DASHBOARD_ADMIN_SA"

log "Access locally with:"
log "kubectl -n ${DASHBOARD_NAMESPACE} port-forward svc/${DASHBOARD_RELEASE_NAME}-kong-proxy 8443:443"
log "Then open: https://127.0.0.1:000"
