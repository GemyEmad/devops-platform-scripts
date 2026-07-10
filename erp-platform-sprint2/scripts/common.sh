#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./environments/dev/platform.env}"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: ENV_FILE not found: $ENV_FILE"
  exit 1
fi

source "$ENV_FILE"

LOG_DIR="${PROJECT_ROOT}/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/platform-install-$(date +%F).log"

log() {
  echo "[$(date '+%F %T')] $*" | tee -a "$LOG_FILE"
}

section() {
  echo "" | tee -a "$LOG_FILE"
  echo "============================================================" | tee -a "$LOG_FILE"
  echo "$*" | tee -a "$LOG_FILE"
  echo "============================================================" | tee -a "$LOG_FILE"
}

run() {
  log "RUN: $*"
  "$@" 2>&1 | tee -a "$LOG_FILE"
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "ERROR: required command not found: $1"
    exit 1
  fi
}

require_kube() {
  require_cmd kubectl
  kubectl cluster-info >/dev/null 2>&1 || {
    log "ERROR: kubectl cannot reach the cluster."
    exit 1
  }
}

require_helm() {
  if ! command -v helm >/dev/null 2>&1; then
    section "Installing Helm"
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  fi
}

wait_deploy() {
  local ns="$1"
  local deploy="$2"
  local timeout="${3:-300s}"
  run kubectl -n "$ns" rollout status deployment "$deploy" --timeout="$timeout"
}
