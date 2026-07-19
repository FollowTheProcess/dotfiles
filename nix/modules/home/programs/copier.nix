{ pkgs, config, ... }:
let
  yamlFormat = pkgs.formats.yaml { };
in
{
  # No programs.copier module, so just dump the config
  xdg.configFile."copier/settings.yml".source = yamlFormat.generate "copier-settings.yml" {
    defaults = {
      github_username = "FollowTheProcess";
      author_name = "Tom Fleet";
      author_email = "me@followtheprocess.codes";
    };
    trust = [
      "https://github.com/FollowTheProcess/"
      "${config.home.homeDirectory}/Development"
    ];
  };
}
