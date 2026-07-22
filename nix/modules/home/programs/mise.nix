{ config, ... }: {
  programs.mise = {
    enable = true;
    enableZshIntegration = false; # Messes with PATH in `nix develop` shells
    globalConfig = {
      settings = {
        color_theme = "catppuccin";
        trusted_config_paths = [ "${config.home.homeDirectory}/Development" ];
      };
    };
  };
}
