{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      # clang: uv builds sdists if there are no wheels
      # cctools: gives uv install_name_tool to patch managed Python dylibs
      home.extraActivationPath = [
        pkgs.clang
        pkgs.cctools
      ];

      programs.uv = {
        enable = true;
        python = {
          default = "3.14";
          prune = true;
          versions = [
            "3.11"
            "3.12"
            "3.13"
            "3.14"
          ];
        };
        settings = {
          python-preference = "only-managed";
          compile-bytecode = true;
          preview-features = [ "python-install-default" ];
        };
        tool = {
          packages = [
            "aws-sam-cli"
            "copier"
            "nox"
          ];
          prune = true;
        };
      };
    };
}
