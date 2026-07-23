{
  flake.modules.homeManager.base = _: {
    programs.ty = {
      enable = true;
    };
  };
}
