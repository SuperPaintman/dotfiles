#!/usr/bin/env bash

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../common.sh"

if ! is_osx; then
    exit
fi

################################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and etc.                   #
################################################################################
title2 "Trackpad, mouse, keyboard, Bluetooth accessories, and etc."

# Show F1-F12 keys in Touch Bar by default
defaults write com.apple.touchbar.agent PresentationModeGlobal -string functionKeys

# Show Control Strip in Touch Bar in the `fn` mode
defaults write com.apple.touchbar.agent PresentationModeFnModes -dict \
    functionKeys -string fullControlStrip

# Set up Control Strip icons
defaults write com.apple.controlstrip FullCustomized -array \
    -string "com.apple.system.group.brightness" \
    -string "com.apple.system.mission-control" \
    -string "com.apple.system.group.media" \
    -string "com.apple.system.sleep" \
    -string "com.apple.system.launchpad" \
    -string "com.apple.system.search" \
    -string "com.apple.system.group.keyboard-brightness" \
    -string "com.apple.system.group.volume"

################################################################################
# Dock                                                                         #
################################################################################
title2 "Dock"

# Show dots under tiles
defaults write com.apple.dock show-process-indicators -bool true

# Show only open applications in the Dock
defaults write com.apple.dock static-only -bool false

# Change size of tiles
defaults write com.apple.dock tilesize -int 48

################################################################################
# Reload affected applications                                                 #
################################################################################
title2 "Reload affected applications"

for app in "ControlStrip" "Dock"; do
    if killall "$app" 2>&1 > /dev/null; then
        ok "$(blue "$app") has reloaded"
    fi
done
