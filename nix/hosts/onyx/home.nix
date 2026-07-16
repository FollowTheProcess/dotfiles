{ ... }: {
  imports = [
    ../../modules/home/packages.nix
    ../../modules/home/dotfiles.nix
    ../../modules/home/programs
    ../../modules/home/services.nix
  ];

  home.stateVersion = "26.11";
}
