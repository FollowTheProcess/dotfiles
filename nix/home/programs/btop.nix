{
  flake.modules.homeManager.base = _: {
    programs.btop = {
      enable = true;
      settings = {
        theme_background = false;
      };
    };
  };
}
