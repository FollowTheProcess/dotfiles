use ~/.config/nushell/catppuccin-macchiatto.nu palette

$env.LS_COLORS = ($env.XDG_CONFIG_HOME | path join ls-colors catppuccin-macchiato | open | str trim)
$env.config.show_banner = false
$env.config.ls = {
    use_ls_colors: true
    clickable_links: true
}
$env.config.rm.always_trash = true
$env.config.table.mode = "light"
$env.config.completions.algorithm = "fuzzy"

# Enable external completers explicitly.
$env.config.completions.external.enable = true

# Open the current command line in $env.config.buffer_editor with Ctrl+O.
$env.config.buffer_editor = "zed --wait"

# Catppuccin-styled completion menu (the default menus list is empty, so this
# replaces nu's internal fallback with one that matches the rest of the theme).
$env.config.menus = [
    {
        name: completion_menu
        only_buffer_difference: false
        marker: "| "
        type: {
            layout: columnar
            columns: 4
            col_width: 20
            col_padding: 2
        }
        style: {
            text: $palette.text
            selected_text: { fg: $palette.text bg: $palette.surface0 attr: b }
            description_text: $palette.subtext0
            match_text: { fg: $palette.red attr: u }
            selected_match_text: { fg: $palette.red bg: $palette.surface0 attr: u }
        }
    }
]
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

# Note: we can't use $env.XDG_CACHE_HOME here as it's a "runtime" value
# and source/use needs "parse time" values. $nu.cache_dir respects
# XDG_CACHE_HOME anyway so it's fine.
const xdg_cache = ($nu.cache-dir | path dirname)

use ($xdg_cache | path join starship init.nu)
source ($xdg_cache | path join carapace init.nu)
source ($xdg_cache | path join zoxide init.nu)
source ($xdg_cache | path join atuin init.nu)

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
alias tar = gtar # Use GNU tar
alias gsc = git switch --create # Make a new branch
alias gaa = git add --all # Stage all the things!
alias gs = git switch
alias gpu = git push
alias gl = git log --oneline
alias tf = terraform
alias tg = terragrunt
alias k = kubectl # Everyone seems to do this so...
alias ts = tree-sitter

# https://www.nushell.sh/book/configuration.html#macos-keeping-usr-bin-open-as-open
# alias nu-open = open
# alias open = ^open

# Source my custom commands/scripts
use commands.nu *
