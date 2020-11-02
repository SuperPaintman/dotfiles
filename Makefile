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
