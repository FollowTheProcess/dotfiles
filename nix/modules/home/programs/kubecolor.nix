{ pkgs, ... }:
let
  # to update: nurl https://github.com/vkhitrin/kubecolor-catppuccin
  catppuccin-kubecolor = pkgs.fetchFromGitHub {
    owner = "vkhitrin";
    repo = "kubecolor-catppuccin";
    rev = "1d4c2888f7de077e1a837a914a1824873d16762d";
    hash = "sha256-gTneUh6yMcH6dVKrH00G61a+apasu9tiMyYjvNdOiOw=";
  };
in
{
  programs.kubecolor = {
    enable = true;
    enableAlias = true; # kubectl -> kubecolor
    enableZshIntegration = true;
  };

  xdg.configFile."kubecolor.yaml".source = "${catppuccin-kubecolor}/catppuccin-macchiato.yaml";
}
