{ self, host, ... }:
{
  imports = [
    ../../modules/darwin/system.nix
    ../../modules/darwin/homebrew/common.nix
    ../../modules/darwin/homebrew/onyx.nix
    ../../modules/darwin/macos.nix
    ../../modules/darwin/zed-cli.nix
  ];

  networking = {
    computerName = host;
    hostName = host;
    localHostName = host;
  };

  system.configurationRevision = self.rev or self.dirtyRev or null;
}
