{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    interval = {
      Day = 7;
    };
    options = "--delete-older-than 30d";
  };

  environment.systemPackages = [
    pkgs.vim
    pkgs.git
    pkgs.curl
  ];

  fonts.packages = [
    pkgs.geist-font
    pkgs.nerd-fonts.geist-mono
    pkgs.inter
    pkgs.sketchybar-app-font
  ];

  launchd.user.envVariables =
    let
      home = "/Users/tomfleet";
    in
    {
      PATH = pkgs.lib.concatStringsSep ":" [
        "/run/current-system/sw/bin"
        "/etc/profiles/per-user/tomfleet/bin"
        "${home}/.nix-profile/bin"
        "/nix/var/nix/profiles/default/bin"
        "${home}/go/bin"
        "${home}/.bun/bin"
        "${home}/.local/bin"
        "${home}/.cargo/bin"
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
        "/opt/homebrew/opt/curl/bin"
        "/opt/homebrew/opt/ruby/bin"
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

  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = false;
  programs.zsh.interactiveShellInit = ''
    typeset -U path PATH
    path=(
      /run/current-system/sw/bin
      /etc/profiles/per-user/$USER/bin
      $HOME/.nix-profile/bin
      /nix/var/nix/profiles/default/bin
      $path
    )
  '';

  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local.touchIdAuth = true;

  system.primaryUser = "tomfleet";

  users.users.tomfleet = {
    name = "tomfleet";
    home = "/Users/tomfleet";
  };
}
