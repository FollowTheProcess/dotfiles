{ inputs, ... }:
{
  flake.modules.darwin.base =
    { pkgs, config, ... }:
    let
      user = config.my.constants.username;
      home = "/Users/${user}";
    in
    {
      nixpkgs = {
        config.allowUnfree = true;
        overlays = [ inputs.fenix.overlays.default ];
        hostPlatform = "aarch64-darwin";
      };

      nix = {
        gc = {
          automatic = true;
          interval = {
            Weekday = 0;
            Hour = 3;
            Minute = 0;
          };
          options = "--delete-older-than 30d";
        };

        registry.nixpkgs.flake = inputs.nixpkgs;
        nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

        optimise.automatic = true;
        settings.experimental-features = "nix-command flakes";

        # A manually created permissionless GitHub access token,
        # here purely to avoid rate limits. I could nixify this
        # with sops-nix or something but for one token that's not
        # always needed so is probably not worth it
        #
        # The token needs to be readable by both me and root:
        #
        # sudo install -m 600 -o tomfleet -g staff /dev/null /etc/nix/access-tokens.conf
        # tee /etc/nix/access-tokens.conf <<'EOF'
        # access-tokens = github.com=XXXX
        # EOF
        extraOptions = ''
          !include /etc/nix/access-tokens.conf
        '';
      };

      environment.systemPackages = [
        pkgs.vim
        pkgs.git
        pkgs.curl
      ];

      environment.pathsToLink = [ "/share/zsh" ];

      fonts.packages = [
        pkgs.geist-font
        pkgs.nerd-fonts.geist-mono
        pkgs.inter
      ];

      launchd.user.envVariables = {
        PATH = pkgs.lib.concatStringsSep ":" [
          "/run/current-system/sw/bin"
          "/etc/profiles/per-user/${user}/bin"
          "${home}/.nix-profile/bin"
          "/nix/var/nix/profiles/default/bin"
          "${home}/go/bin"
          "${home}/.bun/bin"
          "${home}/.local/bin"
          "${home}/.cargo/bin"
          "/opt/homebrew/bin"
          "/opt/homebrew/sbin"
          "/usr/local/bin"
          "/usr/bin"
          "/bin"
          "/usr/sbin"
          "/sbin"
        ];

        XDG_CONFIG_HOME = "${home}/.config";
        XDG_CACHE_HOME = "${home}/.cache";
        XDG_DATA_HOME = "${home}/.local/share";
        XDG_STATE_HOME = "${home}/.local/state";
      };

      # System zsh, different to home-manager/user zsh in programs/zsh
      programs.zsh = {
        enable = true;
        enableCompletion = false;
        interactiveShellInit = ''
          typeset -U path PATH
          if [[ -z "$IN_NIX_SHELL" ]]; then
            path=(
              /run/current-system/sw/bin
              /etc/profiles/per-user/${user}/bin
              ${home}/.nix-profile/bin
              /nix/var/nix/profiles/default/bin
              $path
            )
          fi
        '';
      };

      system.stateVersion = 6;

      security.pam.services.sudo_local.touchIdAuth = true;

      system.primaryUser = user;

      users.users."${user}" = {
        name = user;
        inherit home;
      };
    };
}
