#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Rollback Kubernetes Dashboard"

require_kube
require_helm

helm uninstall "$DASHBOARD_RELEASE_NAME" -n "$DASHBOARD_NAMESPACE" || true
kubectl delete clusterrolebinding "$DASHBOARD_ADMIN_SA" --ignore-not-found=true
kubectl delete namespace "$DASHBOARD_NAMESPACE" --ignore-not-found=true

log "Kubernetes Dashboard rollback completed."
