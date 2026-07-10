#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Rollback NGINX Ingress"

require_kube
require_helm

helm uninstall "$INGRESS_RELEASE_NAME" -n "$INGRESS_NAMESPACE" || true
kubectl delete namespace "$INGRESS_NAMESPACE" --ignore-not-found=true

log "NGINX Ingress rollback completed."
