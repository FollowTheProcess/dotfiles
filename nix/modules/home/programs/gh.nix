{ ... }: {
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      prompt = "enabled";
    };
    hosts = {
      "github.com" = {
        user = "FollowTheProcess";
      };
    };
  };
}
