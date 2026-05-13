.PHONY: stow unstow restow dump

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

# Refresh ~/.Brewfile from the currently-installed state.
#
# `brew bundle dump` strips per-entry options (restart_service, start_service,
# etc.) so we re-apply them after the dump. The sed patterns anchor to
# end-of-line, so they only match the bare lines `dump` produces and leave
# anything already annotated alone (idempotent).
dump:
	brew bundle dump --force --global --all
	sed -i '' \
		-e 's|^brew "felixkratz/formulae/borders"$$|brew "felixkratz/formulae/borders",  restart_service: :changed, start_service: true|' \
		-e 's|^brew "felixkratz/formulae/sketchybar"$$|brew "felixkratz/formulae/sketchybar",  restart_service: :changed, start_service: true|' \
		.Brewfile
