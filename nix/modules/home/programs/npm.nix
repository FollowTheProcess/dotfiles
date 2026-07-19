_: {
  programs.npm = {
    enable = true;
    settings = {
      # Keep global installs out of the nix store
      prefix = "\${HOME}/.npm";

      save-exact = true;
      update-notifier = false;
      fund = false;

      # Honour a package's "engines" field instead of silently ignoring it.
      engine-strict = true;

      init-license = "MIT";
    };
  };
}
