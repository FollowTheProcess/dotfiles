{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      # uv builds sdists if there are no wheels
      home.extraActivationPath = [ pkgs.clang ];

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
