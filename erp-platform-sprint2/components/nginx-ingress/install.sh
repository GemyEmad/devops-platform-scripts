#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Install NGINX Ingress"

require_kube
require_helm

run kubectl create namespace "$INGRESS_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

run helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
run helm repo update

run helm upgrade --install "$INGRESS_RELEASE_NAME" ingress-nginx/ingress-nginx \
  --namespace "$INGRESS_NAMESPACE" \
  --version "$INGRESS_CHART_VERSION" \
  -f components/nginx-ingress/values/dev-values.yaml

wait_deploy "$INGRESS_NAMESPACE" "${INGRESS_RELEASE_NAME}-controller" "300s"

log "NGINX Ingress installed."
