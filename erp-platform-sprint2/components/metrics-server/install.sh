#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Install Metrics Server"

require_kube
require_helm

run helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
run helm repo update

run helm upgrade --install "$METRICS_RELEASE_NAME" metrics-server/metrics-server \
  --namespace "$METRICS_NAMESPACE" \
  --version "$METRICS_CHART_VERSION" \
  -f components/metrics-server/values/dev-values.yaml

wait_deploy "$METRICS_NAMESPACE" "$METRICS_RELEASE_NAME" "300s"

log "Metrics Server installed."
