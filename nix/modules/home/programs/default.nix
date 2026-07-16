{ ... }: {
  imports = [
    ./atuin.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./ssh.nix
    ./starship.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  programs.home-manager.enable = true;
}
