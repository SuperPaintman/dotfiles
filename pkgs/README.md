# Custom Nix Packages and Ports

## Phases

- `prePhases`
- `unpackPhase`
- `patchPhase`
- `configurePhase`
- `buildPhase`
- `checkPhase` - only when `doCheck=true`
- `installPhase`
- `fixupPhase`
- `installCheckPhase` - only when `doInstallCheck=true`
- `distPhase`

## Resources
- <https://nixos.org/manual/nixpkgs/stable/#sec-stdenv-phases>
- <https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/setup.sh>
