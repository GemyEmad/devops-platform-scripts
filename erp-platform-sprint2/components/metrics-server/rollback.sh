#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Rollback Metrics Server"

require_kube
require_helm

helm uninstall "$METRICS_RELEASE_NAME" -n "$METRICS_NAMESPACE" || true
log "Metrics Server rollback completed."
