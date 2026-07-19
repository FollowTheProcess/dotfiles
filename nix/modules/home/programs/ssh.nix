{ config, ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        # Quoted because 'Group Containers' contains a space
        IdentityAgent = ''"${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
      };
      "tangled.org" = {
        HostName = "tangled.org";
        User = "git";
        AddressFamily = "inet";
      };
    };
  };
}
