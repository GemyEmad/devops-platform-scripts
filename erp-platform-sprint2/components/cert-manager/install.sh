#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Install cert-manager"

require_kube
require_helm

run kubectl create namespace "$CERT_MANAGER_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

run helm repo add jetstack https://charts.jetstack.io
run helm repo update

run helm upgrade --install "$CERT_MANAGER_RELEASE_NAME" jetstack/cert-manager \
  --namespace "$CERT_MANAGER_NAMESPACE" \
  --version "$CERT_MANAGER_CHART_VERSION" \
  -f components/cert-manager/values/dev-values.yaml

wait_deploy "$CERT_MANAGER_NAMESPACE" "${CERT_MANAGER_RELEASE_NAME}" "300s"
wait_deploy "$CERT_MANAGER_NAMESPACE" "${CERT_MANAGER_RELEASE_NAME}-webhook" "300s"
wait_deploy "$CERT_MANAGER_NAMESPACE" "${CERT_MANAGER_RELEASE_NAME}-cainjector" "300s"

run kubectl apply -f components/cert-manager/selfsigned-clusterissuer.yaml

log "cert-manager installed."
