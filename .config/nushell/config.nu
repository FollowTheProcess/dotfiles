let theme = {
  rosewater: "#f4dbd6"
  flamingo: "#f0c6c6"
  pink: "#f5bde6"
  mauve: "#c6a0f6"
  red: "#ed8796"
  maroon: "#ee99a0"
  peach: "#f5a97f"
  yellow: "#eed49f"
  green: "#a6da95"
  teal: "#8bd5ca"
  sky: "#91d7e3"
  sapphire: "#7dc4e4"
  blue: "#8aadf4"
  lavender: "#b7bdf8"
  text: "#cad3f5"
  subtext1: "#b8c0e0"
  subtext0: "#a5adcb"
  overlay2: "#939ab7"
  overlay1: "#8087a2"
  overlay0: "#6e738d"
  surface2: "#5b6078"
  surface1: "#494d64"
  surface0: "#363a4f"
  base: "#24273a"
  mantle: "#1e2030"
  crust: "#181926"
}

let scheme = {
  recognized_command: $theme.blue
  unrecognized_command: $theme.text
  constant: $theme.peach
  punctuation: $theme.overlay2
  operator: $theme.sky
  string: $theme.text
  virtual_text: $theme.surface2
  variable: { fg: $theme.flamingo attr: i }
  filepath: $theme.yellow
}

$env.config.color_config = {
  separator: { fg: $theme.surface2 attr: b }
  leading_trailing_space_bg: { fg: $theme.lavender attr: u }
  header: { fg: $theme.text attr: b }
  row_index: $scheme.virtual_text
  record: $theme.text
  list: $theme.text
  hints: $scheme.virtual_text
  search_result: { fg: $theme.base bg: $theme.yellow }
  shape_closure: $theme.teal
  closure: $theme.teal
  shape_flag: { fg: $theme.maroon attr: i }
  shape_matching_brackets: { attr: u }
  shape_garbage: $theme.red
  shape_keyword: $theme.mauve
  shape_match_pattern: $theme.green
  shape_signature: $theme.teal
  shape_table: $scheme.punctuation
  cell-path: $scheme.punctuation
  shape_list: $scheme.punctuation
  shape_record: $scheme.punctuation
  shape_vardecl: $scheme.variable
  shape_variable: $scheme.variable
  empty: { attr: n }
  filesize: {||
    if $in < 1kb {
      $theme.teal
    } else if $in < 10kb {
      $theme.green
    } else if $in < 100kb {
      $theme.yellow
    } else if $in < 10mb {
      $theme.peach
    } else if $in < 100mb {
      $theme.maroon
    } else if $in < 1gb {
      $theme.red
    } else {
      $theme.mauve
    }
  }
  duration: {||
    if $in < 1day {
      $theme.teal
    } else if $in < 1wk {
      $theme.green
    } else if $in < 4wk {
      $theme.yellow
    } else if $in < 12wk {
      $theme.peach
    } else if $in < 24wk {
      $theme.maroon
    } else if $in < 52wk {
      $theme.red
    } else {
      $theme.mauve
    }
  }
  date: {|| (date now) - $in |
    if $in < 1day {
      $theme.teal
    } else if $in < 1wk {
      $theme.green
    } else if $in < 4wk {
      $theme.yellow
    } else if $in < 12wk {
      $theme.peach
    } else if $in < 24wk {
      $theme.maroon
    } else if $in < 52wk {
      $theme.red
    } else {
      $theme.mauve
    }
  }
  shape_external: $scheme.unrecognized_command
  shape_internalcall: $scheme.recognized_command
  shape_external_resolved: $scheme.recognized_command
  shape_block: $scheme.recognized_command
  block: $scheme.recognized_command
  shape_custom: $theme.pink
  custom: $theme.pink
  background: $theme.base
  foreground: $theme.text
  cursor: { bg: $theme.rosewater fg: $theme.base }
  shape_range: $scheme.operator
  range: $scheme.operator
  shape_pipe: $scheme.operator
  shape_operator: $scheme.operator
  shape_redirection: $scheme.operator
  glob: $scheme.filepath
  shape_directory: $scheme.filepath
  shape_filepath: $scheme.filepath
  shape_glob_interpolation: $scheme.filepath
  shape_globpattern: $scheme.filepath
  shape_int: $scheme.constant
  int: $scheme.constant
  bool: $scheme.constant
  float: $scheme.constant
  nothing: $scheme.constant
  binary: $scheme.constant
  shape_nothing: $scheme.constant
  shape_bool: $scheme.constant
  shape_float: $scheme.constant
  shape_binary: $scheme.constant
  shape_datetime: $scheme.constant
  shape_literal: $scheme.constant
  string: $scheme.string
  shape_string: $scheme.string
  shape_string_interpolation: $theme.flamingo
  shape_raw_string: $scheme.string
  shape_externalarg: $scheme.string
}
$env.config.highlight_resolved_externals = true
$env.config.explore = {
    status_bar_background: { fg: $theme.text, bg: $theme.mantle },
    command_bar_text: { fg: $theme.text },
    highlight: { fg: $theme.base, bg: $theme.yellow },
    status: {
        error: $theme.red,
        warn: $theme.yellow,
        info: $theme.blue,
    },
    selected_cell: { bg: $theme.blue fg: $theme.base },
}

$env.LS_COLORS = ($nu.default-config-dir | path join ls-colors | open | str trim)

$env.config = {
    show_banner: false # true or false to enable or disable the welcome banner at startup

    ls: {
      use_ls_colors: true # use the LS_COLORS environment variable to colorize output
      clickable_links: true # enable or disable clickable links. Your terminal has to support links.
    }

    rm: {
      always_trash: true # always act as if -t was given. Can be overridden with -p
    }

    table: {
      mode: "light"
    }

    completions: {
      algorithm: "fuzzy"
    }

    history: {
      max_size: 100_000 # Session has to be reloaded for this to take effect
      sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
      file_format: "sqlite" # "sqlite" or "plaintext"
      isolation: false # only available with sqlite file_format. true enables history isolation, false disables it.
    }

    hooks: {
      # Direnv
      pre_prompt: [{ ||
      if (which direnv | is-empty) {
          return
      }

      direnv export json | from json | default {} | load-env
      }]
    }
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
  | prepend '/opt/homebrew/opt/ruby/bin' # Use the non system ruby
  | prepend ($env.HOME | path join .cargo bin) # Cargo install
  | prepend ($env.HOME | path join .local bin) # uv and a bunch of other tools
  | prepend ($env.HOME | path join .bun bin) # bun
  | prepend ($env.HOME | path join go bin) # GOBIN
  | prepend '/opt/homebrew/bin' # macOS ARM64 Homebrew
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
alias k = kubectl # Everyone seems to do this so...
alias ts = tree-sitter # Yep... more lazy

# https://www.nushell.sh/book/configuration.html#macos-keeping-usr-bin-open-as-open
# alias nu-open = open
# alias open = ^open

# Source my custom commands/scripts
use commands.nu *
