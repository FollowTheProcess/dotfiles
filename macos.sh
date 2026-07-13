#!/usr/bin/env bash

# macOS defaults
# Run from `~/dotfiles`. Inspect any setting with `defaults read <domain> <key>`.

__dock_item() {
    printf '%s%s%s%s%s' \
        '<dict><key>tile-data</key><dict><key>file-data</key><dict>' \
        '<key>_CFURLString</key><string>' \
        "$1" \
        '</string><key>_CFURLStringType</key><integer>0</integer>' \
        '</dict></dict></dict>'
}

# Close any open System Settings panes so they don't override the values we write
osascript -e 'tell application "System Settings" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# ***** Settings > General > Software Update *****
sudo softwareupdate --schedule ON
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool YES

# ***** Settings > General > About > Name *****
# ComputerName is the friendly label (spaces/apostrophes fine); HostName and
# LocalHostName must be hyphen-safe (no spaces, no dots for LocalHostName).
# scutil writes root-owned system config, so each set still needs sudo even
# though the timestamp is already warmed above.
computer_name="onyx"
sudo scutil --set ComputerName "${computer_name}"
sudo scutil --set HostName "${computer_name}"
sudo scutil --set LocalHostName "${computer_name}"

# ***** Settings > Appearance *****
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool false

# ***** Settings > General > Language & Region *****
defaults write NSGlobalDomain AppleLocale -string "en_GB"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true
defaults write NSGlobalDomain AppleTemperatureUnit -string "Celsius"
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

# ***** Menu Bar *****
# Hide the system menu bar; sketchybar replaces it
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# ***** Settings > Control Center *****
# Bluetooth: always show in menu bar (still relevant for sketchybar plugins reading state)
defaults -currentHost write com.apple.controlcenter Bluetooth -int 18

# Battery: show percentage
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

# ***** Settings > Keyboard *****
# Blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Disable press-and-hold accent picker so keys repeat in editors like Helix
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Full keyboard access: tab through every control in dialogs, not just text fields
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Expand Save and Print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable text auto-corrections; they get in the way when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ***** Sound *****
# Silence the boot chime. The byte 0x80 matches what System Settings >
# Sound > "Play sound on startup" writes, so the script and the UI stay
# in sync. Any non-default byte mutes; the specific value is cosmetic.
sudo nvram SystemAudioVolume=$'\x80'

# ***** Trackpad *****
# Tracking speed. NOTE: the key lives in NSGlobalDomain with a literal dot in
# its name (`com.apple.trackpad.scaling`); writing to `com.apple.trackpad`
# silently does nothing
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3.0

# ***** Windows *****
# Drag windows by holding ctrl+cmd and clicking anywhere on the window
defaults write NSGlobalDomain NSWindowShouldDragOnGesture -bool true

# ***** Dock *****
# Clear all dock items before rebuilding the list
defaults write com.apple.dock persistent-apps -array

# Add persistent apps to Dock. Safari ships in a sealed system Cryptex
# (/Applications/Safari.app is just a symlink to it). The Dock can't
# resolve the symlink and renders a `?` icon, so point at the real path.
defaults write com.apple.dock \
    persistent-apps -array \
    "$(__dock_item /System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app)" \
    "$(__dock_item /Applications/Slack.app)" \
    "$(__dock_item /Applications/WhatsApp.app)" \
    "$(__dock_item /System/Applications/Messages.app)" \
    "$(__dock_item /Applications/Spotify.app)" \
    "$(__dock_item /System/Applications/Mail.app)" \
    "$(__dock_item /System/Applications/Calendar.app)" \
    "$(__dock_item /System/Applications/Notes.app)" \
    "$(__dock_item /System/Applications/Reminders.app)" \
    "$(__dock_item /Applications/1Password.app)" \
    "$(__dock_item /Applications/Obsidian.app)" \
    "$(__dock_item /Applications/Things3.app)" \
    "$(__dock_item /Applications/Ghostty.app)" \
    "$(__dock_item /Applications/Zed.app)" \
    "$(__dock_item /System/Applications/"System Settings".app)"

