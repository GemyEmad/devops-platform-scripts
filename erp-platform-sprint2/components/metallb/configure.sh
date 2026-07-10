#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
source scripts/common.sh

section "Configure MetalLB IP Pool"

require_kube

tmp="$(mktemp -d)"
envsubst < components/metallb/manifests/ip-pool.yaml > "$tmp/ip-pool.yaml"
envsubst < components/metallb/manifests/l2-advertisement.yaml > "$tmp/l2-advertisement.yaml"

run kubectl apply -f "$tmp/ip-pool.yaml"
run kubectl apply -f "$tmp/l2-advertisement.yaml"

log "MetalLB configured with range: ${METALLB_IP_RANGE}"
