{ inputs, ... }:
let
  omniwmLib = inputs.omniwm.lib;
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
        };
        niri.alwaysCenterSingleColumn = true;
        routing = {
          mode = "custom";
          arrangements = [
            (omniwmLib.routingArrangement [
              (omniwmLib.monitor.routing "Built-in Retina Display" {
                monitorDisplayUUID = "37D8832A-2D66-02CA-B9F7-8F30A301B230";
                gridColumn = 0;
                gridRow = 0;
              })
              (omniwmLib.monitor.routing "U32R59x" {
                monitorDisplayUUID = "270847FB-D632-41A1-B905-0431F8A83A60";
                gridColumn = 1;
                gridRow = 0;
              })
            ])
          ];
        };
        workspaces = omniwmLib.workspaces [
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
        ];
      };
    };
  };
}
