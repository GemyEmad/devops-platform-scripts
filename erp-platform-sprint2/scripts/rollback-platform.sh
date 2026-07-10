#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

export ENV_FILE="${ENV_FILE:-./environments/dev/platform.env}"
source scripts/common.sh

section "ERP Platform Sprint 2 Rollback"

bash components/kubernetes-dashboard/rollback.sh || true
bash components/cert-manager/rollback.sh || true
bash components/metrics-server/rollback.sh || true
bash components/nginx-ingress/rollback.sh || true
bash components/metallb/rollback.sh || true

section "Rollback completed"
