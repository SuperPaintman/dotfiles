NIXOS_VERSION := 20.09

NIX_FILES := $(shell find -type f -name '*.nix')

NIX_LOCAL_PACKAGES := $(shell nix eval --raw \
	'( \
		with import <nixpkgs> {}; \
		with lib; \
		let \
			pkgs = callPackage ./pkgs/default.nix {}; \
		in \
			pipe pkgs [ \
				attrNames \
				(filter (n: ! elem n [ "override" "overrideDerivation" ])) \
				(concatStringsSep " ") \
			] \
	)' \
)

all: channels upgrade

.PHONY: upgrade
upgrade: update switch

.PHONY: update
update: channels
	@sudo nix-channel --update

.PHONY: switch
switch:
	@sudo nixos-rebuild switch

.PHONY: build
build:
	nixos-rebuild build

.PHONY: $(addprefix build-pkgs-, $(NIX_LOCAL_PACKAGES))
$(addprefix build-pkgs-, $(NIX_LOCAL_PACKAGES)): build-pkgs-%:
	@nix-build \
		-E 'with import <nixpkgs> {}; callPackage ./pkgs/default.nix {}' \
		-A $*

.PHONY: $(addprefix shell-pkgs-, $(NIX_LOCAL_PACKAGES))
$(addprefix shell-pkgs-, $(NIX_LOCAL_PACKAGES)): shell-pkgs-%:
	@nix-shell \
		-E 'with import <nixpkgs> {}; callPackage ./pkgs/default.nix {}' \
		-A $*

.PHONY: dry-build
dry-build:
	nixos-rebuild dry-build

.PHONY: gc
gc:
	@sudo nix-collect-garbage -d

.PHONY: format
format:
	@nixpkgs-fmt $(NIX_FILES)

# Add NixOS channels.
# See: https://nixos.org/nixos/manual/index.html#sec-upgrading .
.PHONY: channels
channels:
	@sudo nix-channel --add "https://nixos.org/channels/nixos-$(NIXOS_VERSION)" nixos
	@sudo nix-channel --add "https://nixos.org/channels/nixos-unstable" nixos-unstable
	@sudo nix-channel --list

.PHONY: uninstall-users-packages
uninstall-users-packages:
	@nix-env --uninstall $$(nix-env -q)

.PHONY: clean
clean:
	@rm -f result
