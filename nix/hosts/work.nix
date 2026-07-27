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
    #
    # Build sandboxes are handled below
    nix.settings = {
      pure-eval = false; # Needed as the path below is out of store
      ssl-cert-file = "/etc/ssl/certs/aikido-nix-ca.pem";
    };

    # catppuccin-nix's whiskers fetches cargo crates over HTTPS during the
    # build, which Aikido intercepts.
    #
    # If I override cacert to trust it, it invalidates the cache of basically
    # everything else in the nix ecosystem, requiring a full build of the
    # universe from source.
    #
    # So I've overridden it just for catppuccin-nix which seems to work
    home-manager.sharedModules = [
      (
        { pkgs, ... }:
        let
          trustedPkgs = pkgs.extend (
            _final: prev: {
              cacert = prev.cacert.override {
                extraCertificateFiles = [
                  (builtins.path {
                    path = "/etc/ssl/certs/aikido-nix-ca.pem";
                    name = "aikido-ca.pem";
                  })
                ];
              };
            }
          );
        in
        {
          catppuccin.sources = (import "${inputs.catppuccin}/default.nix" { pkgs = trustedPkgs; }).packages;
        }
      )
    ];

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
