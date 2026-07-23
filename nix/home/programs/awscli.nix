{
  flake.modules.homeManager.base = _: {
    programs.awscli = {
      enable = true;
    };
  };
}
