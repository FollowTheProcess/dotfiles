_:
let
  githubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuOASBQpM3Ea8fX5chaztxYpbU4tqoN/pqwyjNdyWXo me@followtheprocess.codes";
  tangledKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBh2ujFLCCALVuSvINR8t00EV/BneIypxLN+29yR8lo5 me@followtheprocess.codes";
in
{
  imports = [
    ../../modules/home/packages/common.nix
    ../../modules/home/packages/onyx.nix
    ../../modules/home/dotfiles.nix
    ../../modules/home/programs
    ../../modules/home/services.nix
  ];

  home.stateVersion = "26.11";

  my.git = {
    email = "me@followtheprocess.codes";

    # GitHub is the default, tangled remotes sign with its own key.
    signingKey = githubKey;
    signingKeyOverrides."hasconfig:remote.*.url:git@tangled.org:**" = tangledKey;

    # Both keys trusted so signatures verify whichever forge signed.
    allowedSigners = [
      githubKey
      tangledKey
    ];
  };
}
