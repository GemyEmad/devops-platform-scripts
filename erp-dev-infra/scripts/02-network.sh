#!/usr/bin/env bash
source /opt/erp-dev-infra/scripts/common.sh
require_root

section "02 - Network Configuration"

log "Setting hostname to $CONTROL_PLANE_HOSTNAME"
run hostnamectl set-hostname "$CONTROL_PLANE_HOSTNAME"

log "Updating /etc/hosts"
backup_file /etc/hosts

# Remove old ERP dev block if exists
sed -i '/# ERP-DEV-BEGIN/,/# ERP-DEV-END/d' /etc/hosts

cat >>/etc/hosts <<EOF_HOSTS

# ERP-DEV-BEGIN
${CONTROL_PLANE_IP} ${CONTROL_PLANE_HOSTNAME}
${WORKER01_IP} ${WORKER01_HOSTNAME}
${WORKER02_IP} ${WORKER02_HOSTNAME}
# ERP-DEV-END
EOF_HOSTS

log "Opening Kubernetes control-plane firewall ports"
run firewall-cmd --permanent --add-port=000/tcp
run firewall-cmd --permanent --add-port=0000/tcp
run firewall-cmd --permanent --add-port=000/tcp
run firewall-cmd --permanent --add-port=000/tcp
run firewall-cmd --permanent --add-port=000/tcp
run firewall-cmd --permanent --add-port=0000/tcp
run firewall-cmd --reload

log "Checking DNS resolution"
if command -v dig >/dev/null 2>&1; then
  dig google.com +short || true
fi

log "Network configuration completed"
