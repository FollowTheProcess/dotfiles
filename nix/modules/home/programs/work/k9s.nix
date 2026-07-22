{ inputs, ... }:
{
  programs.k9s = {
    enable = true;
    settings = {
      ui = {
        logoless = true;
        skin = "catppuccin-macchiato-transparent";
      };
    };
    skins = {
      catppuccin-macchiato-transparent = "${inputs.catppuccin-k9s}/dist/catppuccin-macchiato-transparent.yaml";
    };
    aliases = {
      dp = "deployments";
      sec = "v1/secrets";
      jo = "jobs";
      cr = "clusterroles";
      crb = "clusterrolebindings";
      ro = "roles";
      rb = "rolebindings";
      np = "networkpolicies";
    };
  };
}
