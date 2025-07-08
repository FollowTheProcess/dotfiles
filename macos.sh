#!/usr/bin/env zsh

# Settings for mac

__dock_item() {
    printf '%s%s%s%s%s' \
        '<dict><key>tile-data</key><dict><key>file-data</key><dict>' \
        '<key>_CFURLString</key><string>' \
        "$1" \
        '</string><key>_CFURLStringType</key><integer>0</integer>' \
        '</dict></dict></dict>'
}

# Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# ***** Settings > General > Software Update *****
sudo softwareupdate --schedule ON
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool YES

# ***** Settings > Appearance *****
defaults write .GlobalPreferences AppleInterfaceStyle -string "Dark"
defaults write .GlobalPreferences AppleInterfaceStyleSwitchesAutomatically -bool false

# ***** Settings > Control Center *****
# Bluetooth: always show in menu bar
defaults -currentHost write com.apple.controlcenter Bluetooth -int 18

# Battery - show percentage
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Clear all dock items
defaults write com.apple.dock persistent-apps -array

# Add persistent apps to Dock
defaults write com.apple.dock \
    persistent-apps -array \
    "$(__dock_item /Applications/Arc.app)" \
    "$(__dock_item /System/Applications/Safari.app)" \
    "$(__dock_item /Applications/Slack.app)" \
    "$(__dock_item /Applications/Whatsapp.app)" \
    "$(__dock_item /System/Applications/Messages.app)" \
    "$(__dock_item /Applications/Spotify.app)" \
    "$(__dock_item /System/Applications/Mail.app)" \
    "$(__dock_item /System/Applications/Calendar.app)" \
    "$(__dock_item /System/Applications/Notes.app)" \
    "$(__dock_item /System/Applications/Reminders.app)" \
    "$(__dock_item /Applications/1Password.app)" \
    "$(__dock_item /Applications/Bear.app)" \
    "$(__dock_item /Applications/Things3.app)" \
    "$(__dock_item /Applications/Ghostty.app)" \
    "$(__dock_item /Applications/"Visual Studio Code".app)" \
    "$(__dock_item /Applications/Zed.app)" \
    "$(__dock_item /System/Applications/"System Settings".app)"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# System Preferences > Dock > Size:
defaults write com.apple.dock tilesize -int 26

# System Preferences > Dock > Magnification:
defaults write com.apple.dock magnification -bool true

# System Preferences > Dock > Size (magnified):
defaults write com.apple.dock largesize -int 40

# System Preferences > Dock > Position:
defaults write com.apple.dock orientation -string right

# Finder > Preferences > Show warning before removing from iCloud Drive
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false

# System Preferences > Trackpad > Tracking speed
defaults write com.apple.trackpad scaling -float 3.0

# Finder > Preferences > Default open location
defaults write com.apple.finder NewWindowTarget -string "PfDo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Documents/"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Disable the annoying "this app was downloaded from the internet" warning
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Drag windows by holding ctrl + cmd and clicking anywhere on the window, rather than
# just the window pane
defaults write -g NSWindowShouldDragOnGesture -bool true

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

# Disable AutoFill
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

for app in "Activity Monitor" \
    "Address Book" \
    "Calendar" \
    "cfprefsd" \
    "Contacts" \
    "Dock" \
    "Finder" \
    "Google Chrome Canary" \
    "Google Chrome" \
    "Mail" \
    "Messages" \
    "Opera" \
    "Photos" \
    "Safari" \
    "SizeUp" \
    "Spectacle" \
    "SystemUIServer" \
    "Terminal" \
    "Transmission" \
    "Tweetbot" \
    "Twitter" \
    "iCal"; do
    killall "${app}" &>/dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
