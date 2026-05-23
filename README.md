# dotfiles

My dotfiles and setup scripts for macOS, managed with [GNU Stow]

![screenshot](./img/screenshot.png)

## Installation

On a fresh macOS install, run:

```bash
curl -fsSL https://raw.githubusercontent.com/FollowTheProcess/dotfiles/main/bootstrap.sh | bash
```

This installs Homebrew, clones the repo to `~/dotfiles`, applies the stow symlinks, installs everything in `.Brewfile`, then runs `macos.sh`. See [`bootstrap.sh`](./bootstrap.sh) for what each step does.

Each step is guarded, so it's safe to re-run after fixing a failure - already-completed steps will skip themselves.

## What's in the Box 📦

- The full suite of `XDG_xxx_HOME` env vars, set at the OS level with a `LaunchAgent` so even GUI apps can see them
- `PATH` set both for the shell and GUI apps
- A clean, modern [zsh] setup for the default macOS shell
- A similar setup for [nushell] (set up as the default shell instead of `zsh`)
- [aerospace] tiling window manager
- [sketchybar] integrated into aerospace with a clean bar setup
- Plus a tonne of config for the apps I use all the time


[GNU Stow]: https://www.gnu.org/software/stow/
[zsh]: https://www.zsh.org
[nushell]: https://www.nushell.sh
[aerospace]: https://github.com/nikitabobko/AeroSpace
[sketchybar]: https://github.com/FelixKratz/SketchyBar