# Minimize windows into their application's icon
defaults write com.apple.dock minimize-to-application -bool true

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Group windows by application in Mission Control
defaults write com.apple.dock expose-group-apps -bool true

# Don't auto-rearrange spaces by most recent use; AeroSpace assigns workspaces
# to fixed positions and this would shuffle them around
defaults write com.apple.dock mru-spaces -bool false

# Dock size and magnification
defaults write com.apple.dock tilesize -int 26
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 40

# Dock position
defaults write com.apple.dock orientation -string right

# ***** Mission Control *****
# Paneru needs this
defaults write com.apple.spaces spans-displays -bool false

# ***** Hot Corners *****
# Values: 1 = no action, 2 = Mission Control, 3 = Application Windows,
# 4 = Desktop, 5 = Start Screen Saver, 6 = Disable Screen Saver,
# 10 = Put Display to Sleep, 11 = Launchpad, 12 = Notification Center,
# 13 = Lock Screen, 14 = Quick Note. Modifier 0 = no key needed.
# Top-left
defaults write com.apple.dock wvous-tl-corner -int 1
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top-right
defaults write com.apple.dock wvous-tr-corner -int 1
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom-left
defaults write com.apple.dock wvous-bl-corner -int 1
defaults write com.apple.dock wvous-bl-modifier -int 0
# Bottom-right: Desktop
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

# ***** Stage Manager *****
# Explicitly disabled; AeroSpace handles tiling
defaults write com.apple.WindowManager GloballyEnabled -bool false

# ***** Finder *****
# Don't warn when removing from iCloud Drive
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false

# Default open location
defaults write com.apple.finder NewWindowTarget -string "PfDo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Documents/"

# Default view: column view
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Auto-empty Trash items older than 30 days
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

# Allow quitting Finder via ⌘+Q (also hides desktop icons)
defaults write com.apple.finder QuitMenuItem -bool true

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Sidebar icon size: 1 = small, 2 = medium, 3 = large
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Show path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Show full POSIX path in window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Search the current folder by default (not the whole Mac)
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Don't warn when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable the "downloaded from the internet" warning
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Stop writing .DS_Store on network shares and USB drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ***** Screenshots *****
# Keep screenshots on the clipboard rather than dumping to Desktop
defaults write com.apple.screencapture target -string "clipboard"

# PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# ***** Photos *****
# Don't auto-launch Photos when a camera or phone is connected
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# ***** Time Machine *****
# Stop the "use this disk for backups?" prompt for every new external drive
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# ***** TextEdit *****
# Default to plain text
defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# ***** Activity Monitor *****
# Show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort by CPU usage, descending
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# ***** Mail *****
# Show attachments as icons, never inline
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# ***** Mac App Store *****
# Don't autoplay app preview videos
defaults write com.apple.AppStore AutoPlayVideoSetting -string "off"

# Note: there's no working `defaults` key for in-app review prompts on
# modern macOS. Toggle System Settings > App Store > "In-App Ratings &
# Reviews" manually; the setting writes to a private daemon flag.

# ***** Safari *****
# Don't open "safe" downloads automatically
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Show full URL in the status bar overlay when hovering a link
defaults write com.apple.Safari ShowOverlayStatusBar -bool true

# Enable the Develop menu and Web Inspector
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Disable Safari's spelling auto-correct too
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

# Disable all forms of AutoFill (1Password handles this)
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# Restart affected apps so changes pick up
for app in \
    "Activity Monitor" \
    "Calendar" \
    "cfprefsd" \
    "Contacts" \
    "Dock" \
    "Finder" \
    "Mail" \
    "Messages" \
    "Photos" \
    "Safari" \
    "SystemUIServer"; do
    killall "${app}" &>/dev/null
done
# Show the user's ~/Library folder, which Apple hides by default
chflags nohidden ~/Library

echo "Done. Some changes require a logout or restart to take effect."
