{ ... }: {
  imports = [
    ../../modules/home/packages/common.nix
    ../../modules/home/packages/work.nix
    ../../modules/home/dotfiles.nix
    ../../modules/home/programs
    ../../modules/home/programs/work
    ../../modules/home/services.nix
  ];

  home.stateVersion = "26.11";

  my.git = {
    email = "tfleet@newstore.com";
    # TODO: Replace with actual work GPG key
    signingKey = "PLACEHOLDER";
  };

  my.go.private = [ "gitlab.com/newstore/*" ];
}
