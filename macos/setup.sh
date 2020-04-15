#!/usr/bin/env bash

set -e

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../common.sh"

if ! is_osx; then
    exit
fi

PREFERENCES="$HOME/Library/Preferences"
FINDER_PREFERENCES="$PREFERENCES/com.apple.finder.plist"

################################################################################
title2 'Trackpad, mouse, keyboard, Bluetooth accessories, and etc.'
################################################################################

point 'Show F1-F12 keys in Touch Bar by default'
defaults write com.apple.touchbar.agent PresentationModeGlobal -string functionKeys

point 'Show Control Strip in Touch Bar in the `fn` mode'
defaults write com.apple.touchbar.agent PresentationModeFnModes -dict \
    functionKeys -string fullControlStrip

point 'Set up Control Strip icons'
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
title2 'Dock'
################################################################################

point 'Show dots under tiles'
defaults write com.apple.dock show-process-indicators -bool true

point 'Show only open applications in the Dock'
defaults write com.apple.dock static-only -bool false

point 'Change size of tiles'
defaults write com.apple.dock tilesize -int 48

################################################################################
title2 'Finder'
################################################################################

point 'Show hidden files by default'
defaults write com.apple.finder AppleShowAllFiles -bool true

point 'Show all filename extensions'
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

point 'Show side bar'
defaults write com.apple.finder ShowSidebar -boolean true

point 'Show path bar'
defaults write com.apple.finder ShowPathbar -boolean true

point 'Show status bar'
defaults write com.apple.finder ShowStatusBar -bool false

point 'Show preview pane'
defaults write com.apple.finder ShowPreviewPane -bool false

point 'Enable snap-to-grid for icons on the desktop and in other icon views'
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" "$FINDER_PREFERENCES"
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" "$FINDER_PREFERENCES"
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" "$FINDER_PREFERENCES"

################################################################################
title2 'Safari'
################################################################################

point 'Enable "Develop" menu and "Web Inspector"'
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptEnabled -bool true

################################################################################
title2 'Reload affected applications'
################################################################################

for app in "ControlStrip" "Dock" "Finder"; do
    if killall "$app" > /dev/null 2>&1; then
        ok "$(blue "$app") has reloaded"
    fi
done
