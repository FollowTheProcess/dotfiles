.PHONY: stow unstow restow

# Apply the dotfiles.
#
# We pass --no-folding so stow creates individual file symlinks instead of
# collapsing whole directories into a single symlink. Specifically,
# ~/Library/LaunchAgents/ must stay a real directory: macOS auto-bootstraps
# LaunchAgents from there at login, and on macOS 26 (Tahoe) at least, that
# auto-bootstrap is unreliable when the directory itself is a symlink.
stow:
	stow --no-folding .

unstow:
	stow -D .

restow:
	stow -R --no-folding .
