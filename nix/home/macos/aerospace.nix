{
  flake.modules.homeManager.macos = {
    programs.aerospace = {
      enable = true;
      launchd.enable = true;
      launchd.keepAlive = true;
      settings = {
        config-version = 2;
        auto-reload-config = true;
        on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
        automatically-unhide-macos-hidden-apps = true;
        persistent-workspaces = [
          "1"
          "2"
        ];
        focus-follows-mouse.enabled = true;
        gaps = {
          outer = {
            bottom = 10;
            left = 6;
            right = 6;
            top = 6;
          };
          inner = {
            horizontal = 8;
            vertical = 8;
          };
        };

        # Written to be similar to paneru as that seems to fit my brain better,
        # everything starts with ctrl-alt.
        mode.main.binding = {
          # Focus
          ctrl-alt-comma = "focus dfs-prev";
          ctrl-alt-period = "focus dfs-next";

          # Move
          ctrl-alt-cmd-comma = "move left";
          ctrl-alt-cmd-period = "move right";
          ctrl-alt-cmd-up = "move up";
          ctrl-alt-cmd-down = "move down";

          # Resize
          ctrl-alt-leftSquareBracket = "resize smart -100";
          ctrl-alt-rightSquareBracket = "resize smart +100";
          ctrl-alt-quote = "fullscreen";

          # Join/Split
          ctrl-alt-left = "join-with left";
          ctrl-alt-right = "join-with right";

          # Toggle tile/floating
          ctrl-alt-semicolon = "layout floating tiling";

          # Move between monitors
          ctrl-alt-cmd-leftSquareBracket = "move-node-to-monitor --wrap-around prev --focus-follows-window";
          ctrl-alt-cmd-rightSquareBracket = "move-node-to-monitor --wrap-around next --focus-follows-window";
          alt-tab = "workspace next --wrap-around";

          # Reset layout
          ctrl-alt-slash = [
            "flatten-workspace-tree"
            "layout --root tiles horizontal"
          ];
          ctrl-alt-backspace = "close-all-windows-but-current";

          # Disable "hide application", I *always* hit this by mistake
          cmd-h = [ ];
          cmd-alt-h = [ ];

          # Workspace selection
          ctrl-alt-1 = "workspace 1";
          ctrl-alt-2 = "workspace 2";
          ctrl-alt-3 = "workspace 3";
          ctrl-alt-4 = "workspace 4";

          # Numpad equivalents
          ctrl-alt-keypad1 = "workspace 1";
          ctrl-alt-keypad2 = "workspace 2";
          ctrl-alt-keypad3 = "workspace 3";
          ctrl-alt-keypad4 = "workspace 4";

          # Node moves
          ctrl-alt-cmd-1 = "move-node-to-workspace 1";
          ctrl-alt-cmd-2 = "move-node-to-workspace 2";
          ctrl-alt-cmd-3 = "move-node-to-workspace 3";
          ctrl-alt-cmd-4 = "move-node-to-workspace 4";

          # Numpad equivalent for those
          ctrl-alt-cmd-keypad1 = "move-node-to-workspace 1";
          ctrl-alt-cmd-keypad2 = "move-node-to-workspace 2";
          ctrl-alt-cmd-keypad3 = "move-node-to-workspace 3";
          ctrl-alt-cmd-keypad4 = "move-node-to-workspace 4";
        };

        workspace-to-monitor-force-assignment = {
          "1" = "main";
          "2" = "secondary";
        };

        # Apps that don't play nicely with tiling
        on-window-detected = [
          # Apple system settings don't tile and I typically only have it open
          # for a second to change something anyway
          {
            "if" = "test %{app-bundle-id} = com.apple.systempreferences";
            run = "layout floating";
          }
          # BrainFM is a menu bar app that doesn't tile
          {
            "if" = "test %{app-bundle-id} = com.electron.brain.fm";
            run = "layout floating";
          }
          # Docker seems to constantly hang over screen edges
          {
            "if" = "test %{app-bundle-id} = com.electron.dockerdesktop";
            run = "layout floating";
          }
        ];
      };
    };
  };
}
