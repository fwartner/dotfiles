#!/usr/bin/env bash
# macos/defaults.sh - Curated macOS defaults for a developer workstation.
#
# Idempotent: every `defaults write` is declarative, safe to re-run.
# Restarts Dock, Finder, and SystemUIServer at the end so changes take effect
# without a logout.
#
# Inspired by https://github.com/mathiasbynens/dotfiles/blob/main/.macos —
# trimmed to a sensible default set, not a full mirror of the source machine.

set -euo pipefail

echo "→ Applying macOS defaults..."

# Close any open System Settings panes so they don't override the writes
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true

# Ask for the admin password upfront and keep-alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &

###############################################################################
# General                                                                     #
###############################################################################
echo "  ▸ General"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

###############################################################################
# Keyboard                                                                    #
###############################################################################
echo "  ▸ Keyboard"

# Fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable press-and-hold for accents (re-enables key repeat in apps like VS Code)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Disable autocorrect & smart quotes/dashes (developers don't want these)
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

###############################################################################
# Trackpad / Mouse                                                            #
###############################################################################
echo "  ▸ Trackpad"

# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###############################################################################
# Finder                                                                      #
###############################################################################
echo "  ▸ Finder"

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show the ~/Library folder
chflags nohidden ~/Library 2>/dev/null || true

###############################################################################
# Dock                                                                        #
###############################################################################
echo "  ▸ Dock"

# Auto-hide
defaults write com.apple.dock autohide -bool true

# Faster auto-hide animation
defaults write com.apple.dock autohide-time-modifier -float 0.4
defaults write com.apple.dock autohide-delay -float 0

# Smaller icons (default 64)
defaults write com.apple.dock tilesize -int 44

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Don't animate opening applications
defaults write com.apple.dock launchanim -bool false

# Minimize windows into their application's icon
defaults write com.apple.dock minimize-to-application -bool true

###############################################################################
# Screenshots                                                                 #
###############################################################################
echo "  ▸ Screenshots"

# Save to ~/Screenshots (create if missing)
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"

# PNG format
defaults write com.apple.screencapture type -string "png"

# Disable shadow on window screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Don't include date in filename (use simple counter)
# defaults write com.apple.screencapture include-date -bool false

###############################################################################
# Screensaver / Lock                                                          #
###############################################################################
echo "  ▸ Screensaver"

# Require password immediately after sleep or screen saver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

###############################################################################
# Safari (basics — for the rare time you open it)                             #
###############################################################################
echo "  ▸ Safari"

# Show full URL in address bar
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true 2>/dev/null || true

# Enable the Develop menu and Web Inspector
defaults write com.apple.Safari IncludeDevelopMenu -bool true 2>/dev/null || true

###############################################################################
# Activity Monitor                                                            #
###############################################################################
echo "  ▸ Activity Monitor"

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort by CPU usage descending
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Restart affected services                                                   #
###############################################################################
echo "→ Restarting Dock, Finder, SystemUIServer, cfprefsd..."
for app in "Activity Monitor" "Dock" "Finder" "SystemUIServer" "cfprefsd"; do
  killall "$app" >/dev/null 2>&1 || true
done

echo ""
echo "✓ macOS defaults applied."
echo "  Some changes may require logout/login or a reboot to fully take effect."
