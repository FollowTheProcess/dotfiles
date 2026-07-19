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
      description = "SSH public key used to sign commits and tags (op-ssh-sign matches it against the 1Password vault).";
    };

    allowedSigners = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "SSH public keys trusted to verify signatures";
    };

    allowedSignersFile = lib.mkOption {
      type = lib.types.path;
      internal = true;
      description = "Generated allowed_signers file";
    };
  };

  options.my.go = {
    private = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Module path prefixes for GOPRIVATE.";
    };
  };
}
