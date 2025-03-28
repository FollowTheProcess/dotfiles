let catppuccin = {
  latte: {
    rosewater: "#dc8a78"
    flamingo: "#dd7878"
    pink: "#ea76cb"
    mauve: "#8839ef"
    red: "#d20f39"
    maroon: "#e64553"
    peach: "#fe640b"
    yellow: "#df8e1d"
    green: "#40a02b"
    teal: "#179299"
    sky: "#04a5e5"
    sapphire: "#209fb5"
    blue: "#1e66f5"
    lavender: "#7287fd"
    text: "#4c4f69"
    subtext1: "#5c5f77"
    subtext0: "#6c6f85"
    overlay2: "#7c7f93"
    overlay1: "#8c8fa1"
    overlay0: "#9ca0b0"
    surface2: "#acb0be"
    surface1: "#bcc0cc"
    surface0: "#ccd0da"
    crust: "#dce0e8"
    mantle: "#e6e9ef"
    base: "#eff1f5"
  }
  frappe: {
    rosewater: "#f2d5cf"
    flamingo: "#eebebe"
    pink: "#f4b8e4"
    mauve: "#ca9ee6"
    red: "#e78284"
    maroon: "#ea999c"
    peach: "#ef9f76"
    yellow: "#e5c890"
    green: "#a6d189"
    teal: "#81c8be"
    sky: "#99d1db"
    sapphire: "#85c1dc"
    blue: "#8caaee"
    lavender: "#babbf1"
    text: "#c6d0f5"
    subtext1: "#b5bfe2"
    subtext0: "#a5adce"
    overlay2: "#949cbb"
    overlay1: "#838ba7"
    overlay0: "#737994"
    surface2: "#626880"
    surface1: "#51576d"
    surface0: "#414559"
    base: "#303446"
    mantle: "#292c3c"
    crust: "#232634"
  }
  macchiato: {
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
  mocha: {
    rosewater: "#f5e0dc"
    flamingo: "#f2cdcd"
    pink: "#f5c2e7"
    mauve: "#cba6f7"
    red: "#f38ba8"
    maroon: "#eba0ac"
    peach: "#fab387"
    yellow: "#f9e2af"
    green: "#a6e3a1"
    teal: "#94e2d5"
    sky: "#89dceb"
    sapphire: "#74c7ec"
    blue: "#89b4fa"
    lavender: "#b4befe"
    text: "#cdd6f4"
    subtext1: "#bac2de"
    subtext0: "#a6adc8"
    overlay2: "#9399b2"
    overlay1: "#7f849c"
    overlay0: "#6c7086"
    surface2: "#585b70"
    surface1: "#45475a"
    surface0: "#313244"
    base: "#1e1e2e"
    mantle: "#181825"
    crust: "#11111b"
  }
}

let stheme = $catppuccin.macchiato
let theme = {
  separator: $stheme.overlay0
  leading_trailing_space_bg: $stheme.overlay0
  header: $stheme.green
  date: $stheme.mauve
  filesize: $stheme.blue
  row_index: $stheme.pink
  bool: $stheme.peach
  int: $stheme.peach
  duration: $stheme.peach
  range: $stheme.peach
  float: $stheme.peach
  string: $stheme.green
  nothing: $stheme.peach
  binary: $stheme.peach
  cellpath: $stheme.peach
  hints: dark_gray

  shape_garbage: $stheme.red
  shape_bool: $stheme.blue
  shape_int: { fg: $stheme.mauve attr: b}
  shape_float: { fg: $stheme.mauve attr: b}
  shape_range: { fg: $stheme.yellow attr: b}
  shape_internalcall: { fg: $stheme.blue attr: b}
  shape_external: { fg: $stheme.blue attr: b}
  shape_externalarg: $stheme.text 
  shape_literal: $stheme.blue
  shape_operator: $stheme.yellow
  shape_signature: { fg: $stheme.green attr: b}
  shape_string: $stheme.green
  shape_filepath: $stheme.yellow
  shape_globpattern: { fg: $stheme.blue attr: b}
  shape_variable: $stheme.text
  shape_flag: { fg: $stheme.blue attr: b}
  shape_custom: {attr: b}
}

$env.LS_COLORS = ($nu.default-config-dir | path join ls-colors | open | str trim)

$env.config = {
    show_banner: false # true or false to enable or disable the welcome banner at startup
    color_config: $theme # Use catppuccin mocha defined above

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

# DNS Config
$env.config.plugins.dns = {
  server: "1.1.1.1" # Use cloudflare
  protocol: https
  dns-name: cloudflare-dns.com
  dnssec-mode: strict
  tasks: 16
  timeout: 30sec
}


# Load starship init generated in env.nu
use ~/.cache/starship/init.nu

# Oh my posh
# source ~/.cache/omp/init.nu

# Same with zoxide
source ~/.zoxide.nu

# Launch GPG Agent
gpgconf --launch gpg-agent

# Aliases
alias build = pyproject-build --installer=uv # More convenient name for https://github.com/pypa/build, and faster
alias cat = bat --paging=never # Use https://github.com/sharkdp/bat instead of cat
alias find = gfind # Use GNU find
alias make = gmake # Use GNU make
alias sed = gsed # Use GNU sed
alias tree = eza --tree # Use https://github.com/eza-community/eza instead of tree
alias xargs = gxargs # Use GNU xargs
alias gsc = git switch --create # Make a new branch
alias gaa = git add --all # Stage all the things!
alias gs = git switch # Laziness at its peak
alias gpu = git push # Can't break the muscle memory now
alias tf = terraform # Lazy

# https://www.nushell.sh/book/configuration.html#macos-keeping-usr-bin-open-as-open
# alias nu-open = open
# alias open = ^open

# Source my custom commands/scripts
use commands.nu *
