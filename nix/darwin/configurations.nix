{ lib, ... }:
{
  # flake-parts knows nixosConfigurations but not darwinConfigurations, so declare
  # it as a mergeable option — lets each host file contribute its own entry.
  options.flake.darwinConfigurations = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
  };
}
