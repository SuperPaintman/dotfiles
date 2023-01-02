#!/usr/bin/env bash

set -euo pipefail

SSH_USER="<user>"
IP="<ip>"

scp ./hardware-configuration.nix "$SSH_USER@$IP:/etc/nixos/hardware-configuration.nix"
scp ./default.nix "$SSH_USER@$IP:/etc/nixos/configuration.nix"
ssh "$SSH_USER@$IP" nixos-rebuild switch
