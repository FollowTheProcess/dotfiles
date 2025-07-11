# Custom commands as a nu module

# Prints an info message to the user, will be coloured with ansi cyan.
def info [
    msg: string # The message to print
] {
    print $"(ansi cyan)\n($msg)\n(ansi reset)"
}

# Prints a warning message tot he user, will be coloured with ansi yellow.
def warn [
    msg: string # The message to print
] {
    pprint $"⚠️ (ansi yellow)Warning:(ansi reset) ($msg)\n"
}

# Prints a success message to the user, will be coloured green.
def success [
    msg: string # The message to print
    --newline # Add a newline before the message
] {
    if $newline {
        print $"\n✅ (ansi green)Success:(ansi reset) ($msg)\n"
    } else {
        print $"✅ (ansi green)Success:(ansi reset) ($msg)\n"
    }
}

# Update, clean and maintain everything
export def maintenance [] {
    # Homebrew
    info "🍺 Updating and cleaning homebrew packages"
    brew update
    brew upgrade
    brew cleanup --scrub

    # VSCode
    info "🧑🏻‍💻 Updating VSCode Extensions"
    code --update-extensions

    # uv
    info "🛠  Updating uv installed CLI programs"
    uv tool upgrade --all

    # Rust
    info "🦀 Updating rust"
    rustup self update
    rustup update
    cargo install-update --all

    # Go
    info "🐰 Updating go tools"
    gup update

    # Bun
    info " Updating bun"
    bun upgrade

    # Zig
    # info "🦎 Updating zig"
    # install-zig

    # tldr
    info "📓 Updating tldr"
    tldr --update

    success "All done!" --newline
}

# nushell support for https://github.com/common-fate/granted

# assume - https://granted.dev
export def --env --wrapped assume [...args: string] {
  const var_names = [
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
    "AWS_SESSION_TOKEN",
    "AWS_PROFILE",
    "AWS_REGION",
    "AWS_SESSION_EXPIRATION",
    "GRANTED_SSO",
    "GRANTED_SSO_START_URL",
    "GRANTED_SSO_ROLE_NAME",
    "GRANTED_SSO_REGION",
    "GRANTED_SSO_ACCOUNT_ID"
  ]

  # Run assumego and collect its output
  let output = with-env {GRANTED_ALIAS_CONFIGURED: "true"} {
    assumego ...$args
  }

  let granted_output = $output | lines
  let granted_status = $env.LAST_EXIT_CODE

  # First line is the command
  let command = $granted_output | get -i 0 | default "" | str trim | split row " "

  let flag = $command | get 0
  # Collect environment variables to set
  let envvars = do {
    let values = $command | skip 1
    let vars = $var_names |
      zip $values |
      where {|x| $x.1 != "None"} |
      reduce --fold {} {|it, acc| $acc | insert $it.0 $it.1}
    $vars
  }
  match $flag {
    "GrantedOutput" => {
      # The rest of the output (if any)
      let to_display = $granted_output | skip 1
      $to_display | str join "\n" | print
    },
    "GrantedAssume" => {
      for v in $var_names {
        hide-env -i $v
      }
      load-env $envvars
    },
    "GrantedDesume" => {
      for v in $var_names {
        hide-env -i $v
      }
    },
    "GrantedExec" => {
      let num_vars = ($var_names | length)
      let cmd = $command | range ($num_vars + 1).. | str join " "
      with-env $envvars { nu -c $"($cmd)"}
    }
    _ => {
      # most likely no output, so nothing to do
    }
  }

  if $granted_status != 0 {
    error make -u {msg: $"command failed with code ($granted_status)"}
  }
}

# Clean up merged local git branches
export def prune [] {
    git branch
    | lines
    | where ($it != "* master" and $it != "* main")
    | each { |br| print $"Removing branch ($br)"; git branch --delete --force ($br | str trim) }
    | str trim
}

# Generate gitignore files
export def gig [...targets: string@targets] {
    http get $"https://www.toptal.com/developers/gitignore/api/($targets | str join ',')"
}

# Generate completion targets for gig
def targets [] {
    http get https://www.toptal.com/developers/gitignore/api/list?format=lines | lines
}

# Download the latest release of zig and put it on $PATH
def install-zig [] {
    let index = http get https://ziglang.org/download/index.json
    let latest_version = $index | $in.master.version
    let current_version = zig version | str trim

    if $current_version == $latest_version {
        print $"Zig version ($current_version) is up to date with latest ($latest_version)"
        return
    }

    let download_url = $index | $in.master.aarch64-macos.tarball
    let local_tarball = $download_url | url parse | get path | path basename

    let tmp = mktemp --directory
    cd $tmp

    http get $download_url | save --force $local_tarball

    tar -xvf $local_tarball out+err>| ignore

    let expanded = $local_tarball | path basename | str replace '.tar.xz' ''
    let zig_bin = $expanded | path join zig
    let zig_lib = $expanded | path join lib

    chmod +x $zig_bin
    mkdir ~/zig
    cp $zig_bin ~/zig/
    cp -r $zig_lib ~/zig/

    cd -

    install-zls
}

# Download the latest release of zls and put it on $PATH
def install-zls [] {
    let initial = pwd
    let tmp = mktemp --directory
    cd $tmp
    git clone https://github.com/zigtools/zls
    cd zls
    zig build -Doptimize=ReleaseSafe

    cp ./zig-out/bin/zls ~/zig

    cd $initial
}
