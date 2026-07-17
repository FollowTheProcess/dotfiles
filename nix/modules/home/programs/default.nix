{ ... }: {
  imports = [
    ./atuin.nix
    ./bat.nix
    ./btop.nix
    ./carapace.nix
    ./difftastic.nix
    ./direnv.nix
    ./eza.nix
    ./fd.nix
    ./fzf.nix
    ./gh.nix
    ./ghostty.nix
    ./git.nix
    ./go.nix
    ./gpg.nix
    ./granted.nix
    ./jq.nix
    ./jujutsu.nix
    ./k9s.nix
    ./kubecolor.nix
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
  ];

  # Let home-manager manage itself, not worth it's own file
  programs.home-manager.enable = true;
}
