#!/usr/bin/env bash
source /opt/erp-dev-infra/scripts/common.sh
require_root

section "08 - Validation"

export KUBECONFIG=/etc/kubernetes/admin.conf

log "Validating services"
systemctl is-active --quiet containerd && log "containerd: active" || fail "containerd is not active"
systemctl is-active --quiet kubelet && log "kubelet: active" || fail "kubelet is not active"
systemctl is-active --quiet firewalld && log "firewalld: active" || fail "firewalld is not active"
systemctl is-active --quiet chronyd && log "chronyd: active" || fail "chronyd is not active"

log "Validating Kubernetes node status"
kubectl get nodes -o wide | tee -a "$LOG_FILE"

log "Validating Kubernetes system pods"
kubectl get pods -A | tee -a "$LOG_FILE"

log "Validating namespace"
kubectl get namespace erp-dev | tee -a "$LOG_FILE"

log "Validation completed"
