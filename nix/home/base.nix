{ inputs, ... }:
{
  flake.modules.homeManager.base = {
    imports = [ inputs.self.modules.generic.constants ];
    home.stateVersion = "26.11";

    # Let home manager install and manage itself
    programs.home-manager.enable = true;
  };
}
