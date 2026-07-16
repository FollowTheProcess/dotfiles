{ self, ... }: {
  imports = [
    ../../modules/darwin/system.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/macos-defaults.nix
  ];

  networking.computerName = "onyx";
  networking.hostName = "onyx";
  networking.localHostName = "onyx";

  system.configurationRevision = self.rev or self.dirtyRev or null;
}
