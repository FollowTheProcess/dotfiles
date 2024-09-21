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

# Load starship init generated in env.nu
use ~/.cache/starship/init.nu

# Same with zoxide
source ~/.zoxide.nu

# Launch GPG Agent
gpgconf --launch gpg-agent

# Aliases
alias build = pyproject-build --installer=uv # More convenient name for https://github.com/pypa/build, and faster
alias cat = bat --paging=never # Use https://github.com/sharkdp/bat instead of cat
alias du = dust # Use https://github.com/bootandy/dust instead of du
alias find = gfind # Use GNU find
alias gaa = git add --all
alias gb = git branch -vv
alias make = gmake # Use GNU make
alias sed = gsed # Use GNU sed
alias tree = eza --tree # Use https://github.com/eza-community/eza instead of tree
alias xargs = gxargs # Use GNU xargs

# Source my custom commands/scripts
use commands.nu *
