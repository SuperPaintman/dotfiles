VENV := .venv
QMK := $(VENV)/bin/qmk
QMK_VERSION := 0.0.39
# QMK_FIRMWARE_VERSION := 8ab6efdc804fe7c7666b4c9f7962e288b39448d2
# QMK_FIRMWARE_SHA256 := 0777318998abfa1432dc05fb156366d759e9ae3a35d411f3838fa33a7d0ce13c
# QMK_FIRMWARE := .qmk_firmware-$(QMK_FIRMWARE_VERSION)
QMK_FIRMWARE := .qmk_firmware
# QMK_CONFIG_FILE := .qmk.ini-$(QMK_FIRMWARE_VERSION)
QMK_CONFIG_FILE := .qmk.ini
NIXOS_ENV_SH := env.sh

define SETUP_ENV
. ./$(NIXOS_ENV_SH)
PATH=$(shell pwd)/$(VENV)/bin:$$PATH
endef

all: .vscode/c_cpp_properties.json compile_commands.json qmk qmk_config_file qmk_firmware

# Firmware.
.PHONY: moonlander
moonlander: moonlander_superpaintman.bin
	wally moonlander_superpaintman.bin

moonlander_superpaintman.bin: $(QMK_FIRMWARE) $(QMK_FIRMWARE)/keyboards/moonlander/keymaps/superpaintman
	$(SETUP_ENV)

	$(MAKE) hello

	$(QMK) --config-file $(QMK_CONFIG_FILE) compile -kb moonlander -km superpaintman
	cp $(QMK_FIRMWARE)/moonlander_superpaintman.bin moonlander_superpaintman.bin

# NixOS ENV.
.PHONY: nixos_env
nixos_env: $(NIXOS_ENV_SH)

$(NIXOS_ENV_SH): env.nix
	nix-build -E 'with import <nixpkgs> { }; callPackage ./env.nix { }' -o $(NIXOS_ENV_SH)

# Config.
.PHONY: qmk_config_file
qmk_config_file: $(QMK_CONFIG_FILE)

.ONESHELL:
$(QMK_CONFIG_FILE):
	cat <<EOF > $(QMK_CONFIG_FILE)
	[user]
	qmk_home = $(shell pwd)/$(QMK_FIRMWARE)
	EOF

# Repository.
.PHONY: qmk_firmware
qmk_firmware: $(QMK_FIRMWARE)

$(QMK_FIRMWARE): $(QMK) $(QMK_CONFIG_FILE)
	$(SETUP_ENV)
	$(QMK) --config-file $(QMK_CONFIG_FILE) setup --yes

# $(QMK_FIRMWARE): $(QMK_FIRMWARE).zip
# 	rm -rf '/tmp/$(QMK_FIRMWARE)'
# 	unzip -o -qq $(QMK_FIRMWARE).zip -d '/tmp/$(QMK_FIRMWARE)'
# 	mv '/tmp/$(QMK_FIRMWARE)/qmk_firmware-$(QMK_FIRMWARE_VERSION)' $(QMK_FIRMWARE)

# $(QMK_FIRMWARE).zip:
# 	rm -rf '/tmp/$(QMK_FIRMWARE).zip'
# 	curl -L 'https://github.com/qmk/qmk_firmware/archive/$(QMK_FIRMWARE_VERSION).zip' -o '/tmp/$(QMK_FIRMWARE).zip'
# 	echo '$(QMK_FIRMWARE_SHA256) /tmp/$(QMK_FIRMWARE).zip' | sha256sum --check
# 	mv '/tmp/$(QMK_FIRMWARE).zip' '$(QMK_FIRMWARE).zip'

