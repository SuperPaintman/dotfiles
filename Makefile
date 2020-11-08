IGNORE_PATHS := \
	'./zsh/.oh-my-zsh/**' \
	'./zsh/.oh-my-zsh-custom/**' \
	'./vim/.vim/bundle/**' \
	'./vim/.vim/plugged/**' \
	'./tmux/.tmux/plugins/**' \
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

BUSTED_FLAGS := \
	--verbose \
	--directory=./awesome \
	--lpath="./?.lua;./?/?.lua;./?/init.lua" \
	./

BUSTED :=
ifneq (, $(shell which busted > /dev/null 2>&1))
BUSTED := busted $(BUSTED_FLAGS)
else ifneq (, $(shell which nix-shell))
BUSTED := nix-shell '<nixpkgs>' -p pkgs.lua52Packages.busted --run 'busted $(BUSTED_FLAGS)'
endif

all:
	:

.PHONY: format
format: format-shell format-nix format-prettier

.PHONY: format-shell
format-shell:
	@shfmt -i 4 -ci -sr -s -w $(SHELL_FILES)

.PHONY: format-nix
format-nix:
	@nixpkgs-fmt $(NIX_FILES)

.PHONY: format-nix
format-prettier:
	@npx prettier --config ./prettier/.prettierrc.js --write $(PRETTIER_FILES)

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
ifndef BUSTED
	$(error '"busted" not found')
endif

	@$(BUSTED)
