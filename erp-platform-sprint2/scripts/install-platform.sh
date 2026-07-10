#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

export ENV_FILE="${ENV_FILE:-./environments/dev/platform.env}"

source scripts/common.sh

section "ERP Platform Sprint 2 Installation"

bash components/metallb/install.sh
bash components/metallb/configure.sh
bash components/metallb/validate.sh

bash components/nginx-ingress/install.sh
bash components/nginx-ingress/validate.sh

bash components/metrics-server/install.sh
bash components/metrics-server/validate.sh

bash components/cert-manager/install.sh
bash components/cert-manager/validate.sh

bash components/kubernetes-dashboard/install.sh
bash components/kubernetes-dashboard/validate.sh

bash scripts/validate-platform.sh

section "Sprint 2 completed"
log "Dashboard token:"
bash components/kubernetes-dashboard/token.sh | tee -a "$LOG_FILE"
