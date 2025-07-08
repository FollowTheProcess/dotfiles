# dotfiles

My dotfiles and setup scripts, managed with [GNU Stow]

## Installation

Make sure you have [GNU Stow] installed...

```shell
brew install stow
```

Now clone this repo to `~/.dotfiles`, `cd` into it then run:

```shell
stow .
```

Part of this will move `.Brewfile` into `$HOME` which is very handy because once it's done that:

```shell
brew bundle install --global
```

Will install *everything* in there 🚀

See <https://docs.brew.sh/Brew-Bundle-and-Brewfile#brew-bundle-dump> for more info

### Follow up Steps

Once that's done, most configuration and packages will be installed and set up correctly. There are a few follow ups included in a script `setup.sh` that does some nicities:

- Install [rustup]
- Use [gup] to install everything in `.config/gup.conf` to `$GOBIN`
- Make a `~/Development` folder to house your projects
- Adds [nushell] to `/etc/shells`
- Run's a bunch of `defaults write` commands to configure MacOS itself

[GNU Stow]: https://www.gnu.org/software/stow/
[rustup]: https://rustup.rs
[gup]: https://github.com/nao1215/gup
[nushell]: https://www.nushell.sh
