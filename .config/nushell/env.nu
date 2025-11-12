# Custom env vars
$env.PIP_REQUIRE_VIRTUALENV = true
$env.EDITOR = 'code --wait'
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

# Go Experiments
$env.GOEXPERIMENT = "greenteagc,jsonv2"

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
