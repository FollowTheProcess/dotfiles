{ inputs, ... }:
let
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuOASBQpM3Ea8fX5chaztxYpbU4tqoN/pqwyjNdyWXo me@followtheprocess.codes";
in
{
  flake.darwinConfigurations.onyx = inputs.nix-darwin.lib.darwinSystem {
    modules = [ inputs.self.modules.darwin.onyx ];
  };

  flake.modules.darwin.onyx = {
    imports = [ inputs.self.modules.darwin.base ];

    networking = {
      computerName = "onyx";
      hostName = "onyx";
      localHostName = "onyx";
    };

    system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    home-manager.users.tomfleet.imports = with inputs.self.modules.homeManager; [
      onyx-home
    ];
  };

  flake.modules.homeManager.onyx-home = {
    imports = with inputs.self.modules.homeManager; [
      base
      macos
      onyx
    ];

    my.git = {
      email = "me@followtheprocess.codes";
      signingKey = sshKey;
      allowedSigners = [ sshKey ];
    };
  };
}
