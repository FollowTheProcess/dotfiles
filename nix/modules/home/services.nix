{ pkgs, ... }: {
  services.paneru = {
    enable = true;

    # https://github.com/karinushka/paneru/blob/main/CONFIGURATION.md
    settings = {
      options = {
        focus_follows_mouse = true;
        mouse_follows_focus = true;
        horizontal_mouse_warp = 1;
        animation_speed = 20;
        preset_column_widths = [
          0.50
          0.60
          0.70
          0.80
          0.90
          1.00
        ];
        window_resize_cycle = false;
        auto_center = false;
        reap_empty_workspaces = true;
      };

      bindings = {
        window_focus_west = "ctrl + alt - ,";
        window_focus_east = "ctrl + alt - .";

        window_swap_west = "cmd + ctrl + alt - ,";
        window_swap_east = "cmd + ctrl + alt - .";

        window_resize = "ctrl + alt - ]";
        window_shrink = "ctrl + alt - [";

        window_fullwidth = "ctrl + alt - '";
        window_manage = "ctrl + alt - ;";

        window_balance = "ctrl + alt - b";
        window_snap = "ctrl + alt - \\";

        window_nextdisplay = "cmd + ctrl + alt - ]";

        quit = "ctrl + alt - q";
      };

      swipe = {
        deceleration = 0.4;
        sensitivity = 0.4;
        continuous = false;
        gesture = {
          fingers_count = 3;
          direction = "Natural";
        };
      };

      decorations.inactive.dim.opacity_night = -0.08;

      windows = {
        all = {
          title = ".*";
          horizontal_padding = 6;
          vertical_padding = 0;
          width = 0.5;
        };

        # BrainFM is a little floating menu bar type app; don't try and tile it.
        brainfm = {
          title = ".*";
          bundle_id = "com.electron.brain.fm";
          floating = true;
        };

        # Apple System Settings doesn't tile well and I only want it
        # around for a few seconds to change something.
        settings = {
          title = ".*";
          bundle_id = "com.apple.systempreferences";
          floating = true;
        };

        # The Touch ID / SSH auth prompt gets tiled and can slide off-screen,
        # float 1Password so the popup stays centred and reachable.
        onepassword = {
          title = ".*";
          bundle_id = "com.1password.1password";
          floating = true;
        };
      };
    };
  };

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
}
