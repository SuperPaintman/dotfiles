#!/usr/bin/env bash

set -e
set -u
set -o pipefail

# Params.
DRY_RUN=""

for arg in "$@"; do
    case "$arg" in
        --dry | --dry-run)
            DRY_RUN="yes"
            ;;
    esac
done

# ENV.
WIFI_SSID="${WIFI_SSID:-}"
SWAP_SIZE="${SWAP_SIZE:-24}"
DISK="${DISK:-"/dev/nvme0n1"}"
DISK_NIXOS="${DISK_NIXOS:-"/dev/nvme0n1p1"}"
DISK_SWAP="${DISK_SWAP:-"/dev/nvme0n1p2"}"
DISK_BOOT="${DISK_BOOT:-"/dev/nvme0n1p3"}"
DOTFILES="${DOTFILES:-"/home/superpaintman/Projects/github.com/SuperPaintman/dotfiles"}"

# Init.
COLOR_RESET=""
COLOR_RED=""
COLOR_GREEN=""
COLOR_BLUE=""
COLOR_YELLOW=""
COLOR_GRAY=""

# Check if stdout is a terminal.
if [ -t 1 ]; then
    COLOR_RESET="$(printf "\033[0m")"
    COLOR_RED="$(printf "\033[31;01m")"
    COLOR_GREEN="$(printf "\033[0;32m")"
    COLOR_BLUE="$(printf "\033[0;34m")"
    COLOR_YELLOW="$(printf "\033[33;01m")"
    COLOR_GRAY="$(printf "\033[90m")"
fi

# Helpers.
step() {
    echo "${COLOR_YELLOW}===${COLOR_RESET} Step $1: ${@:2}"
}

progress() {
    echo "${COLOR_YELLOW}---${COLOR_RESET} $@"
}

message() {
    echo "${COLOR_BLUE}$@${COLOR_RESET}"
}

ok() {
    echo "${COLOR_GREEN}[ok]${COLOR_RESET} $@"
}

error() {
    echo "${COLOR_RED}[error]${COLOR_RESET} $@"
}

point() {
    echo " ${COLOR_GRAY}*${COLOR_RESET} $@"
}

die() {
    echo "${COLOR_RED}${@}${COLOR_RESET}" 1>&2
    exit 1
}

input() {
    echo -n "${COLOR_BLUE}$1${COLOR_RESET}: "
    read "$2"
}

dirty() {
    echo " ${COLOR_GREEN}\$${COLOR_RESET} $@"

    if [ "$DRY_RUN" = "" ]; then
        eval $@
    fi
}

dirty_tee() {
    if [ "$DRY_RUN" = "" ]; then
        tee $@
    else
        echo " ${COLOR_GREEN}\$${COLOR_RESET} tee $@"
        while IFS= read -r line; do
            echo "    ${COLOR_YELLOW}$line${COLOR_RESET}"
        done
    fi
}

# Check if user is root.
if [ "$EUID" -ne 0 ] && [ "$DRY_RUN" = "" ]; then
    die "Please run this script as root"
fi

# Steps.
## Step 1.
step 1 "Configure the network"
progress "Checking connection"

wifi_ssids=$(
    nmcli \
        --colors no \
        --terse \
        --mode tabular \
        --fields ssid \
        device wifi list
)
if [ ! "$?" = "0" ]; then
    die "Failed to get wifi networks"
fi

message "Choose WIFI network"
for ssid in $wifi_ssids; do
    point "$ssid"
done

if [ "$WIFI_SSID" = "" ]; then
    while true; do
        input "SSID" choosen

        WIFI_SSID="$choosen"

        break
    done
fi

echo

progress "Connect to $WIFI_SSID"
dirty nmcli device wifi connect "$WIFI_SSID" --ask || {
    die "Failed to connect to the wifi network"
}

echo

# Step 2.
step 2 "Partitioning and formatting"
message "Using ${DISK} as the device"

echo

progress "Create a GPT partition table"
dirty parted "$DISK" -- mklabel gpt

echo

progress "Add the root partition"
dirty parted "$DISK" -- mkpart primary 640MB "-${SWAP_SIZE}GB"

echo

progress "Add a swap partition"
dirty parted "$DISK" -- mkpart primary linux-swap "-${SWAP_SIZE}GB" 100%

echo

progress "Add the boot partition"
dirty parted "$DISK" -- mkpart ESP fat32 1MiB 512MiB
dirty parted "$DISK" -- set 3 esp on

echo

progress "Format the root partition"
dirty mkfs.ext4 -L nixos "$DISK_NIXOS"

echo

progress "Format a swap partition"
dirty mkswap -L swap "$DISK_SWAP"

echo

progress "Format the boot partition"
dirty mkfs.fat -F 32 -n boot "$DISK_BOOT"

echo

# Step 3.
step 3 "Installing"
progress "Mount the target file system on /mnt"
dirty mount /dev/disk/by-label/nixos /mnt

echo

progress "Mount the boot file system on /mnt/boot"
dirty mkdir -p /mnt/boot
dirty mount /dev/disk/by-label/boot /mnt/boot

echo

progress "Activate a swap"
dirty swapon "$DISK_SWAP"

echo

progress "Generate an initial NisOS configuration"
dirty nixos-generate-config --root /mnt

echo

progress "Backup generated configuration files"
dirty cp /mnt/etc/nixos/configuration.nix "/mnt/etc/nixos/configuration.nix.$(date +'%s').bu"
dirty cp /mnt/etc/nixos/hardware-configuration.nix "/mnt/etc/nixos/hardware-configuration.nix.$(date +'%s').bu"
dirty cp /mnt/etc/nixos/configuration.nix /mnt/etc/nixos/initial.nix

echo

progress "Download configuration files"
dirty curl \
    -sL \
    -o /mnt/etc/nixos/hardware-configuration.nix \
    https://raw.githubusercontent.com/SuperPaintman/dotfiles/master/nixos/hosts/cashapona/hardware-configuration.nix
dirty curl \
    -sL \
    -o /mnt/etc/nixos/hardware-configuration-extra.nix \
    https://raw.githubusercontent.com/SuperPaintman/dotfiles/master/nixos/hosts/cashapona/hardware-configuration-extra.nix

echo

progress "Create /etc/nixos/configuration.nix"
dirty_tee /mnt/etc/nixos/configuration.nix << EOF
{ config, pkgs, ... }:

{
  imports =
    if builtins.pathExists $DOTFILES/nixos/hosts/cashapona
    then [
      $DOTFILES/nixos/hosts/cashapona
    ]
    else (
      (if builtins.pathExists ./hardware-configuration.nix then [ ./hardware-configuration.nix ] else [ ])
      ++ (if builtins.pathExists ./hardware-configuration-extra.nix then [ ./hardware-configuration-extra.nix ] else [ ])
      ++ (if builtins.pathExists ./initial.nix then [ ./initial.nix ] else [ ])
    );
}
EOF

echo

progress "Do the installation"
dirty nixos-install

echo

message 'Please run `reboot`'
