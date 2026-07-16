{ ... }: {
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";

    matchBlocks = {
      "tangled.org" = {
        hostname = "tangled.org";
        user = "git";
        identityFile = "~/.ssh/tangled";
        addressFamily = "inet";
      };
    };
  };
}
