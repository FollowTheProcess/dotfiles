{ config, ... }: {
  programs.go = {
    enable = true;
    env = {
      GOPATH = "${config.home.homeDirectory}/go";
      GOBIN = "${config.home.homeDirectory}/go/bin";
      GOEXPERIMENT = "jsonv2";
      CGO_ENABLED = "0";
    };
  };

}
