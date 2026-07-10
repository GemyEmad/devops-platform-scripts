#!/usr/bin/env bash
source /opt/erp-dev-infra/scripts/common.sh
require_root

section "04 - Containerd Installation"

log "Installing containerd"
run dnf install -y containerd

log "Creating default containerd config"
mkdir -p /etc/containerd
containerd config default >/etc/containerd/config.toml

log "Enabling SystemdCgroup"
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

log "Setting pause sandbox image"
sed -i "s#sandbox_image = \".*\"#sandbox_image = \"${CONTAINERD_PAUSE_IMAGE}\"#" /etc/containerd/config.toml

log "Configuring crictl runtime endpoint"
cat >/etc/crictl.yaml <<EOF_CRICTL
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: false
EOF_CRICTL

run systemctl enable --now containerd
run systemctl restart containerd

run systemctl status containerd --no-pager
containerd --version | tee -a "$LOG_FILE"

log "Containerd installation completed"
