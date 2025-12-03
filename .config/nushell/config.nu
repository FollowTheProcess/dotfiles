source ~/.config/nushell/catppuccin-macchiatto.nu

$env.LS_COLORS = ($nu.default-config-dir | path join ls-colors | open | str trim)
$env.config.show_banner = false
$env.config.ls = {
    use_ls_colors: true
    clickable_links: true
}
$env.config.rm.always_trash = true
$env.config.table.mode = "light"
$env.config.completions.algorithm = "fuzzy"
$env.config.history = {
    max_size: 100_000 # Session has to be reloaded for this to take effect
    sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
    file_format: "sqlite" # "sqlite" or "plaintext"
    isolation: false # only available with sqlite file_format. true enables history isolation, false disables it.
}
$env.config.hooks = {
    # Direnv
    pre_prompt: [{ ||
    if (which direnv | is-empty) {
        return
    }

    direnv export json | from json | default {} | load-env
    }]
}

$env.ENV_CONVERSIONS = $env.ENV_CONVERSIONS | merge {
  "__zoxide_hooked": {
    from_string: { |v| $v | into bool }
    to_string: { |v| $v | into string }
  }
}

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

# DNS Config
$env.config.plugins.dns = {
  server: "1.1.1.1" # Use cloudflare
}

# Load starship init generated in env.nu
use ~/.cache/starship/init.nu

# Carapace
source ~/.cache/carapace/init.nu

# Same with zoxide
source ~/.zoxide.nu

# And atuin
source ~/.cache/atuin/init.nu

# Launch GPG Agent
gpgconf --launch gpg-agent

# Aliases
alias build = pyproject-build --installer=uv # More convenient name for https://github.com/pypa/build, and faster
alias cat = bat --paging=never # Use https://github.com/sharkdp/bat instead of cat
alias find = gfind # Use GNU find
alias make = gmake # Use GNU make
alias sed = gsed # Use GNU sed
alias tree = eza --tree --icons=auto # Use https://github.com/eza-community/eza instead of tree
alias xargs = gxargs # Use GNU xargs
alias gsc = git switch --create # Make a new branch
alias gaa = git add --all # Stage all the things!
alias gs = git switch # Laziness at its peak
alias gpu = git push # Can't break the muscle memory now
alias tf = terraform # Lazy
alias tg = terragrunt # Also lazy
alias k = kubectl # Everyone seems to do this so...

# https://www.nushell.sh/book/configuration.html#macos-keeping-usr-bin-open-as-open
# alias nu-open = open
# alias open = ^open

# Source my custom commands/scripts
use commands.nu *
