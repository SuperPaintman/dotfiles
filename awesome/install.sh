#!/usr/bin/env bash

#
# This file is generated; DO NOT EDIT.
#

set -e

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
EXIT_CODE=0

source "$ROOT/../common.sh"

if is_linux; then
    link $@ "$ROOT/apps.lua" "$HOME/.config/awesome/apps.lua" || { EXIT_CODE="$?"; }
    link $@ "$ROOT/autostart.sh" "$HOME/.config/awesome/autostart.sh" || { EXIT_CODE="$?"; }
    link $@ "$ROOT/colors.lua" "$HOME/.config/awesome/colors.lua" || { EXIT_CODE="$?"; }
    link $@ "$ROOT/daemons" "$HOME/.config/awesome/daemons" || { EXIT_CODE="$?"; }
    link $@ "$ROOT/hosts" "$HOME/.config/awesome/hosts" || { EXIT_CODE="$?"; }
    link $@ "$ROOT/icons" "$HOME/.config/awesome/icons" || { EXIT_CODE="$?"; }
    link $@ "$ROOT/keys.lua" "$HOME/.config/awesome/keys.lua" || { EXIT_CODE="$?"; }
    link $@ "$ROOT/lib" "$HOME/.config/awesome/lib" || { EXIT_CODE="$?"; }
    link $@ "$ROOT/modules" "$HOME/.config/awesome/modules" || { EXIT_CODE="$?"; }
    link $@ "$ROOT/prelude.lua" "$HOME/.config/awesome/prelude.lua" || { EXIT_CODE="$?"; }
    link $@ "$ROOT/rc.lua" "$HOME/.config/awesome/rc.lua" || { EXIT_CODE="$?"; }
    link $@ "$ROOT/theme" "$HOME/.config/awesome/theme" || { EXIT_CODE="$?"; }
    link $@ "$ROOT/vendor" "$HOME/.config/awesome/vendor" || { EXIT_CODE="$?"; }
    link $@ "$ROOT/widgets" "$HOME/.config/awesome/widgets" || { EXIT_CODE="$?"; }
fi

exit "$EXIT_CODE"
