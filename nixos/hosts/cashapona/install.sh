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
USERNAME="${USERNAME:-"superpaintman"}"
DOTFILES="${DOTFILES:-"/home/$USERNAME/Projects/github.com/SuperPaintman/dotfiles"}"

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
step 2 "Create users"
progress "Create $USERNAME"

dirty useradd -m "$USERNAME"
dirty passwd "$USERNAME"

echo

# Step 3.
step 3 "Clone the dotfiles repo"
progress "Clone https://github.com/SuperPaintman/dotfiles"
dirty sudo -u "$USERNAME" \
    nix-shell -p pkgs.git \
    --run "git\ clone\ https://github.com/SuperPaintman/dotfiles\ $DOTFILES"

echo

# Step 4.
step 4 "Rebuild the system"
progress "Change directory"
pushd "$DOTFILES"

echo

progress "Make"
dirty nix-shell -p pkgs.gnumake \
    --run "make\ nixos"

echo

progress "Change directory"
popd

echo

message "Your system is ready!"
