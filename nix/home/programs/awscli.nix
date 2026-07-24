{
  flake.modules.homeManager.base = {
    programs.awscli = {
      enable = true;
    };
  };
}
