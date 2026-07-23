{
  flake.modules.homeManager.macos = { pkgs, ... }: {
    home.packages = [ pkgs.jankyborders ];
    launchd.agents.jankyborders = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.jankyborders}/bin/borders"
          "style=round"
          "width=3.0"
          "hidpi=on"
          "active_color=0xffc6a0f6"
        ];
        RunAtLoad = true;
        KeepAlive = true;
      };
    };
  };
}
