{ self, host, ... }:
{
  imports = [
    ../../modules/darwin/system.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/macos-defaults.nix
  ];

  networking.computerName = host;
  networking.hostName = host;
  networking.localHostName = host;

  system.configurationRevision = self.rev or self.dirtyRev or null;
}
