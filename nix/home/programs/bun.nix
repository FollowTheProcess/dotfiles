{
  flake.modules.homeManager.base = {
    programs.bun = {
      enable = true;
      settings = {
        telemetry = false;
        test = {
          coverage = true;
          randomize = true;
        };
        install = {
          minimumReleaseAge = 259200; # 3 days
          exact = true;
        };
      };
    };
  };
}
