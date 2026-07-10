#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Install Kubernetes Dashboard"

require_kube
require_helm

run kubectl create namespace "$DASHBOARD_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

run helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
run helm repo update

run helm upgrade --install "$DASHBOARD_RELEASE_NAME" kubernetes-dashboard/kubernetes-dashboard \
  --namespace "$DASHBOARD_NAMESPACE" \
  --version "$DASHBOARD_CHART_VERSION" \
  -f components/kubernetes-dashboard/values/dev-values.yaml

log "Applying dashboard admin user for DEV only."
tmp="$(mktemp)"
envsubst < components/kubernetes-dashboard/admin-user.yaml > "$tmp"
run kubectl apply -f "$tmp"

log "Kubernetes Dashboard installed."
