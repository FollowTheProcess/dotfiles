{ inputs, ... }:
let
  omniwmLib = inputs.omniwm.lib;

  builtinUUID = "37D8832A-2D66-02CA-B9F7-8F30A301B230";
  externalUUID = "E0BAF710-4BE5-445E-9A5F-D4C092EF9912";

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
          value = "Option+Command+Shift+${toString (index + 1)}";
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
      # Stop omniwm overwriting these across switches
      preserveSettings = [ "monitors" ];
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
        monitorGapOverrides = [
          (omniwmLib.monitor.gap "U32R59x" {
            monitorDisplayUUID = externalUUID;
            outerGapTop = 40.0;
          })
          (omniwmLib.monitor.gap "Built-in Retina Display" {
            monitorDisplayUUID = builtinUUID;
            outerGapTop = 48.0;
          })
        ];
        niri = {
          alwaysCenterSingleColumn = true;
          edgeGaps = false;
        };
        workspaceBar.notchMode = "rightOfNotch";
        mouseWarp.constrainToArrangement = true;
        routing = {
          mode = "custom";
          arrangements = [
            (omniwmLib.routingArrangement [
              (omniwmLib.monitor.routing "Built-in Retina Display" {
                monitorDisplayUUID = builtinUUID;
                gridColumn = 0;
                gridRow = 0;
              })
              (omniwmLib.monitor.routing "U32R59x" {
                monitorDisplayUUID = externalUUID;
                gridColumn = 1;
                gridRow = 0;
              })
            ])
          ];
        };
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
