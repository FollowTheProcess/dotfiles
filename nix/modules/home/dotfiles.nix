{
  dotfiles,
  config,
  lib,
  ...
}:
{
  xdg.enable = true;
  home = {
    preferXdgDirectories = true;
    activation.createDev = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ${config.home.homeDirectory}/Development
    '';
  };

  xdg.configFile = {
    "zed".source = dotfiles + "/.config/zed";
  };

}
