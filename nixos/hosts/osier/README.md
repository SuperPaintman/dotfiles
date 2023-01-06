# Osier

My Raspberry Pi home server.

## Specs

Raspberry Pi 3 Model B Vi. 2

## Installation

```bash
$ NIXOS_IMAGE="nixos-sd-image-22.11.1329.feda52be1d5-aarch64-linux.img.zst"
$ curl -L -O "https://hydra.nixos.org/build/203683602/download/1/$NIXOS_IMAGE"
$ nix-shell -p zstd --run "unzstd ./$NIXOS_IMAGE"

# Or build a new image.

$ NIX_PATH='nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/tags/22.11.tar.gz' nix-build -I 'nixos-config=./image.nix' '<nixpkgs/nixos>' -A config.system.build.sdImage --argstr system aarch64-linux
$ nix-shell -p zstd --run "unzstd ./result/sd-image/nixos-sd-image-22.11pre-git-aarch64-linux.img.zst -o ./nixos-sd-image-22.11pre-git-aarch64-linux.img"
```

## Checklist

- [ ] Change the Root password. `sudo passwd root`.
- [ ] Change the main user password. `sudo passwd superpaintman`.

## Links

- [NixOS on ARM](https://nixos.wiki/wiki/NixOS_on_ARM)
