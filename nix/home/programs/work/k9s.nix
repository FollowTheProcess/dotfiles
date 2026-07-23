{
  flake.modules.homeManager.work = {
    catppuccin.k9s.transparent = true;
    programs.k9s = {
      enable = true;
      settings = {
        ui = {
          logoless = true;
        };
      };
      aliases = {
        dp = "deployments";
        sec = "v1/secrets";
        jo = "jobs";
        cr = "clusterroles";
        crb = "clusterrolebindings";
        ro = "roles";
        rb = "rolebindings";
        np = "networkpolicies";
      };
    };
  };
}
