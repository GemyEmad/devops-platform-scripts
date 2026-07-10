#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Generate Dashboard Token"

require_kube

kubectl -n "$DASHBOARD_NAMESPACE" create token "$DASHBOARD_ADMIN_SA"
