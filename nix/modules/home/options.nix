{ lib, ... }: {
  options.my.git = {
    user = lib.mkOption {
      type = lib.types.str;
      default = "Tom Fleet";
      description = "Git author/committer name.";
    };

    email = lib.mkOption {
      type = lib.types.str;
      description = "Git user email."; # Required (no default)
    };

    signingKey = lib.mkOption {
      type = lib.types.str;
      description = "GPG key ID for signing commits and tags";
    };
  };
}
