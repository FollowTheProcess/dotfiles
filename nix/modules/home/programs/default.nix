{ ... }: {
  imports = [
    ./atuin.nix
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./carapace.nix
    ./eza.nix
    ./fzf.nix
    ./gh.nix
    ./gpg.nix
    ./ssh.nix
    ./starship.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  programs.home-manager.enable = true;
}
