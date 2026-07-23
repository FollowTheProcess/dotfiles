# https://nix.catppuccin.com
# This literally applies the theme across *everything* so cool!
{
  flake.modules.homeManager.base = {
    catppuccin = {
      enable = true;
      autoEnable = true;
      flavor = "macchiato";
      accent = "mauve";
    };
  };
}
