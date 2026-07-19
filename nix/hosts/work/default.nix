{ self, host, ... }:
{
  imports = [
    ../../modules/darwin/system.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/macos-defaults.nix
  ];

  networking = {
    computerName = host;
    hostName = host;
    localHostName = host;
  };

  system.configurationRevision = self.rev or self.dirtyRev or null;
}
