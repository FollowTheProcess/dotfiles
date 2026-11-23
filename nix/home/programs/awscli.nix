{
  flake.modules.homeManager.base =
    { config, ... }:
    {
      programs.awscli = {
        enable = true;
        configFile = "${config.xdg.configHome}/aws/config";
        credentialsFile = "${config.xdg.configHome}/aws/credentials";
      };
    };
}
