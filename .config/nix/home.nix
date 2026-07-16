# Home Manager config
# https://nix-community.github.io/home-manager/options/home-manager/index.html

{ config, pkgs, ...}:

{
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.11";

  # User packages, config typically in dotfiles
  home.packages = [
    # pkgs.freeze # This is charmbracelet
    # pkgs.gup # A go thing not on here
    pkgs.actionlint
    pkgs.awscli2
    pkgs.bash
    pkgs.bat
    pkgs.btop
    pkgs.carapace
    pkgs.cargo-nextest
    pkgs.cmake
    pkgs.container
    pkgs.cook-cli
    pkgs.cosign
    pkgs.curl
    pkgs.defuddle
    pkgs.delve
    pkgs.difftastic
    pkgs.docker-language-server
    pkgs.doggo
    pkgs.dust
    pkgs.entr
    pkgs.eza
    pkgs.fastfetch
    pkgs.fd
    pkgs.findutils
    pkgs.gcc
    pkgs.gh
    pkgs.git
    pkgs.glow
    pkgs.gnupg
    pkgs.gnused
    pkgs.gnutar
    pkgs.go
    pkgs.gofumpt
    pkgs.golangci-lint
    pkgs.golangci-lint-langserver
    pkgs.gomodifytags
    pkgs.granted
    pkgs.gum
    pkgs.hadolint
    pkgs.hugo
    pkgs.hyperfine
    pkgs.jankyborders
    pkgs.jj
    pkgs.jq
    pkgs.just
    pkgs.mdbook
    pkgs.mergiraf
    pkgs.mise
    pkgs.nil
    pkgs.nixd
    pkgs.pinentry_mac
    pkgs.pkgsite
    pkgs.procs
    pkgs.ripgrep
    pkgs.ruff
    pkgs.shellcheck
    pkgs.stow
    pkgs.syft
    pkgs.television
    pkgs.terraform
    pkgs.terraform-docs
    pkgs.terraform-ls
    pkgs.tflint
    pkgs.tlrc
    pkgs.tokei
    pkgs.tombi
    pkgs.trivy
    pkgs.typos
    pkgs.usage
    pkgs.uv
    pkgs.vhs
    pkgs.yamlfmt
    pkgs.yq
    pkgs.zig
    pkgs.zls
    pkgs.zsh
    pkgs.zsh-fzf-tab
    pkgs.zsh-abbr
    pkgs.zsh-autosuggestions
    pkgs.zsh-completions
    pkgs.zsh-defer
    pkgs.zsh-fast-syntax-highlighting
  ];

  xdg.enable = true;

  # Dotfile configs linked from this repo
  # Note: atuin, direnv, starship managed via programs.* for shell integration
  xdg.configFile = {
    "aerospace".source = ../aerospace;
    "ai".source = ../ai;
    "atuin".source = ../atuin;
    "bat".source = ../bat;
    "btop".source = ../btop;
    "copier".source = ../copier;
    "direnv".source = ../direnv;
    "gh".source = ../gh;
    "ghostty".source = ../ghostty;
    "git".source = ../git;
    "glow".source = ../glow;
    "jj".source = ../jj;
    "k9s".source = ../k9s;
    "ls-colors".source = ../ls-colors;
    "nushell".source = ../nushell;
    "paneru".source = ../paneru;
    "ruff".source = ../ruff;
    "sketchybar".source = ../sketchybar;
    "television".source = ../television;
    "tombi".source = ../tombi;
    "uv".source = ../uv;
    "starship.toml".source = ../starship.toml;
    "yamlfmt".source = ../yamlfmt;
    "zed".source = ../zed;
  };

  xdg.dataFile."zsh/fzf-tab.zsh".source = "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh";

  # Programs with config and/or shell integrations to set up
  programs = {
    # Let home-manager manage itself
    home-manager.enable = true;
    atuin.enable = true;
    direnv.enable = true;
    starship.enable = true;
    eza = {
      enable = true;
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--cmd" "cd"];
    };
    fzf = {
      enable = true;
      # Atuin handles history
      historyWidget.command = "";
    };
    # TODO: Move this to it's own module
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      fastSyntaxHighlighting.enable = true;
    };
  };

  services.paneru.enable = true;

  launchd.agents.jankyborders = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.jankyborders}/bin/borders"
        "style=round"
        "width=3.0"
        "hidpi=on"
        "active_color=0xffc6a0f6"
      ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}
