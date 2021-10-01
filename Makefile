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
	'**/node_modules/**' \
	'**/.venv/**' \
	'./qmk/.qmk_firmware/**'
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
		find ./bin/bin ./rofi/modes ./scripts ./git/.git-global/hooks \
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
DEFAULT_NIX_FILES := $(shell find . \
	-mindepth 2 -maxdepth 2 \
	-type f -name 'default.nix' \
	-and -not -path './nixos/default.nix' \
	-and -not -path './secrets/**/*.nix' \
	$(addprefix -and -not -path , $(IGNORE_PATHS)) \
)

all: init .vscode/c_cpp_properties.json compile_commands.json

init:
  # git config core.hooksPath .githooks

.PHONY: nixos
nixos: nixos-channels nixos-upgrade

.PHONY: nixos-upgrade
nixos-upgrade: nixos-update nixos-switch

.PHONY: nixos-upgrade-unstable
nixos-upgrade-unstable: nixos-update-unstable nixos-switch

.PHONY: nixos-update
nixos-update: nixos-channels
	sudo nix-channel --update

.PHONY: nixos-update-unstable
nixos-update-unstable: nixos-channels
	sudo nix-channel --update nixos-unstable

.PHONY: nixos-switch
nixos-switch:
	sudo nixos-rebuild switch

.PHONY: nixos-build
nixos-build:
	nixos-rebuild build

.PHONY: $(addprefix nixos-build-pkgs-, $(NIX_LOCAL_PACKAGES))
$(addprefix nixos-build-pkgs-, $(NIX_LOCAL_PACKAGES)): nixos-build-pkgs-%:
	nix-build \
		-E 'with import <nixpkgs> {}; callPackage ./nixos/pkgs/default.nix {}' \
		-A $* \
		--out-link "result-$*"

.PHONY: $(addprefix nixos-shell-pkgs-, $(NIX_LOCAL_PACKAGES))
$(addprefix nixos-shell-pkgs-, $(NIX_LOCAL_PACKAGES)): nixos-shell-pkgs-%:
	nix-shell \
		-E 'with import <nixpkgs> {}; callPackage ./nixos/pkgs/default.nix {}' \
		-A $*

.PHONY: nixos-dry-build
nixos-dry-build:
	nixos-rebuild dry-build

.PHONY: nixos-gc
nixos-gc:
	sudo nix-collect-garbage -d

# Add NixOS channels.
# See: https://nixos.org/nixos/manual/index.html#sec-upgrading .
.PHONY: nixos-channels
nixos-channels:
	sudo nix-channel --add "https://nixos.org/channels/nixos-$(NIXOS_VERSION)" nixos
	sudo nix-channel --add "https://nixos.org/channels/nixos-unstable" nixos-unstable
	sudo nix-channel --list

.PHONY: nixos-uninstall-users-packages
nixos-uninstall-users-packages:
	nix-env --uninstall $(shell nix-env -q | grep -v 'home-manager-path')

.PHONY: qmk-moonlander
qmk-moonlander:
	$(MAKE) -C qmk moonlander

.PHONY: format
format: format-shell format-nix format-prettier

.PHONY: format-shell
format-shell:
	./scripts/nix-call.sh shfmt shfmt -i 4 -ci -sr -s -w $(SHELL_FILES)

.PHONY: format-nix
format-nix:
	./scripts/nix-call.sh nixpkgs-fmt nixpkgs-fmt $(NIX_FILES)

.PHONY: format-nix
format-prettier:
	npx prettier --config ./prettier/.prettierrc.js --write $(PRETTIER_FILES)

.PHONY: format-lua
format-lua:
	./scripts/lua-format.sh --config=./.lua-format -i $(LUA_FILES)

.PHONY: generate
generate: generate-configs generate-vscode-extensions

.PHONY: generate-configs
generate-configs:
	./scripts/generate-configs

.PHONY: generate-vscode-extensions
generate-vscode-extensions:
	./scripts/generate-vscode-extensions

.PHONY: generate-install-sh
generate-install-sh:
	$(foreach name,$(DEFAULT_NIX_FILES:./%/default.nix=%),./scripts/generate-install-sh $(name) ; )

.PHONY: test
test: test-lua test-nix

.PHONY: test-lua
test-lua:
	./scripts/nix-call.sh busted lua52Packages.busted \
		--verbose \
		--directory=./awesome \
		'--lpath="./?.lua;./?/?.lua;./?/init.lua"' \
		./

.PHONY: test-nix
test-nix:
	./nixos/test/run.sh

# Autocomplete.
qmk/compile_commands.json:
	$(MAKE) -C qmk compile_commands.json

compile_commands.json: qmk/compile_commands.json
	jq -s '. | flatten' $^ > compile_commands.json

.vscode:
	mkdir -p .vscode

.ONESHELL:
.vscode/c_cpp_properties.json: .vscode
	PWD="$(shell pwd)"

	cat <<EOF | jq . > .vscode/c_cpp_properties.json
	{
		"configurations": [
			{
				"name": "Auto-generated",
				"compileCommands": "$$PWD/compile_commands.json"
			}
		],
		"version": 4
	}
	EOF

# Secrets.
secrets:
	git clone https://github.com/SuperPaintman/dotfiles-secrets ~/Projects/github.com/SuperPaintman/dotfiles-secrets
	ln -s ~/Projects/github.com/SuperPaintman/dotfiles-secrets ./secrets

.PHONY: clean-nixos-builds
clean-nixos-builds:
	rm -f result
	rm -f result-*

.PHONY: clean
clean: clean-nixos-builds
	rm -f compile_commands.json
	rm -f .vscode/c_cpp_properties.json

	$(MAKE) -C qmk clean
