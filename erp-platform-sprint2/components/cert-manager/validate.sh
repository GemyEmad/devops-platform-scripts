#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Validate cert-manager"

require_kube

run kubectl get pods -n "$CERT_MANAGER_NAMESPACE" -o wide
run kubectl get clusterissuer

log "cert-manager validation completed."
