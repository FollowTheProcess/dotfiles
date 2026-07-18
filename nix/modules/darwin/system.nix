{ pkgs, inputs, ... }:
let
  user = "tomfleet";
  home = "/Users/${user}";
in
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ inputs.fenix.overlays.default ];

  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 3;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;

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

  system.primaryUser = user;

  users.users."${user}" = {
    name = user;
    home = home;
  };
}
