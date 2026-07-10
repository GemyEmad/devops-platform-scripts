#!/usr/bin/env bash
source /opt/erp-dev-infra/scripts/common.sh
require_root

section "06 - Kubernetes Control Plane Initialization"

if [[ -f /etc/kubernetes/admin.conf ]]; then
  log "Kubernetes control-plane already initialized. Skipping kubeadm init."
else
  log "Initializing Kubernetes cluster"
  run kubeadm init \
    --control-plane-endpoint="$K8S_API_ENDPOINT" \
    --pod-network-cidr="$POD_NETWORK_CIDR" \
    --service-cidr="$SERVICE_CIDR" \
    --upload-certs
fi

log "Configuring kubectl for root"
mkdir -p /root/.kube
cp -f /etc/kubernetes/admin.conf /root/.kube/config
chown root:root /root/.kube/config

if [[ -n "${SUDO_USER:-}" && "$SUDO_USER" != "root" ]]; then
  USER_HOME=$(eval echo "~$SUDO_USER")
  mkdir -p "$USER_HOME/.kube"
  cp -f /etc/kubernetes/admin.conf "$USER_HOME/.kube/config"
  chown -R "$SUDO_USER:$SUDO_USER" "$USER_HOME/.kube"
fi

export KUBECONFIG=/etc/kubernetes/admin.conf

log "Downloading Calico manifest"
CALICO_FILE="$PROJECT_DIR/manifests/calico-${CALICO_VERSION}.yaml"
mkdir -p "$PROJECT_DIR/manifests"
curl -fsSL "https://raw.githubusercontent.com/projectcalico/calico/${CALICO_VERSION}/manifests/calico.yaml" -o "$CALICO_FILE"

log "Applying Calico CNI"
run kubectl apply -f "$CALICO_FILE"

log "Waiting for control-plane node to become Ready"
kubectl wait --for=condition=Ready "node/${CONTROL_PLANE_HOSTNAME}" --timeout=300s || true

log "Creating worker join command"
kubeadm token create --print-join-command > "$JOIN_FILE"
chmod +x "$JOIN_FILE"

log "Creating ERP dev namespace"
kubectl create namespace erp-dev --dry-run=client -o yaml | kubectl apply -f -

log "Control-plane initialization completed"
log "Worker join command saved at: $JOIN_FILE"
cat "$JOIN_FILE" | tee -a "$LOG_FILE"
