# Cashapona

My laptop.

> [Cashapona](https://en.wikipedia.org/wiki/Socratea_exorrhiza)

## Specs

[Dell XPS 15 7590-6401](https://github.com/NixOS/nixos-hardware/tree/master/dell/xps/15-7590)

## Installation

```bash
# Setup the machine. It does partitioning, formatting and installing.
$ curl -sL -o /tmp/setup.sh https://raw.githubusercontent.com/SuperPaintman/dotfiles/master/nixos/hosts/cashapona/setup.sh
$ chmod +x /tmp/setup.sh
$ sudo /tmp/setup.sh --dry

# Then reboot the machine and run `install.sh` once.

# Create main user and install all files.
$ curl -sL -o /tmp/install.sh https://raw.githubusercontent.com/SuperPaintman/dotfiles/master/nixos/hosts/cashapona/install.sh
$ chmod +x /tmp/install.sh
$ sudo /tmp/install.sh --dry
```

```bash
# Make sure you in the dotfiles dir.
$ DOTFILES="$(pwd)"

# Backup generated configuration file.
$ sudo cp /etc/nixos/configuration.nix "/etc/nixos/configuration.nix.$(date +'%s').bu"

$ sudo tee /etc/nixos/configuration.nix <<EOF
{ config, pkgs, ... }:

{
  imports = [
    $DOTFILES/nixos/hosts/cashapona
  ];
}
EOF
```

## Issues

- My laptop makes the "[coil whine](https://xps-15.fandom.com/wiki/High_Pitched_Chattering/Squeal)" sound.

## Links

- [Dell XPS 15 7590](https://github.com/NixOS/nixos-hardware/tree/master/dell/xps/15-7590) - NixOS profile from **nixos-hardware**.
- [Dell XPS 15 7590](https://wiki.archlinux.org/index.php/Dell_XPS_15_7590) - Arch linux wiki.
- [Dell XPS 15 7590](https://xps-15.fandom.com/wiki/XPS_15_Wiki) - XPS 15 Fandom wiki.
