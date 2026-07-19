{ config, ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        AddKeysToAgent = "yes";
      };
      "tangled.org" = {
        HostName = "tangled.org";
        User = "git";
        IdentityFile = "${config.home.homeDirectory}/.ssh/tangled";
        AddressFamily = "inet";
      };
    };
  };
}
