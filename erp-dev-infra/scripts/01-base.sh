#!/usr/bin/env bash
source /opt/erp-dev-infra/scripts/common.sh
require_root

section "01 - Base OS Configuration"

log "Updating OS packages"
run dnf update -y

log "Installing base packages"
run dnf install -y \
  vim \
  wget \
  curl \
  git \
  tar \
  unzip \
  nano \
  net-tools \
  bind-utils \
  bash-completion \
  chrony \
  firewalld \
  iproute \
  lsof \
  yum-utils \
  device-mapper-persistent-data \
  lvm2 \
  ca-certificates \
  gnupg2

log "Setting timezone to $TIMEZONE"
run timedatectl set-timezone "$TIMEZONE"

log "Enabling firewalld and chronyd"
run systemctl enable --now firewalld
run systemctl enable --now chronyd

log "Disabling swap"
swapoff -a || true
sed -i '/ swap / s/^/#/' /etc/fstab

log "Configuring SELinux as permissive"
setenforce 0 || true
sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config

log "Loading Kubernetes kernel modules"
cat >/etc/modules-load.d/k8s.conf <<EOF_K8S_MODULES
overlay
br_netfilter
ip_tables
ip6_tables
EOF_K8S_MODULES

run modprobe overlay
run modprobe br_netfilter
run modprobe ip_tables
run modprobe ip6_tables

log "Applying Kubernetes sysctl settings"
cat >/etc/sysctl.d/k8s.conf <<EOF_K8S_SYSCTL
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
EOF_K8S_SYSCTL

run sysctl --system

log "Base OS configuration completed"