# Keyboard configs.
$(QMK_FIRMWARE)/keyboards/moonlander/keymaps/superpaintman: keyboards/moonlander/keymaps/superpaintman/*
	rm -rf $(QMK_FIRMWARE)/keyboards/moonlander/keymaps/superpaintman
	mkdir -p $(QMK_FIRMWARE)/keyboards/moonlander/keymaps/superpaintman
	cp $^ $(QMK_FIRMWARE)/keyboards/moonlander/keymaps/superpaintman/

# Hello.
.PHONY: hello
hello: $(QMK) $(QMK_FIRMWARE)
	$(SETUP_ENV)
	$(QMK_FIRMWARE)/bin/qmk hello

# Dependencies.
.PHONY: qmk
qmk: $(QMK)

$(VENV):
	python3 -m venv $(VENV)

$(QMK): $(VENV)
	$(VENV)/bin/python3 -m pip install qmk==$(QMK_VERSION) appdirs argcomplete colorama hjson milc pygments

# Autocomplete.
.PHONY: compile_commands.json
.ONESHELL:
compile_commands.json:
	PWD="$(shell pwd)"
	CLANG="$$(which clang)"

	CFLAGS=()
	CFLAGS+=("-std=gnu99")
	CFLAGS+=("-I$$(nix eval --raw nixpkgs.arduino.outPath)/share/arduino/hardware/tools/avr/avr/include")
	CFLAGS+=("-I$$(nix eval --raw nixpkgs.arduino.outPath)/share/arduino/hardware/tools/avr/lib/gcc/avr/7.3.0/include")
	CFLAGS+=("-I./.qmk_firmware/keyboards/moonlander")
	CFLAGS+=("-I./.qmk_firmware/keyboards/moonlander/keymaps/default")
	CFLAGS+=("-I./.qmk_firmware/users/default")
	CFLAGS+=("-I./.qmk_firmware/tmk_core")
	CFLAGS+=("-I./.qmk_firmware/tmk_core/common")
	CFLAGS+=("-I./.qmk_firmware/tmk_core/protocol")
	CFLAGS+=("-I./.qmk_firmware/quantum")
	CFLAGS+=("-I./.qmk_firmware/quantum/keymap_extras")
	CFLAGS+=("-I./.qmk_firmware/quantum/audio")
	CFLAGS+=("-I./.qmk_firmware/quantum/process_keycode")
	CFLAGS+=("-I./.qmk_firmware/quantum/api")
	CFLAGS+=("-I./.qmk_firmware/quantum/sequencer")
	CFLAGS+=("-I./.qmk_firmware/drivers")
	CFLAGS+=("-I./.qmk_firmware/lib/printf")
	CFLAGS+=("-I./keyboards/moonlander/keymaps/superpaintman")
	CFLAGS+=("-include ./.qmk_firmware/keyboards/moonlander/config.h")
	CFLAGS+=("-include ./.qmk_firmware/keyboards/moonlander/keymaps/default/config.h")
	CFLAGS+=("-DQMK_KEYBOARD_H=\\\\\\\"moonlander.h\\\\\\\"")

	cat <<EOF | jq . > compile_commands.json
	[
		{
			"directory": "$$PWD",
			"command": "$$CLANG $${CFLAGS[@]} -c -o keyboards/moonlander/keymaps/superpaintman/keymap.o keyboards/moonlander/keymaps/superpaintman/keymap.c",
			"file": "keyboards/moonlander/keymaps/superpaintman/keymap.c"
		}
	]
	EOF

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

# Clean.
.PHONY: clean
clean: clean-venv clean-nixos-env clean-bin clean-qmk_config_file clean-qmk_firmware

.PHONY: clean-venv
clean-venv:
	rm -rf $(VENV)

.PHONY: clean-nixos-env
clean-nixos-env:
	rm -rf $(NIXOS_ENV_SH)

.PHONY: clean-bin
clean-bin:
	rm -rf *.bin

.PHONY: clean-qmk_config_file
clean-qmk_config_file:
	rm -f $(QMK_CONFIG_FILE)
	rm -f $(QMK_CONFIG_FILE)-*

.PHONY: clean-qmk_firmware
clean-qmk_firmware:
	rm -rf $(QMK_FIRMWARE)
	rm -rf $(QMK_FIRMWARE)-*
	rm -f $(QMK_FIRMWARE)-*.zip

	rm -f compile_commands.json
	rm -f .vscode/c_cpp_properties.json
