{ inputs, ... }:
let
  omniwmLib = inputs.omniwm.lib;

  main = {
    monitorAssignment.type = "main";
  };

  secondary = {
    monitorAssignment.type = "secondary";
  };

  workspaceLayout = [
    main
    main
    main
    main
    main
    secondary
    secondary
    secondary
    secondary
  ];

  # Plain Option+<n> would swallow Option+3, the only way to type "#" on the British layout.
  workspaceHotkeys = builtins.listToAttrs (
    builtins.concatLists (
      builtins.genList (index: [
        {
          name = "switchWorkspace.${toString index}";
          value = "Option+Command+${toString (index + 1)}";
        }
        {
          name = "moveToWorkspace.${toString index}";
          value = "Control+Option+Command+${toString (index + 1)}";
        }
      ]) (builtins.length workspaceLayout)
    )
  );
in
{
  flake.modules.homeManager.macos = {
    imports = [ inputs.omniwm.homeManagerModules.default ];

    programs.omniwm = {
      enable = true;
      # External monitors sometimes mint new display UUIDs so rather than keeping an ever-growing
      # list in here I'm just delegating that setting the OmniWM UI.
      preserveSettings = [ "routing.arrangements" ];
      settings = {
        general.defaultLayoutType = "niri";
        borders = {
          width = 2.0;
          color = omniwmLib.colors.fromHex "#c6a0f6";
        };
        gaps = {
          size = 10.0;
          fullscreenUsesOuterGaps = true;
          outer = {
            top = 10.0;
            bottom = 10.0;
            left = 10.0;
            right = 10.0;
          };
        };
        niri = {
          alwaysCenterSingleColumn = true;
          edgeGaps = false;
        };
        workspaceBar.notchMode = "rightOfNotch";
        mouseWarp.constrainToArrangement = true;
        routing.mode = "custom";
        hotkeys = omniwmLib.hotkeys (
          {
            "moveWindowToMonitor.left" = "Option+Command+Left Arrow";
            "moveWindowToMonitor.right" = "Option+Command+Right Arrow";
          }
          // workspaceHotkeys
        );
        workspaces = omniwmLib.workspaces workspaceLayout;
      };
    };
  };
}
