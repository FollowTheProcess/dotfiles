{
  flake.modules.homeManager.base = { config, lib, ... }: {
    programs.go = {
      enable = true;
      env = {
        GOPATH = "${config.home.homeDirectory}/go";
        GOBIN = "${config.home.homeDirectory}/go/bin";
        GOEXPERIMENT = "jsonv2";
        CGO_ENABLED = "0";
      }
      // lib.optionalAttrs (config.my.go.private != [ ]) {
        GOPRIVATE = lib.concatStringsSep "," config.my.go.private;
      };
    };
  };
}
