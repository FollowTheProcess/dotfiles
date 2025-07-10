# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
    ($nu.data-dir | path join 'completions') # default home for nushell completions
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
    ($nu.current-exe | path dirname)
]

# Custom env vars
$env.PIP_REQUIRE_VIRTUALENV = true
$env.EDITOR = 'zed --wait'
$env.GOPATH = $env.HOME | path join go
$env.GOBIN = $env.HOME | path join go bin
$env.CGO_ENABLED = 0
$env.GO111MODULE = 'on'
$env.PYTHONUTF8 = 1
$env.FZF_DEFAULT_COMMAND = 'fd --type f --strip-cwd-prefix'
$env.FZF_CTRL_T_COMMAND = 'fd --type f --strip-cwd-prefix'
$env.GPG_TTY = (tty | str trim)
$env.VIRTUALENV_PROMPT = '.venv'
$env.CARGO_HOME = $env.HOME | path join .cargo

# Add things to $PATH
$env.PATH = (
  $env.PATH
  | split row (char esep)
  | prepend '/opt/homebrew/bin' # macOS ARM64 Homebrew
  | prepend ($env.HOME | path join .cargo bin) # Cargo install
  | prepend ($env.HOME | path join .local bin) # uv and a bunch of other tools
  | prepend ($env.HOME | path join go bin) # GOBIN
  | prepend ($env.HOME | path join .bun bin) # bun
  | uniq # filter so the paths are unique
)

# Starship
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

# Carapace
mkdir ~/.cache/carapace
# Carapace v1.3.2 / nushell v0.105 compat patch. Waiting for new carapace release
# See carapace-sh/carapace-bin#2830
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

# zoxide
zoxide init --cmd cd nushell | save --force ~/.zoxide.nu

# atuin
mkdir ~/.cache/atuin
atuin init nu | save --force ~/.cache/atuin/init.nu
