{ inputs, ... }:
{
  flake.modules.homeManager.work = {
    programs.kubecolor = {
      enable = true;
      enableAlias = true; # kubectl -> kubecolor
      enableZshIntegration = true;
    };

    xdg.configFile."kubecolor.yaml".source = "${inputs.catppuccin-kubecolor}/catppuccin-macchiato.yaml";
  };
}
