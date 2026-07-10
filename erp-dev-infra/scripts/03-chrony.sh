#!/usr/bin/env bash
source /opt/erp-dev-infra/scripts/common.sh
require_root

section "03 - Chrony NTP Configuration"

backup_file /etc/chrony.conf

cat >/etc/chrony.conf <<EOF_CHRONY
server time.google.com iburst
server 0.pool.ntp.org iburst
server 1.pool.ntp.org iburst

allow ${NTP_ALLOWED_NETWORK}
local stratum 10

driftfile /var/lib/chrony/drift
makestep 1.0 3
rtcsync
logdir /var/log/chrony
EOF_CHRONY

run systemctl enable --now chronyd
run systemctl restart chronyd

run firewall-cmd --permanent --add-service=ntp
run firewall-cmd --reload

chronyc tracking || true
chronyc sources || true

log "Chrony configuration completed"
