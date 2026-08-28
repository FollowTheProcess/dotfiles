{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.go = {
        enable = true;
        package = pkgs.go_1_27;
        env = {
          GOPATH = "${config.home.homeDirectory}/go";
          GOBIN = "${config.home.homeDirectory}/go/bin";
          CGO_ENABLED = "0";
        }
        // lib.optionalAttrs (config.my.go.private != [ ]) {
          GOPRIVATE = lib.concatStringsSep "," config.my.go.private;
        };
      };
    };
}
