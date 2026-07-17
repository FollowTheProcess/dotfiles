{ ... }: {
  imports = [
    ./atuin.nix
    ./bat.nix
    ./btop.nix
    ./carapace.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./gh.nix
    ./go.nix
    ./gpg.nix
    ./granted.nix
    ./k9s.nix
    ./mergiraf.nix
    ./mise.nix
    ./ripgrep.nix
    ./ruff.nix
    ./ssh.nix
    ./starship.nix
    ./television.nix
    ./ty.nix
    ./uv.nix
    ./zoxide.nix
    ./zsh.nix
    ./fd.nix
  ];

  # Let home-manager manage itself, not worth it's own file
  programs.home-manager.enable = true;
}
