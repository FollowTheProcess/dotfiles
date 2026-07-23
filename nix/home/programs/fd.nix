{
  flake.modules.homeManager.base = _: {
    programs.fd = {
      enable = true;
    };
  };
}
