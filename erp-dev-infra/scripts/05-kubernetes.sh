#!/usr/bin/env bash
source /opt/erp-dev-infra/scripts/common.sh
require_root

section "05 - Kubernetes Packages Installation"

log "Configuring Kubernetes repository $K8S_REPO_VERSION"
cat >/etc/yum.repos.d/kubernetes.repo <<EOF_K8S_REPO
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/${K8S_REPO_VERSION}/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/${K8S_REPO_VERSION}/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF_K8S_REPO

log "Installing kubelet, kubeadm, kubectl"
run dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

log "Enabling kubelet"
run systemctl enable --now kubelet

kubeadm version | tee -a "$LOG_FILE"
kubectl version --client | tee -a "$LOG_FILE"

log "Kubernetes packages installation completed"
