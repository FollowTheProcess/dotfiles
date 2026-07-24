{ inputs, ... }:
let
  # TODO: Fill in the real work public key and hostname
  sshKey = "PLACEHOLDER";
in
{
  flake.darwinConfigurations =
    let
      system = inputs.nix-darwin.lib.darwinSystem {
        modules = [ inputs.self.modules.darwin.work ];
      };
    in
    {
      work = system;
      # TODO: replace with `scutil --get LocalHostName` so bare `darwin-rebuild --flake .` resolves
      JAMF_HOSTNAME_PLACEHOLDER = system;
    };

  flake.modules.darwin.work = {
    imports = [ inputs.self.modules.darwin.base ];

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
