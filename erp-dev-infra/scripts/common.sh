#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="/opt/erp-dev-infra"
ENV_FILE="$PROJECT_DIR/env/dev.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: Environment file not found: $ENV_FILE"
  exit 1
fi

# shellcheck source=/dev/null
source "$ENV_FILE"

mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/install-$(date '+%F').log"

log() {
  echo "[$(date '+%F %T')] $*" | tee -a "$LOG_FILE"
}

fail() {
  log "ERROR: $*"
  exit 1
}

run() {
  log "RUN: $*"
  "$@" 2>&1 | tee -a "$LOG_FILE"
}

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    fail "Please run as root or with sudo."
  fi
}

backup_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    cp "$file" "${file}.bak.$(date '+%F-%H%M%S')"
  fi
}

section() {
  log "========================================"
  log "$*"
  log "========================================"
}
