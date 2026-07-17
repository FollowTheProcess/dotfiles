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
    ./go.nix
    ./gpg.nix
    ./granted.nix
    ./k9s.nix
    ./ssh.nix
    ./starship.nix
    ./zoxide.nix
    ./zsh.nix
    ./mergiraf.nix
    ./mise.nix
    ./ripgrep.nix
    ./ruff.nix
  ];

  # Let home-manager manage itself, not worth it's own file
  programs.home-manager.enable = true;
}
