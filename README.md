# dotfiles

My personal system setup for macOS, powered by [nix], [nix-darwin] and [home-manager] ❄️

## Installation

On a fresh mac:

1. Install [nix] using the [Community Installer]:

```bash
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
```

2. Get this repo:

```bash
git clone https://github.com/FollowTheProcess/dotfiles.git ~/dotfiles
```

3. Let nix do it's thing:

```bash
nix run nix-darwin -- switch --flake ~/dotfiles#onyx
```

> [!NOTE]
> The setup is entirely self-contained, but can sometimes run into GitHub rate limits (fresh builds after a `nix flake update` for example). In which
> case, a simple, permission-less GitHub Personal Access Token should be provisioned in `/etc/nix/access-tokens.conf`:
> `access-tokens = github.com=TOKEN_HERE`. It doesn't break anything if it's not present, just gets around rate limits if they happen

[nix]: https://nixos.org
[nix-darwin]: https://github.com/nix-darwin/nix-darwin#readme
[home-manager]: https://nix-community.github.io/home-manager/
[Community Installer]: https://github.com/NixOS/nix-installer
