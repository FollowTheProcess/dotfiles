{ config, ... }: {
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      settings = {
        color_theme = "catppuccin";
        trusted_config_paths = [ "${config.home.homeDirectory}/Development" ];
      };
    };
  };
}
