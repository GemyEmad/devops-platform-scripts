#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="/opt/erp-dev-infra"

bash "$PROJECT_DIR/scripts/01-base.sh"
bash "$PROJECT_DIR/scripts/02-network.sh"
bash "$PROJECT_DIR/scripts/03-chrony.sh"
bash "$PROJECT_DIR/scripts/04-containerd.sh"
bash "$PROJECT_DIR/scripts/05-kubernetes.sh"
bash "$PROJECT_DIR/scripts/06-control-plane.sh"
bash "$PROJECT_DIR/scripts/08-validation.sh"

echo ""
echo "========================================"
echo "ERP Dev control-plane installation done"
echo "========================================"
echo "Join command: $PROJECT_DIR/join-worker.sh"
echo "Logs: $PROJECT_DIR/logs/"
echo ""
