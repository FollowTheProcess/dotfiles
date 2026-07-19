_:
let
  # One key signs every forge; registered on both GitHub and tangled so
  # mirrored commits verify on each.
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuOASBQpM3Ea8fX5chaztxYpbU4tqoN/pqwyjNdyWXo me@followtheprocess.codes";
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
    signingKey = sshKey;
    allowedSigners = [ sshKey ];
  };
}
