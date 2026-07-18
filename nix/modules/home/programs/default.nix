{ lib, ... }:
let
  # Glob every *.nix under here (excluding this file)
  # so I can't forget an import!
  moduleFiles = lib.filterAttrs (
    name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
  ) (builtins.readDir ./.);
in
{
  imports = lib.mapAttrsToList (name: _: ./. + "/${name}") moduleFiles;

  # Let home-manager manage itself, not worth it's own file
  programs.home-manager.enable = true;
}
