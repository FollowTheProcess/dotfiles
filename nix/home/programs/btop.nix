{
  flake.modules.homeManager.base = {
    programs.btop = {
      enable = true;
      settings = {
        theme_background = false;
      };
    };
  };
}
