_:
let
  # TODO: Replace with the work GitLab signing public key (ssh-ed25519 AAAA...).
  gitlabKey = "PLACEHOLDER";
in
{
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
    signingKey = gitlabKey;
    allowedSigners = [ gitlabKey ];
  };

  my.go.private = [ "gitlab.com/newstore/*" ];
}
