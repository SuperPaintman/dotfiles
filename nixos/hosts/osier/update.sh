#!/usr/bin/env bash

set -euo pipefail

SSH_USER="<user>"
IP="<ip>"

# Secrets.
ssh "$SSH_USER@$IP" '(umask 077 && mkdir -p /secrets) && chown root:root /secrets'

if [ -f "./secrets/unpoller/env" ]; then
  ssh "$SSH_USER@$IP" ' (umask 077 && mkdir -p /secrets/unpoller) && chown unpoller:unpoller /secrets/unpoller' && \
    ssh "$SSH_USER@$IP" '(umask 077 && touch /secrets/unpoller/env) && chmod 0400 /secrets/unpoller/env && chown unpoller:unpoller /secrets/unpoller/env' && \
    (cat ./secrets/unpoller/env | ssh "$SSH_USER@$IP" 'cat > /secrets/unpoller/env') || \
    true
fi

if [ -f "./secrets/alertmanager/env" ]; then
  ssh "$SSH_USER@$IP" ' (umask 077 && mkdir -p /secrets/alertmanager) && chown alertmanager:alertmanager /secrets/alertmanager' && \
    ssh "$SSH_USER@$IP" '(umask 077 && touch /secrets/alertmanager/env) && chmod 0400 /secrets/alertmanager/env && chown alertmanager:alertmanager /secrets/alertmanager/env' && \
    (cat ./secrets/alertmanager/env | ssh "$SSH_USER@$IP" 'cat > /secrets/alertmanager/env') || \
    true
fi

ssh "$SSH_USER@$IP" '(umask 077 && mkdir -p /etc/nixos/alertmanager) && chown root:root /etc/nixos/alertmanager && chmod 0755 /etc/nixos/alertmanager'
scp ./alertmanager/telegram.tmpl "$SSH_USER@$IP:/etc/nixos/alertmanager/telegram.tmpl"

scp ./hardware-configuration.nix "$SSH_USER@$IP:/etc/nixos/hardware-configuration.nix"
scp ./default.nix "$SSH_USER@$IP:/etc/nixos/configuration.nix"

ssh "$SSH_USER@$IP" nixos-rebuild switch
