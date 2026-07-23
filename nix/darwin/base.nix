{ inputs, ... }:
{
  flake.modules.darwin.base = { config, ... }: {
    imports = [
      inputs.self.modules.generic.constants
      inputs.nix-homebrew.darwinModules.nix-homebrew
      inputs.home-manager.darwinModules.home-manager
    ];

    nix-homebrew = {
      enable = true;
      autoMigrate = true;
      user = config.my.constants.username;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      sharedModules = [
        inputs.paneru.homeModules.paneru
        inputs.catppuccin.homeModules.catppuccin
      ];
    };
  };
}
