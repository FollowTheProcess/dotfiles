# Custom env vars
# TODO(@FollowTheProcess): See if we can use https://www.nushell.sh/commands/docs/load-env.html
$env.PIP_REQUIRE_VIRTUALENV = true
$env.EDITOR = 'code --wait'
$env.GOPATH = $env.HOME | path join go
$env.GOBIN = $env.HOME | path join go bin
$env.CGO_ENABLED = 0
$env.GO111MODULE = 'on'
$env.PYTHONUTF8 = 1
$env.FZF_DEFAULT_COMMAND = 'fd --type f --strip-cwd-prefix'
$env.FZF_CTRL_T_COMMAND = 'fd --type f --strip-cwd-prefix'


# Add things to $PATH
$env.PATH = (
  $env.PATH
  | split row (char esep)
  | prepend '/opt/homebrew/bin' # macOS ARM64 Homebrew
  | prepend ($env.HOME | path join .cargo bin) # Cargo install
  | prepend ($env.HOME | path join .local bin) # uv and a bunch of other tools
  | prepend ($env.HOME | path join go bin) # GOBIN
  | uniq # filter so the paths are unique
)


mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
