{
  flake.modules.homeManager.base = {
    programs.nix-search-tv = {
      enable = true;
      # Channel defined manually as `nix` in television.nix
      enableTelevisionIntegration = false;
    };
  };
}
