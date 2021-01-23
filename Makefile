NIXOS_VERSION := 20.09

NIX_LOCAL_PACKAGES := $(shell nix eval --raw \
	'( \
		with import <nixpkgs> {}; \
		with lib; \
		let \
			pkgs = callPackage ./nixos/pkgs/default.nix {}; \
		in \
			pipe pkgs [ \
				attrNames \
				(filter (n: ! elem n [ "override" "overrideDerivation" ])) \
				(concatStringsSep " ") \
			] \
	)' \
)

IGNORE_PATHS := \
	'./zsh/.oh-my-zsh/**' \
	'./zsh/.oh-my-zsh-custom/**' \
	'./vim/.vim/bundle/**' \
	'./vim/.vim/plugged/**' \
	'./tmux/.tmux/plugins/**' \
	'**/vendor/**' \
	'**/node_modules/**'
SHELL_FILES := \
	$(shell \
		find . \
			\( -type f -name '*.sh' -or -name '*.bash' -or -name '*.zsh' \) \
			$(addprefix -and -not -path , $(IGNORE_PATHS)) \
	) \
	$(shell \
		filter_bash_content() { \
			while read filename; do \
				if head -n1 "$$filename" | grep 'bash\|zsh\|sh' > /dev/null; then \
					echo "$$filename"; \
				fi; \
			done \
		} && \
		\
		find ./bin/bin ./rofi/modes \
			-type f \
			-and -not -path './bin/bin/neofetch' \
			-and -not -path './bin/bin/styles' | \
			filter_bash_content \
	)
NIX_FILES := $(shell find . \
	-type f -name '*.nix' \
	$(addprefix -and -not -path , $(IGNORE_PATHS)) \
)
PRETTIER_FILES := $(shell find . \
	-type f \( -name '*.js' -or -name '*.css' -or -name '*.json' -or -name '*.yml' -or -name '*.md' \) \
	$(addprefix -and -not -path , $(IGNORE_PATHS)) \
)
LUA_FILES := $(shell find . \
	-type f -name '*.lua' \
	$(addprefix -and -not -path , $(IGNORE_PATHS)) \
)

all:
	:

.PHONY: nixos
nixos: nixos-channels nixos-upgrade

.PHONY: nixos-upgrade
nixos-upgrade: nixos-update nixos-switch

.PHONY: nixos-update
nixos-update: channels
	@sudo nix-channel --update

.PHONY: nixos-switch
nixos-switch:
	@sudo nixos-rebuild switch

.PHONY: nixos-build
nixos-build:
	nixos-rebuild build

.PHONY: $(addprefix nixos-build-pkgs-, $(NIX_LOCAL_PACKAGES))
$(addprefix nixos-build-pkgs-, $(NIX_LOCAL_PACKAGES)): nixos-build-pkgs-%:
	@nix-build \
		-E 'with import <nixpkgs> {}; callPackage ./nixos/pkgs/default.nix {}' \
		-A $* \
		--out-link "result-$*"

.PHONY: $(addprefix nixos-shell-pkgs-, $(NIX_LOCAL_PACKAGES))
$(addprefix nixos-shell-pkgs-, $(NIX_LOCAL_PACKAGES)): nixos-shell-pkgs-%:
	@nix-shell \
		-E 'with import <nixpkgs> {}; callPackage ./nixos/pkgs/default.nix {}' \
		-A $*

.PHONY: nixos-dry-build
nixos-dry-build:
	nixos-rebuild dry-build

.PHONY: nixos-gc
nixos-gc:
	@sudo nix-collect-garbage -d

# Add NixOS channels.
# See: https://nixos.org/nixos/manual/index.html#sec-upgrading .
.PHONY: nixos-channels
nixos-channels:
	@sudo nix-channel --add "https://nixos.org/channels/nixos-$(NIXOS_VERSION)" nixos
	@sudo nix-channel --add "https://nixos.org/channels/nixos-unstable" nixos-unstable
	@sudo nix-channel --list

.PHONY: nixos-uninstall-users-packages
nixos-uninstall-users-packages:
	@nix-env --uninstall $$(nix-env -q | grep -v 'home-manager-path')

.PHONY: format
format: format-shell format-nix format-prettier

.PHONY: format-shell
format-shell:
	@./scripts/nix-call.sh shfmt shfmt -i 4 -ci -sr -s -w $(SHELL_FILES)

.PHONY: format-nix
format-nix:
	@./scripts/nix-call.sh nixpkgs-fmt nixpkgs-fmt $(NIX_FILES)

.PHONY: format-nix
format-prettier:
	@npx prettier --config ./prettier/.prettierrc.js --write $(PRETTIER_FILES)

.PHONY: format-lua
format-lua:
	@./scripts/lua-format.sh --config=./.lua-format -i $(LUA_FILES)

.PHONY: generate
generate: generate-configs generate-vscode-extensions

.PHONY: generate-configs
generate-configs:
	@./scripts/generate-configs

.PHONY: generate-vscode-extensions
generate-vscode-extensions:
	@./scripts/generate-vscode-extensions

.PHONY: test
test: test-lua

.PHONY: test-lua
test-lua:
	@./scripts/nix-call.sh busted lua52Packages.busted \
		--verbose \
		--directory=./awesome \
		'--lpath="./?.lua;./?/?.lua;./?/init.lua"' \
		./

.PHONY: clean
clean:
	@rm -f result
	@rm -f result-*
