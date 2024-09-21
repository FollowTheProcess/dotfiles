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
