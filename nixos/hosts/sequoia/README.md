# Sequoia

My desktop.

> [Sequoia](https://en.wikipedia.org/wiki/Sequoiadendron_giganteum)

## Installation

```bash
# Make sure you in the dotfiles dir.
$ DOTFILES="$(pwd)"

# Backup generated configuration file.
$ sudo cp /etc/nixos/configuration.nix "/etc/nixos/configuration.nix.$(date +'%s').bu"

$ sudo tee /etc/nixos/configuration.nix <<EOF
{ config, pkgs, ... }:

{
  imports = [
    $DOTFILES/nixos/hosts/sequoia
  ];
}
EOF
```
