{ ... }: {
  imports = [
    ./atuin.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./starship.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  programs.home-manager.enable = true;
}
