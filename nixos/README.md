# NixOS Configuration

```sh
# Set NixOS channel.
# See: https://nixos.org/nixos/manual/index.html#sec-upgrading .
$ sudo nix-channel --add https://nixos.org/channels/nixos-20.03 nixos
$ sudo nix-channel --update

# Check which NixOS channel we are subscribed.
$ sudo nix-channel --list | grep nixos
```
