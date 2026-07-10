#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

export ENV_FILE="${ENV_FILE:-./environments/dev/platform.env}"
source scripts/common.sh

section "Full Platform Validation"

require_kube

run kubectl get nodes -o wide
run kubectl get pods -A
run kubectl get svc -A
run kubectl get ingressclass
run kubectl get storageclass || true
run kubectl get clusterissuer || true

log "Validation finished."
