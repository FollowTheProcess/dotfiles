{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    let
      tomlFormat = pkgs.formats.toml { };
    in
    {
      # No home-manager module for zsh-patina, so just the config here
      # https://github.com/michel-kraemer/zsh-patina#configuration
      xdg.configFile."zsh-patina/config.toml".source = tomlFormat.generate "zsh-patina-config.toml" {
        highlighting.theme = "catppuccin-macchiato";
      };
    };
}
