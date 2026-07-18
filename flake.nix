{
  description = "My macOS system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    paneru = {
      url = "github:karinushka/paneru";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zsh-patina = {
      url = "github:michel-kraemer/zsh-patina";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      home-manager,
      paneru,
      ...
    }:
    let
      treefmtEval = inputs.treefmt-nix.lib.evalModule nixpkgs.legacyPackages.aarch64-darwin {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
      };

      mkDarwin =
        { host, settings }:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit
              self
              inputs
              host
              settings
              ;
          };
          modules = [
            ./nix/hosts/${host}/default.nix
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                user = settings.username;
                autoMigrate = true;
              };
            }
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit inputs settings;
                  dotfiles = ./.;
                };
                users.${settings.username} = import ./nix/hosts/${host}/home.nix;
                sharedModules = [
                  paneru.homeModules.paneru
                  ./nix/modules/home/options.nix
                ];
              };
            }
          ];
        };
    in
    {
      formatter.aarch64-darwin = treefmtEval.config.build.wrapper;
      checks.aarch64-darwin.treefmt = treefmtEval.config.build.check self;

      # Personal Laptop
      darwinConfigurations."onyx" = mkDarwin {
        host = "onyx";
        settings.username = "tomfleet";
      };

      # Work
      # TODO: Fill in the real host name in place of "work"
      darwinConfigurations."work" = mkDarwin {
        host = "work";
        settings.username = "tomfleet";
      };
    };
}
