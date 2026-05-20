# Custom env vars
$env.PIP_REQUIRE_VIRTUALENV = true
$env.EDITOR = 'zed --wait'
$env.GOPATH = $env.HOME | path join go
$env.GOBIN = $env.HOME | path join go bin
$env.CGO_ENABLED = 0
$env.GO111MODULE = 'on'
$env.PYTHONUTF8 = 1
# Use bat as the pager for man. MANROFFOPT="-c" fixes bold/underline
# rendering on macOS where mandoc otherwise strips the formatting.
$env.MANPAGER = "sh -c 'col -bx | bat -l man -p'"
$env.MANROFFOPT = "-c"

# fzf: layout + catppuccin macchiato palette.
# https://github.com/catppuccin/fzf
$env.FZF_DEFAULT_OPTS = "--height=40% --layout=reverse --border=rounded --info=inline --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 --color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 --color=selected-bg:#494d64 --color=border:#363a4f,label:#cad3f5"

# Use fd for fzf's file/dir walks - faster, respects .gitignore.
$env.FZF_DEFAULT_COMMAND = 'fd --type=f --hidden --follow --exclude .git'
$env.FZF_CTRL_T_COMMAND = $env.FZF_DEFAULT_COMMAND
$env.FZF_ALT_C_COMMAND = 'fd --type=d --hidden --follow --exclude .git'

# Previews: bat for files (with syntax highlight), eza tree for dirs.
$env.FZF_CTRL_T_OPTS = "--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
$env.FZF_ALT_C_OPTS = "--preview 'eza --tree --color=always --icons=auto {} | head -200'"

# Some tools start a login shell without an attached TTY. `tty` exits 1 there.
$env.GPG_TTY = (try { tty | str trim } catch { "" })
$env.VIRTUALENV_PROMPT = '.venv'
$env.CARGO_HOME = $env.HOME | path join .cargo
$env.XDG_CONFIG_HOME = $env.HOME | path join .config
$env.XDG_CACHE_HOME = $env.HOME | path join .cache
$env.XDG_DATA_HOME = $env.HOME | path join .local share
$env.XDG_STATE_HOME = $env.HOME | path join .local state
$env.KUBECTL_EXTERNAL_DIFF = "difft --exit-code"

# Go Experiments
$env.GOEXPERIMENT = "jsonv2"

# Add things to $PATH
$env.PATH = (
  $env.PATH
  | prepend '/opt/homebrew/opt/ruby/bin' # Use the non system ruby
  | prepend '/opt/homebrew/opt/curl/bin' # Use non system curl
  | prepend ($env.HOME | path join .cargo bin) # Cargo install
  | prepend ($env.HOME | path join .local bin) # uv and a bunch of other tools
  | prepend ($env.HOME | path join .bun bin) # bun
  | prepend ($env.HOME | path join go bin) # GOBIN
  | prepend '/opt/homebrew/sbin' # Some formulas put executables here
  | prepend '/opt/homebrew/bin' # most homebrew tools go here
  | uniq # filter so the paths are unique
)

# Starship
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

# Carapace
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

# zoxide
zoxide init --cmd cd nushell | save --force ~/.zoxide.nu

# atuin
mkdir ~/.cache/atuin
atuin init nu | save --force ~/.cache/atuin/init.nu
