{ inputs, ... }:
{
  flake.modules.homeManager.base = {
    imports = [ inputs.self.modules.generic.constants ];
    home.stateVersion = "26.11";
  };
}
