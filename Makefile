SHELL_FILES := \
	$(shell \
		find . \
			\( -type f -name '*.sh' -or -name '*.bash' -or -name '*.zsh' \) \
			-and -not -path './zsh/.oh-my-zsh/**' \
			-and -not -path './zsh/.oh-my-zsh-custom/**' \
			-and -not -path './vim/.vim/bundle/**' \
			-and -not -path './vim/.vim/plugged/**' \
			-and -not -path './tmux/.tmux/plugins/**' \
			-and -not -path '**/node_modules/**' \
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
NIX_FILES := $(shell find -type f -name '*.nix')

all:
	:

format: format-shell format-nix

format-shell:
	@shfmt -i 4 -ci -sr -s -w $(SHELL_FILES)

format-nix:
	@nixpkgs-fmt $(NIX_FILES)

generate: generate-configs

generate-configs:
	@./scripts/generate-configs
