{ inputs, ... }:
let
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF4lQztcBMPRZQ2t7Oa8Cg/u2yYbeBkc0IkUB2CzUURy tfleet@newstore.com";
in
{
  flake.darwinConfigurations =
    let
      system = inputs.nix-darwin.lib.darwinSystem {
        modules = [ inputs.self.modules.darwin.work ];
      };
    in
    {
      # Point the literal "work" at this config, but also the
      # silly random host name
      work = system;
      J631G9XYWT = system;
    };

  flake.modules.darwin.work = {
    imports = [ inputs.self.modules.darwin.base ];

    system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    # Endpoint protection intercepts TLS with a MITM CA to scan for
    # supply chain vulnerabilities. This setting covers nix fetches
    nix.settings = {
      experimental-features = [ "configurable-impure-env" ];
      impure-env = [ "NIX_SSL_CERT_FILE=/etc/nix/aikido-bundle.crt" ];
    };

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
