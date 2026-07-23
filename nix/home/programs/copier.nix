{
  flake.modules.homeManager.base =
    { pkgs, config, ... }:
    let
      yamlFormat = pkgs.formats.yaml { };
    in
    {
      # No programs.copier module, so just dump the config
      xdg.configFile."copier/settings.yml".source = yamlFormat.generate "copier-settings.yml" {
        defaults = {
          github_username = config.my.constants.githubUser;
          author_name = config.my.git.user;
          author_email = config.my.git.email;
        };
        trust = [
          "https://github.com/${config.my.constants.githubUser}/"
          "${config.home.homeDirectory}/Development"
        ];
      };
    };
}
