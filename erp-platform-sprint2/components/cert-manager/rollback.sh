#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Rollback cert-manager"

require_kube
require_helm

kubectl delete clusterissuer erp-dev-selfsigned --ignore-not-found=true
helm uninstall "$CERT_MANAGER_RELEASE_NAME" -n "$CERT_MANAGER_NAMESPACE" || true
kubectl delete namespace "$CERT_MANAGER_NAMESPACE" --ignore-not-found=true

log "cert-manager rollback completed."
