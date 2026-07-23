{ lib, ... }:
{
  flake.modules.generic.constants.options.my.constants = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "tomfleet";
      description = "Local macOS account username.";
    };

    githubUser = lib.mkOption {
      type = lib.types.str;
      default = "FollowTheProcess";
      description = "GitHub handle (canonical title-case).";
    };
  };
}
