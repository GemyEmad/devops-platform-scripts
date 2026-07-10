#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Validate Metrics Server"

require_kube

run kubectl get pods -n "$METRICS_NAMESPACE" | grep metrics-server || true
log "Waiting briefly for metrics API..."
sleep 20

kubectl top nodes 2>&1 | tee -a "$LOG_FILE" || {
  log "WARNING: kubectl top nodes not ready yet. Recheck after 1-2 minutes."
}

kubectl top pods -A 2>&1 | tee -a "$LOG_FILE" || true
