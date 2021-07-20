# See: https://git-scm.com/docs/githooks
GIT_HOOKS = applypatch-msg \
	pre-applypatch \
	post-applypatch \
	pre-commit \
	pre-merge-commit \
	prepare-commit-msg \
	commit-msg \
	post-commit \
	pre-rebase \
	post-checkout \
	post-merge \
	pre-push \
	pre-receive \
	update \
	proc-receive \
	post-receive \
	post-update \
	reference-transaction \
	push-to-checkout \
	pre-auto-gc \
	post-rewrite \
	sendemail-validate \
	fsmonitor-watchman \
	p4-changelist \
	p4-prepare-changelist \
	p4-post-changelist \
	p4-pre-submit \
	post-index-change

.PHONY: all
all: hooks

.PHONY: hooks
hooks: $(addprefix .git-global/hooks/,$(GIT_HOOKS))

define GIT_HOOK_TEMPLATE_TEXT
#!/usr/bin/env bash

HOOKS="$$(dirname "$$(realpath "$${BASH_SOURCE[0]}")")"

. "$$HOOKS/common/before.sh"

exit 0
endef

export GIT_HOOK_TEMPLATE=$(GIT_HOOK_TEMPLATE_TEXT)
.git-global/hooks/%:
	echo "$$GIT_HOOK_TEMPLATE" | sed 's/<name>/$*/' > $@
