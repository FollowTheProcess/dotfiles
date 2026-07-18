{ ... }: {
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
    signingKey = "667642356C177BC0";
  };
}
