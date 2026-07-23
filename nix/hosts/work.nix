{ inputs, ... }:
let
  # TODO: Fill in the real work public key and hostname
  sshKey = "PLACEHOLDER";
in
{
  flake.darwinConfigurations.work = inputs.nix-darwin.lib.darwinSystem {
    modules = [ inputs.self.modules.darwin.work ];
  };

  flake.modules.darwin.work = {
    imports = [ inputs.self.modules.darwin.base ];

    networking = {
      computerName = "work";
      hostName = "work";
      localHostName = "work";
    };

    system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    home-manager.users.tomfleet.imports = with inputs.self.modules.homeManager; [
      work-home
    ];
  };

  flake.modules.homeManager.work-home = {
    imports = with inputs.self.modules.homeManager; [
      base
      macos
      work
    ];

    my.git = {
      email = "tfleet@newstore.com";
      signingKey = sshKey;
      allowedSigners = [ sshKey ];
    };

    my.go.private = [ "gitlab.com/newstore/*" ];
  };
}
