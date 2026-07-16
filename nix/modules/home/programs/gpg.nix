{ pkgs, ... }: {
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry_mac;
  };
}
