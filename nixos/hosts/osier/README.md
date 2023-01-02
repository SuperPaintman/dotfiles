# Osier

My Raspberry Pi home server.

## Specs

Raspberry Pi 3 Model B Vi. 2

## Installation

```bash
$ curl -sL -o ./nixos-sd-image-20.09.4331.686720050c3-aarch64-linux.img.zst https://hydra.nixos.org/build/145713954/download/1/nixos-sd-image-20.09.4331.686720050c3-aarch64-linux.img.zst
$ nix-shell -p zstd --run "unzstd ./nixos-sd-image-20.09.4331.686720050c3-aarch64-linux.img.zst"

# Or build a new image.

$ nix-build -I 'nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/tags/20.09.tar.gz' -I 'nixos-config=./image.nix' '<nixpkgs/nixos>' -A config.system.build.sdImage
```

## Checklist

- [ ] Change the Root password. `sudo passwd root`.
- [ ] Change the main user password. `sudo passwd superpaintman`.

## Links

- [NixOS on ARM](https://nixos.wiki/wiki/NixOS_on_ARM)
