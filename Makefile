.PHONY: stow unstow restow dump build drop-compdump

# Apply the dotfiles.
#
# --no-folding means stow creates individual links, one per file instead
# of linking whole directories. Fixes a bunch of issues I had like apps
# writing into ~/.config/<app> and those writes showing up in here, and
# some flakiness with LaunchAgents
stow: build drop-compdump
	stow --no-folding .

unstow:
	stow -D .

restow: build drop-compdump
	stow -R --no-folding .

# Drop the zsh completion dump so the next shell start rescans fpath. The
# .zshrc uses `compinit -C` when the dump is fresh, which skips picking up
# any newly-stowed completion functions until the cache is 24h old.
drop-compdump:
	rm -f "$${XDG_CACHE_HOME:-$$HOME/.cache}/zsh/zcompdump"

# Compile the swift helpers (getting bluetooth info) so they run quicker
build: .config/sketchybar/helpers/bt_battery

.config/sketchybar/helpers/bt_battery: .config/sketchybar/helpers/bt_battery.swift
	swiftc -O -o $@ $<

# Refresh ~/.Brewfile from the currently-installed state.
#
# `brew bundle dump` strips per-entry options (restart_service, start_service,
# etc.) so we re-apply them after the dump. The sed patterns anchor to
# end-of-line, so they only match the bare lines `dump` produces and leave
# anything already annotated alone (idempotent).
dump:
	brew bundle dump --force --global
	sed -i '' \
		-e 's|^brew "felixkratz/formulae/borders"$$|brew "felixkratz/formulae/borders",  restart_service: :changed, start_service: true|' \
		-e 's|^brew "felixkratz/formulae/sketchybar"$$|brew "felixkratz/formulae/sketchybar",  restart_service: :changed, start_service: true|' \
		.Brewfile
